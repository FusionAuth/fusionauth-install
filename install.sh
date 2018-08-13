#!/usr/bin/env bash

TARGET_DIR=${HOME}/fusionauth
VERSION=$(curl https://www.inversoft.com/latest-passport-version)
SUFFIX=""

install_linux() {
  # Detect dpkg and rpm, fallback to zip
  if hash dpkg; then
    install_deb;
  elif hash rpm; then
    install_rpm;
  else
    install_zip;
  fi
}

install_deb() {
  curl -fsSL -o /tmp/fusionAuth-backend.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend_${VERSION}-1_all.deb"
  curl -fsSL -o /tmp/fusionAuth-search-engine.deb "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine_${VERSION}-1_all.deb"

  sudo dpkg -i /tmp/fusionAuth-backend.deb /tmp/fusionAuth-search-engine.deb
}

install_rpm() {
  curl -fsSL -o /tmp/fusionAuth-backend.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend-${VERSION}-1.noarch.rpm"
  curl -fsSL -o /tmp/fusionAuth-search-engine.rpm "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine-${VERSION}-1.noarch.rpm"

  sudo rpm -i /tmp/fusionAuth-backend.rpm /tmp/fusionAuth-search-engine.rpm
}

install_zip() {
  curl -fsSL -o /tmp/fusionAuth-backend.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-backend-${SUFFIX}${VERSION}.zip"
  curl -fsSL -o /tmp/fusionAuth-search-engine.zip "https://storage.googleapis.com/inversoft_products_j098230498/products/passport/${VERSION}/passport-search-engine-${SUFFIX}${VERSION}.zip"

  sudo mkdir -p ${TARGET_DIR}

  unzip /tmp/fusionAuth-backend.zip -n -d ${TARGET_DIR}
  unzip /tmp/fusionAuth-search-engine.zip -n -d ${TARGET_DIR}
}

case $(uname -s) in
    Linux*)     install_linux;;
    Darwin*)    SUFFIX="macos-"; install_zip;;
    *)          echo "Unsupported platform, will attempt the zip install"; install_zip;;
esac

echo "Done. Time for tacos."
