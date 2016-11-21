#!/bin/bash

set -e

if [[ -f /output/.novolume ]]; then
    echo "Missing -v /your/output/path:/output argument to docker"
    exit
fi

if [[ $# -eq 0 ]]; then
    SEARCH_VERSION="*"
else
    SEARCH_VERSION=$1
fi

ZIPS=( $(find /output -maxdepth 1 -type f -name "ceylon-${SEARCH_VERSION}.zip" -printf '%f\n') )
if [[ ${#ZIPS[@]} -eq 0 ]]; then
    echo "No Ceylon source zip file found"
    exit
elif [[ ${#ZIPS[@]} -ne 1 ]]; then
    echo "Multiple Ceylon source zip files found, please specify version argument"
    exit
else
    CEYLON_VERSION=$(echo ${ZIPS[0]} | sed -r 's/ceylon-(.*).zip/\1/')
fi

mkdir build
cd build
unzip /output/ceylon-${CEYLON_VERSION}.zip
mv ceylon-${CEYLON_VERSION} ceylon
export PATH=${PATH}:${HOME}/build/ceylon/bin
wget https://github.com/ceylon/ceylon-sdk/archive/${CEYLON_VERSION}.zip
unzip ${CEYLON_VERSION}.zip
cd ceylon-sdk-${CEYLON_VERSION}
ant clean dist
sudo rm -rf /output/sdk-modules-${CEYLON_VERSION}
sudo cp -a modules /output/sdk-modules-${CEYLON_VERSION}

