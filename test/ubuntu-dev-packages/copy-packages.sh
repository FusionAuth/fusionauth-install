#!/usr/bin/env bash
if [[ $# != 1 ]]; then
  echo "Usage: copy-packages <version>";
  exit 1
fi

if ! [ -f ../../../fusionauth-app/build/bundles/fusionauth-app_${1}-1_all.deb ]; then
  echo "You must build the fusionauth-app RPM bundle first"
  exit 1
fi

if ! [ -f ../../../fusionauth-search/build/bundles/fusionauth-search_${1}-1_all.deb ]; then
  echo "You must build the fusionauth-app RPM bundle first"
  exit 1
fi

cp ../../../fusionauth-app/build/bundles/fusionauth-app_${1}-1_all.deb fusionauth-app.deb
cp ../../../fusionauth-search/build/bundles/fusionauth-search_${1}-1_all.deb fusionauth-search.deb
