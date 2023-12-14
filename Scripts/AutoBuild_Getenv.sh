#!/bin/bash
# AutoBuild Module by Xinb/Xinbyte <https://github.com/xopenwrt/X-OpenWrt-New>
# AutoBuild Functions

echo "---------------------------- Soc Info | 🏅AMD Yes ----------------------------"
lscpu | grep "Model name" 
echo "--------------------------------- Memory Info --------------------------------"
free -m
echo "---------------------------------- Disk Info ---------------------------------"
lsblk
echo "------------------------------- Disk Usage Info ------------------------------"
df -h
echo "------------------------------- IP Address Info ------------------------------"
curl ip.115115.xyz