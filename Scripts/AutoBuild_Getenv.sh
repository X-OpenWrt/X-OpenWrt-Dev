#!/bin/bash
# AutoBuild Module by Xinb/Xinbyte <https://github.com/xopenwrt/X-OpenWrt-New>
# AutoBuild Functions
Get_Action_Info() {
echo "---------------------------- Soc Info | 🏅AMD Yes ----------------------------"
lscpu | grep "Model name" 
lscpu | grep "CPU(s)" 
echo "--------------------------------- Memory Info --------------------------------"
free -m
echo "---------------------------------- Disk Info ---------------------------------"
lsblk
echo "------------------------------- Disk Usage Info ------------------------------"
df -h


# Get IP Info
echo "------------------------------- IP Address Info ------------------------------"
IP=`curl ip.115115.xyz -s`
curl ip.115115.xyz -s
curl -s https://searchplugin.csdn.net/api/v1/ip/get?ip=${IP} | jq -r .data.address
}

Get_Release_Info() {
echo "------------------------------- Build Version Data ----------------------------"
echo ${NOW_DATA_VERSION}
echo "------------------------------ Build Kernel Version ---------------------------"
`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_PATCHVER:=`

}