#!/usr/bin/env bash
if [[ $# != 1 ]]; then
  echo "Usage: copy-packages <version>";
  exit 1
fi

if ! [ -f ../../../fusionauth-app/build/bundles/fusionauth-app-${1}-1.noarch.rpm ]; then
  echo "You must build the fusionauth-app RPM bundle first"
  exit 1
fi

if ! [ -f ../../../fusionauth-search/build/bundles/fusionauth-search-${1}-1.noarch.rpm ]; then
  echo "You must build the fusionauth-app RPM bundle first"
  exit 1
fi

cp ../../../fusionauth-app/build/bundles/fusionauth-app-${1}-1.noarch.rpm fusionauth-app.rpm
cp ../../../fusionauth-search/build/bundles/fusionauth-search-${1}-1.noarch.rpm fusionauth-search.rpm
