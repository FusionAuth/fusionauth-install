#!/usr/bin/env bash

# Default to home/fusionAuth but keep any existing value.
TARGET_DIR=${TARGET_DIR:-${HOME}/fusionAuth}
VERSION=$(curl https://www.inversoft.com/latest-passport-version)
SUFFIX=""

install_linux() {
  # Detect dpkg and rpm, fallback to zip
  if hash dpkg > /dev/null 2>&1; then
    install_deb;
  elif hash rpm > /dev/null 2>&1; then
    install_rpm;
  else
    install_zip;
  fi
}

install_deb() {
  echo "Installing deb packages"

  curl -fSL -o /tmp/fusionAuth-backend.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend_${VERSION}-1_all.deb"
  curl -fSL -o /tmp/fusionAuth-search-engine.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine_${VERSION}-1_all.deb"

  sudo dpkg -i /tmp/fusionAuth-backend.deb /tmp/fusionAuth-search-engine.deb
}

install_rpm() {
  echo "Installing rpm packages"

  curl -fSL -o /tmp/fusionAuth-backend.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend-${VERSION}-1.noarch.rpm"
  curl -fSL -o /tmp/fusionAuth-search-engine.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine-${VERSION}-1.noarch.rpm"

  sudo rpm -i /tmp/fusionAuth-backend.rpm /tmp/fusionAuth-search-engine.rpm
}

install_zip() {
  echo "Installing zip packages to ${TARGET_DIR}"

  curl -fSL -o /tmp/fusionAuth-backend.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend-${SUFFIX}${VERSION}.zip"
  curl -fSL -o /tmp/fusionAuth-search-engine.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine-${SUFFIX}${VERSION}.zip"

  mkdir -p ${TARGET_DIR}

  unzip -n /tmp/fusionAuth-backend.zip -d ${TARGET_DIR}
  unzip -n /tmp/fusionAuth-search-engine.zip -d ${TARGET_DIR}

  ln -sf ${TARGET_DIR}/passport-backend-${VERSION} ${TARGET_DIR}/fusionAuth-backend
  ln -sf ${TARGET_DIR}/passport-search-engine-${VERSION} ${TARGET_DIR}/fusionAuth-search-engine
}

case $(uname -s) in
    Linux*)     install_linux;;
    Darwin*)    SUFFIX="macos-"; install_zip;;
    *)          echo "Unsupported platform, will attempt the zip install"; install_zip;;
esac

echo "Done. Time for tacos."
