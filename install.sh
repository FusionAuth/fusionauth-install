#!/usr/bin/env bash

if ! hash curl > /dev/null 2>&1; then
    echo "curl is required to download the packages and determine version. Install curl and try again."
    exit 1
fi

FORCE_ZIP=0
SUFFIX=""
TARGET_DIR=${TARGET_DIR:-${HOME}/fusionAuth} # Default to home/fusionAuth but keep any existing value.
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
  if [[ ${FORCE_ZIP} != 1 ]] && hash dpkg > /dev/null 2>&1; then
    install_deb;
  elif [[ ${FORCE_ZIP} != 1 ]] && hash rpm > /dev/null 2>&1; then
    install_rpm;
  else
    install_zip;
  fi
}

install_deb() {
  echo "Installing deb packages"

  curl -fSL -o /tmp/fusionAuth-app.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-app_${VERSION}-1_all.deb"
  curl -fSL -o /tmp/fusionAuth-search.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-search_${VERSION}-1_all.deb"

  sudo dpkg -i /tmp/fusionAuth-app.deb /tmp/fusionAuth-search.deb
}

install_rpm() {
  echo "Installing rpm packages"

  curl -fSL -o /tmp/fusionAuth-app.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-app-${VERSION}-1.noarch.rpm"
  curl -fSL -o /tmp/fusionAuth-search.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-search-${VERSION}-1.noarch.rpm"

  sudo rpm -i /tmp/fusionAuth-app.rpm /tmp/fusionAuth-search.rpm
}

install_zip() {
  echo "Installing zip packages to ${TARGET_DIR}"

  curl -fSL -o /tmp/fusionAuth-app.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-app-${SUFFIX}${VERSION}.zip"
  curl -fSL -o /tmp/fusionAuth-search.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${VERSION}/fusionauth-search-${SUFFIX}${VERSION}.zip"

  mkdir -p ${TARGET_DIR}

  unzip -n /tmp/fusionAuth-app.zip -d ${TARGET_DIR}
  unzip -n /tmp/fusionAuth-search.zip -d ${TARGET_DIR}

  mv ${TARGET_DIR}/fusionauth-app-${VERSION} ${TARGET_DIR}/fusionAuth-app
  mv ${TARGET_DIR}/fusionauth-search-${VERSION} ${TARGET_DIR}/fusionAuth-search
}

case $(uname -s) in
    Linux*)     install_linux;;
    Darwin*)    SUFFIX="macos-"; install_zip;;
    *)          echo "Unsupported platform, will attempt the zip install"; install_zip;;
esac

echo "Done. Time for tacos."
