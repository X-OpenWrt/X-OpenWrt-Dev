#!/bin/bash
OPENWRT_BUILD_DIR=${GITHUB_WORKSPACE}/openwrt
find ${OPENWRT_BUILD_DIR}/package -type f | grep Makefile > ${GITHUB_WORKSPACE}/version.cache
find ${OPENWRT_BUILD_DIR}/feeds -type f | grep Makefile >> ${GITHUB_WORKSPACE}/version.cache

X_LINUX_VERSION=`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_PATCHVER:=`
X_LINUX_VERSION_TESTING=`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_TESTING_PATCHVER:=`
echo LINUX_VERSION=${X_LINUX_VERSION} > ${GITHUB_WORKSPACE}/make.version
echo LINUX_VERSION_TESTING=${X_LINUX_VERSION_TESTING} >> ${GITHUB_WORKSPACE}/make.version
while read -r make_path
do
        make_name_all=${make_path%/*}
        make_name=${make_name_all##*/}

        pkg_version=`cat $make_path | grep PKG_VERSION:=`
	if ["$make_name" = "dnsmasq"]
	then
                pkg_version=`cat $make_path | grep PKG_UPSTREAM_VERSION:=`
	fi

	if ["$make_name" = "ppp"]
	then
                pkg_version=`cat $make_path | grep PKG_RELEASE_VERSION:=`
	fi

	if ["$make_name" = "bpf-headers"]
	then
                pkg_version=`cat $make_path | grep PKG_PATCHVER:=`
	fi

        if ["$make_name" = "dsl-vrx200-firmware-xdsl"]
        then
                pkg_version=""
        fi

        if ["$make_name" = "perf"]
        then
                pkg_version=${X_LINUX_VERSION}
        fi

        if  [ "$pkg_version" = "" ]
        then
                pkg_version=`cat $make_path | grep PKG_VERSION=`
        fi

        # echo $pkg_version
        # echo $make_name_all

        if [ "$make_name" = "binutils" ]
        then
                pkg_version=`echo $pkg_version | sed s/[[:space:]]//g`
                pkg_version=${pkg_version%*PKG_VERSION}
        fi
        pkg_version=${pkg_version#*=}
        name_version=$make_name"="$pkg_version
        if [ "$pkg_version" != "" ]
        then
                echo $name_version >> ${GITHUB_WORKSPACE}/make.version
                echo $name_version

        fi
done < "version.cache"