#!/bin/bash
# AutoBuild Module by Xinb/Xinbyte <https://github.com/xopenwrt/X-OpenWrt-New>
# AutoBuild Functions

echo "---------------------------- Soc Info | 🏅AMD Yes ----------------------------"
lscpu | grep "Model name" 
lscpu | grep "CPU(s)" 
echo "--------------------------------- Memory Info --------------------------------"
free -m
echo "---------------------------------- Disk Info ---------------------------------"
lsblk
echo "------------------------------- Disk Usage Info ------------------------------"
df -h
echo "------------------------------- IP Address Info ------------------------------"
IP=`curl ip.115115.xyz -s`
curl -s https://searchplugin.csdn.net/api/v1/ip/get?ip=${IP} | jq -r .data.address
echo $NOW_DATA_VERSION