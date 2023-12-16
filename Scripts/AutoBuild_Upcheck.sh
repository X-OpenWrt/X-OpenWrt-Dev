#!/bin/bash

Check_build_Version(){
        pkg_line=$1
        X_BUILD_TAG=$2
        pkg_name=${pkg_line%=*}
        pkg_new_version=${pkg_line#*=}
        pkg_info=`cat ${X_BUILD_TAG}_build_pkg_ver_old.log | grep "^$pkg_name=" -m 1 `
        pkg_old_version=${pkg_info#*=}
        if [ "$pkg_old_version" != "$pkg_new_version" ]
        then
                if [ "$pkg_old_version" != "" ]
                then
                        echo ${pkg_name}:"$pkg_old_version>>$pkg_new_version" >>diff.log
                        echo ${pkg_name}:"$pkg_old_version>>$pkg_new_version"
                else
                        echo "Add ${pkg_name}:${pkg_new_version}" >> ${X_BUILD_TAG}_build_pkg_up.log 
                fi
        fi

}

cat openwrt/build_log.log  | grep "make\[3\]" | grep -E "package/|feeds/" > build_cmd.log
cat build_cmd.log | awk '{print substr($3,1)}' > build_package.log

X_LINUX_VERSION=`cat openwrt/target/linux/x86/Makefile | grep KERNEL_PATCHVER:=`
X_LINUX_VERSION_TESTING=`cat openwrt/target/linux/x86/Makefile | grep KERNEL_TESTING_PATCHVER:=`
X_LINUX_VERSION=${X_LINUX_VERSION#*=}
X_LINUX_VERSION_TESTING=${X_LINUX_VERSION_TESTING#*=}
echo LINUX_VERSION=${X_LINUX_VERSION} > ${1}_build_pkg_ver.log
echo LINUX_VERSION_TESTING=${X_LINUX_VERSION_TESTING} >> ${1}_build_pkg_ver.log

while read -r build_pkg_dir
do
    build_pkg_ver=`cat openwrt/${build_pkg_dir}/Makefile |  grep "\bPKG_VERSION:=" -m 1`

	if [ "${build_pkg_dir##*/}" = "dnsmasq" ]
	then
        build_pkg_ver=`cat openwrt/${build_pkg_dir}/Makefile | grep PKG_UPSTREAM_VERSION:=`
	fi

	if [ "${build_pkg_dir##*/}" = "ppp" ]
	then
        build_pkg_ver=`cat openwrt/${build_pkg_dir}/Makefile | grep PKG_RELEASE_VERSION:=`
	fi

	if [ "${build_pkg_dir##*/}" = "bpf-headers" ]
	then
        build_pkg_ver=`cat openwrt/${build_pkg_dir}/Makefile | grep PKG_PATCHVER:=`
	fi

    if [ "${build_pkg_dir##*/}" = "dsl-vrx200-firmware-xdsl" ]
    then
        build_pkg_ver=""
    fi
    if [ "${build_pkg_dir##*/}" = "UnblockNeteaseMusic" ]
    then
        build_pkg_ver=""
    fi
    if [ "${build_pkg_dir##*/}" = "perf" ]
    then
        build_pkg_ver=${X_LINUX_VERSION}
    fi

    if  [ "$build_pkg_ver" = "" ]
    then
        build_pkg_ver=`cat openwrt/${build_pkg_dir}/Makefile | grep "\bPKG_VERSION=" -m 1`
    fi
    echo ${build_pkg_dir##*/}=$build_pkg_ver >> ${1}_build_pkg_ver.log
done < "build_package.log"

        # export NOW_DATA_VERSION=${{env.NOW_DATA_VERSION}}
        # export GITHUB_WORKSPACE=$GITHUB_WORKSPACE
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
wget -O ${1}_build_pkg_ver_old.log https://github.com/X-OpenWrt/X-OpenWrt-Dev/releases/download/${diff_version}/${1}_build_pkg_ver.log

# Check_build_Version "LINUX_VERSION=${X_LINUX_VERSION}" ${1}
while read -r make_version_line
do
        Check_build_Version $make_version_line ${1}
done < "${1}_build_pkg_ver.log"
