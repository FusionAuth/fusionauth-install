#!/usr/bin/env bash

# shellcheck disable=SC2115
set -e

print_usage() {
  echo "FusionAuth FastPath(tm) installer"
  echo ""
  echo "Usage:"
  echo "  ./install.sh [options]"
  echo ""
  echo "OPTIONS:"
  echo "  -s   Include the search engine with this install. Defaults to database search if this is not present."
  echo "  -h   Display this message."
  echo ""
  echo "Environment:"
  echo "  TARGET_DIR  Choose a location to install to if using the zip. Defaults to \$PWD/fusionauth."
  echo "  VERSION     Choose a version to install. Defaults to the latest stable version."
}

install_zip() {
  if ! hash unzip >/dev/null 2>&1; then
    echo "unzip is required to unzip the zip archives. Install unzip and try again."
    exit 1
  fi

  echo "Downloading zip packages"

  curl -fSL --progress-bar -o /tmp/fusionauth-app.zip "${BASE_URL}/${VERSION}/fusionauth-app-${VERSION}.zip"

  if [[ ${INCLUDE_SEARCH} == 1 ]]; then
    curl -fSL --progress-bar -o /tmp/fusionauth-search.zip "${BASE_URL}/${VERSION}/fusionauth-search-${VERSION}.zip"
  fi

  if [[ ! -d ${TARGET_DIR} ]]; then
    mkdir -p "${TARGET_DIR}"
  else
    # Remove the existing directories (We won't overwrite otherwise)
    rm -rf "${TARGET_DIR}/fusionauth-app"
    rm -rf "${TARGET_DIR}/fusionauth-search"
    rm -rf "${TARGET_DIR}/bin"
  fi

  echo "Installing packages"

  # Install search first so that we get the search version of fusionauth.properties
  if [[ ${INCLUDE_SEARCH} == 1 ]]; then
    unzip -nq /tmp/fusionauth-search.zip -d "${TARGET_DIR}"
  fi

  unzip -nq /tmp/fusionauth-app.zip -d "${TARGET_DIR}"
}

if ! hash curl > /dev/null 2>&1; then
  echo "curl is required to download the packages and determine version. Install curl and try again."
  exit 1
fi

BASE_URL="https://files.fusionauth.io/products/fusionauth"
INCLUDE_SEARCH=0

# Download to the current working directory or the environment variable (as long as it isn't empty)
TARGET_DIR=${TARGET_DIR:-$(pwd)/fusionauth}
if [[ ${TARGET_DIR} == "" ]]; then
  TARGET_DIR=$(pwd)
fi

while getopts 'hs' opt; do
  case "${opt}" in
  h)
    print_usage
    exit 0
    ;;
  s)
    INCLUDE_SEARCH=1
    ;;
  *)
    print_usage
    exit 1
    ;;
  esac
done

# Use the VERSION variable or get the latest version of FusionAuth if its not present
VERSION=${VERSION:-$(curl -s https://metrics.fusionauth.io/api/latest-version)}

install_zip

echo ""
echo "Install is complete. Time for tacos."
echo ""
echo "1. To start FusionAuth run the following command"
echo "    ${TARGET_DIR}/bin/startup.sh"
echo ""
echo "2. To begin, access FusionAuth by opening a browser to http://localhost:9011"
echo ""
echo "3. If you're looking for documentation, open your browser and navigate to https://fusionauth.io/docs"
echo ""
echo "Thank you for using FusionAuth. Happy coding!"
