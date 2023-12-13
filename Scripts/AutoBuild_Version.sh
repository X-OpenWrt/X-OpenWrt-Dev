#!/bin/bash
OPENWRT_BUILD_DIR=${GITHUB_WORKSPACE}/openwrt
find ${OPENWRT_BUILD_DIR}/package -type f | grep Makefile > ${GITHUB_WORKSPACE}/version.cache
find ${OPENWRT_BUILD_DIR}/package -type f | grep Makefile >> ${GITHUB_WORKSPACE}/version.cache
while read -r make_path
do
        make_name_all=${make_path%/*}
        make_name=${make_name_all##*/}
        pkg_version=`cat $make_path | grep PKG_VERSION:=`
        if  [ "$pkg_version" = "" ]
        then
                pkg_version=`cat $make_path | grep PKG_VERSION=`
        fi
        # echo $pkg_version
        # echo $make_name_all
        pkg_version=${pkg_version#*=}
        name_version=$make_name"="$pkg_version
        if [ "$pkg_version" != "" ]
        then
                echo $name_version >> ${GITHUB_WORKSPACE}/make.version
                echo $name_version

        fi
done < "version.cache"