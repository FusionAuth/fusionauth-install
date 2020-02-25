#!/usr/bin/env bash

if ! hash curl > /dev/null 2>&1; then
    echo "curl is required to download the packages and determine version. Install curl and try again."
    exit 1
fi

BASE_URL="https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth"
FORCE_ZIP=0
# Download to the current working directory
TARGET_DIR=${TARGET_DIR:-$(pwd)/fusionauth}

print_usage() {
    echo "FusionAuth installer"
    echo ""
    echo "./install.sh [options]"
    echo ""
    echo "options:"
    echo "-z   Force install using a zip file even if a supported package system is detected"
}

while getopts 'hz' opt
do
    case "${opt}" in
        h)
            print_usage
            exit 0
            ;;
        z)
            FORCE_ZIP=1
            ;;
        *)
            print_usage
            exit 1
            ;;
    esac
done

install_linux() {
    # Detect dpkg and rpm, fallback to zip
    if [ "${FORCE_ZIP}" -ne "1" ] && hash dpkg > /dev/null 2>&1; then
        install_deb;
    elif [ "${FORCE_ZIP}" -ne "1" ] && hash rpm > /dev/null 2>&1; then
        install_rpm;
    else
        install_zip;
    fi
}

install_deb() {
    echo "Downloading deb packages"
    curl -fSL --progress-bar -o /tmp/fusionauth-app.deb "${BASE_URL}/${VERSION}/fusionauth-app_${VERSION}-1_all.deb"
    curl -fSL --progress-bar -o /tmp/fusionauth-search.deb "${BASE_URL}/${VERSION}/fusionauth-search_${VERSION}-1_all.deb"

    echo "Installing deb packages"
    sudo dpkg -i /tmp/fusionauth-app.deb /tmp/fusionauth-search.deb

    # Ensure we completed the sudo request
    if [  $? -ne 0 ] ; then
        exit 0;
    fi

    echo ""
    echo "Install is complete. Time for tacos."
    echo ""
    echo " 1. To start FusionAuth run the following commands"
    echo "    sudo service fusionauth-search start"
    echo "    sudo service fusionauth-app start"
}

install_rpm() {
    echo "Downloading RPM packages"

    curl -fSL --progress-bar -o /tmp/fusionauth-app.rpm "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}-1.noarch.rpm"
    curl -fSL --progress-bar -o /tmp/fusionauth-search.rpm "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}-1.noarch.rpm"

    echo "Installing rpm packages"
    sudo rpm -U /tmp/fusionauth-app.rpm /tmp/fusionauth-search.rpm

    # Ensure we completed the sudo request
    if [  $? -ne 0 ] ; then
        exit 0;
    fi

    echo ""
    echo "Install is complete. Time for tacos."
    echo ""
    echo " 1. To start FusionAuth run the following commands"
    echo "    sudo service fusionauth-search start"
    echo "    sudo service fusionauth-app start"
}

install_zip() {
    if ! hash unzip > /dev/null 2>&1; then
        echo "unzip is required to unzip the zip archives. Install unzip and try again."
        exit 1
    fi

    echo "Downloading zip packages"

    curl -fSL --progress-bar -o /tmp/fusionauth-app.zip "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}.zip"
    curl -fSL --progress-bar -o /tmp/fusionauth-search.zip "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}.zip"

    if [ ! -d ${TARGET_DIR} ]; then
         mkdir -p ${TARGET_DIR}
    else
         # Remove the existing directories (We won't overwrite otherwise)
         rm -rf ${TARGET_DIR}/fusionauth-app
         rm -rf ${TARGET_DIR}/fusionauth-search
         rm -rf ${TARGET_DIR}/bin
    fi

    echo "Installing packages"

    unzip -nq /tmp/fusionauth-app.zip -d ${TARGET_DIR}
    unzip -nq /tmp/fusionauth-search.zip -d ${TARGET_DIR}

    echo ""
    echo "Install is complete. Time for tacos."
    echo ""
    echo " 1. To start FusionAuth run the following command"
    echo "    ${TARGET_DIR}/bin/startup.sh"
}

# Get the latest version of FusionAuth
VERSION=$(curl -s https://metrics.fusionauth.io/api/latest-version)

case $(uname -s) in
    Linux*)     install_linux;;
    Darwin*)    install_zip;;
    *)          echo "Unsupported platform, will attempt the zip install"; install_zip;;
esac

echo ""
echo " 2. To begin, access FusionAuth by opening a browser to http://localhost:9011"
echo ""
echo " 3. If you're looking for documentation, open your browser and navigate to https://fusionauth.io/docs"
echo ""
echo "Thank you have a nice day."
