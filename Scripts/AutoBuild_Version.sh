#!/bin/bash

Check_Version(){
        pkg_line=$1
        pkg_name=${pkg_line%=*}
        pkg_new_version=${pkg_line#*=}
        pkg_info=`cat last.version | grep "^$pkg_name=" -m 1 `
        pkg_old_version=${pkg_info#*=}
        if [ "$pkg_old_version" != "$pkg_new_version" ]
        then
                if [ "$pkg_old_version" != "" ]
                then
                        echo ${pkg_name}:"$pkg_old_version>>$pkg_new_version" >>diff.log
                        echo ${pkg_name}:"$pkg_old_version>>$pkg_new_version"
                else
                        echo "Add ${pkg_name}" >> diff.log 
                fi
        fi

}

OPENWRT_BUILD_DIR=${GITHUB_WORKSPACE}/openwrt
find ${OPENWRT_BUILD_DIR}/package -type f | grep Makefile > ${GITHUB_WORKSPACE}/version.cache
find ${OPENWRT_BUILD_DIR}/feeds -type f | grep Makefile >> ${GITHUB_WORKSPACE}/version.cache

X_LINUX_VERSION=`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_PATCHVER:=`
X_LINUX_VERSION_TESTING=`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_TESTING_PATCHVER:=`
X_LINUX_VERSION=${X_LINUX_VERSION#*=}
X_LINUX_VERSION_TESTING=${X_LINUX_VERSION_TESTING#*=}
echo LINUX_VERSION=${X_LINUX_VERSION} > ${GITHUB_WORKSPACE}/make.version
echo LINUX_VERSION_TESTING=${X_LINUX_VERSION_TESTING} >> ${GITHUB_WORKSPACE}/make.version
while read -r make_path
do
        make_name_all=${make_path%/*}
        make_name=${make_name_all##*/}

        pkg_version=`cat $make_path | grep "\bPKG_VERSION:=" -m 1`
	if [ "$make_name" = "dnsmasq" ]
	then
                pkg_version=`cat $make_path | grep PKG_UPSTREAM_VERSION:=`
	fi

	if [ "$make_name" = "ppp" ]
	then
                pkg_version=`cat $make_path | grep PKG_RELEASE_VERSION:=`
	fi

	if [ "$make_name" = "bpf-headers" ]
	then
                pkg_version=`cat $make_path | grep PKG_PATCHVER:=`
	fi

        if [ "$make_name" = "dsl-vrx200-firmware-xdsl" ]
        then
                pkg_version=""
        fi

        if [ "$make_name" = "UnblockNeteaseMusic" ]
        then
                pkg_version=""
        fi
        if [ "$make_name" = "perf" ]
        then
                pkg_version=${X_LINUX_VERSION}
        fi

        if  [ "$pkg_version" = "" ]
        then
                pkg_version=`cat $make_path | grep "\bPKG_VERSION="`
        fi

        # echo $pkg_version
        # echo $make_name_all

        if [ "$make_name" = "binutils" ]
        then
                # pkg_version=`echo $pkg_version | sed s/[[:space:]]//g`
                pkg_version=${pkg_version%*PKG_VERSION}
        fi
        
        # if [ "$make_name" = "dockerd" ]
        # then
        #         pkg_version=`echo $pkg_version | sed s/[[:space:]]//g`
        #         pkg_version=${pkg_version%*DEP_VER}
        # fi

        pkg_version=${pkg_version#*=}
        name_version=$make_name"="$pkg_version
        if [ "$pkg_version" != "" ]
        then
                echo $name_version >> ${GITHUB_WORKSPACE}/make.version
                # echo $name_version

        fi
done < "version.cache"

wget https://api.github.com/repos/X-OpenWrt/X-OpenWrt-Dev/releases -O releases.json
cat releases.json | jq  '.[].tag_name' -r > version.old
echo ${NOW_DATA_VERSION}
diff_version=v2023-1-1
while read -r last_version
do
        if [[ "$last_version" != "AutoUpdate" ]]
        then
                if [[ "$last_version" < ${NOW_DATA_VERSION} ]]
                then
                        if [[ "$last_version" > ${diff_version} ]]
                        then
                                diff_version=$last_version
                        fi
                fi
        fi
done < "version.old"
wget -O last.version https://github.com/X-OpenWrt/X-OpenWrt-Dev/releases/download/${diff_version}/make.version
while read -r make_version_line
do
        Check_Version $make_version_line
done < "make.version"
# diff -y last.version ${GITHUB_WORKSPACE}/make.version > ${GITHUB_WORKSPACE}/diff.log
echo "Diff Finish!"