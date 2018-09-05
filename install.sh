#!/usr/bin/env bash

if ! hash curl > /dev/null 2>&1; then
    echo "curl is required to download the packages and determine version. Install curl and try again."
    exit 1
fi

BASE_URL="https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth"
FORCE_ZIP=0
# Download to the current working directory
TARGET_DIR=${TARGET_DIR:-$(pwd)/fusionauth}
VERSION=$(curl https://www.inversoft.com/api/fusionauth/latest-version)

print_usage() {
    echo "FusionAuth installer"
    echo ""
    echo "./install [options]"
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
    echo "Installing deb packages"

    curl -fSL -o /tmp/fusionauth-app.deb "${BASE_URL}/${VERSION}/fusionauth-app_${VERSION}-1_all.deb"
    curl -fSL -o /tmp/fusionauth-search.deb "${BASE_URL}/${VERSION}/fusionauth-search_${VERSION}-1_all.deb"

    sudo dpkg -i /tmp/fusionauth-app.deb /tmp/fusionauth-search.deb
}

install_rpm() {
    echo "Installing rpm packages"

    curl -fSL -o /tmp/fusionauth-app.rpm "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}-1.noarch.rpm"
    curl -fSL -o /tmp/fusionauth-search.rpm "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}-1.noarch.rpm"

    sudo rpm -i /tmp/fusionauth-app.rpm /tmp/fusionauth-search.rpm
}

install_zip() {
    if ! hash unzip > /dev/null 2>&1; then
        echo "unzip is required to unzip the zip archives. Install unzip and try again."
        exit 1
    fi

    echo "Installing zip packages"

    curl -fSL -o /tmp/fusionauth-app.zip "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}.zip"
    curl -fSL -o /tmp/fusionauth-search.zip "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}.zip"

    if [ ! -d ${TARGET_DIR} ]; then
         mkdir -p ${TARGET_DIR}
    else
         # Remove the existing directories (We won't overwrite otherwise)
         if [ -d ${TARGET_DIR}/fusionauth-app ]; then
             rm -rf ${TARGET_DIR}/fusionauth-app
         fi
         if [ -d ${TARGET_DIR}/fusionauth-search ]; then
             rm -rf ${TARGET_DIR}/fusionauth-search
         fi
    fi

    unzip -n /tmp/fusionauth-app.zip -d ${TARGET_DIR}
    unzip -n /tmp/fusionauth-search.zip -d ${TARGET_DIR}
}

case $(uname -s) in
    Linux*)     install_linux;;
    Darwin*)    install_zip;;
    *)          echo "Unsupported platform, will attempt the zip install"; install_zip;;
esac

echo "Done. Time for tacos."
