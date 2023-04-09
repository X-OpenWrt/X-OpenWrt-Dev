## **当前与主分支差别**
- AutoBuild Package仓库为当前的Dev
- 内核为Testing版本，即6.1或更新。
- `Z`删除`luci-theme-neobird`、`luci-theme-atmaterial-ColorIcon`、`davfs2`
- 默认IP为`192.168.2.100`
- 添加了两个测试主题，添加了iStore


## **OpenWrt下载说明**
- 可在 [Release](https://github.com/xopenwrt/X-OpenWrt-New/releases/tag/AutoUpdate) 页面下载 `img.gz` 格式的文件
- 可在 [Cloud-Openwrt](https://openwrt.115115.xyz/)下载    `VMDK` 虚拟磁盘文件
- 可直接使用系统内置的更新功能，可任意切换版本

## **发行说明**
1. Github 项目地址：[AutoBuild-Action](https://github.com/xopenwrt/X-OpenWrt-New)
2. 默认IP：`192.168.2.200`，用户名： `root` 密码：`password`, `N1` 盒子为 `10.0.0.1`
3. `X` 版本（大全版）： `Dockerman Smartdns HelloWorld Clash Passwall AdGuardHome` 等以及更多主题
4. `Y` 版本（适中版）： 基础包、常用软件及 `Docker`, 其中 `N1` 盒子版本软件包还在调整中
6. `Z` 版本（极简版) ： 基础包及 `Smartdns Passwall AdGuardHome`
7. 可修复 `Docker` 对 `udp` 的影响
8. `x86` 默认 `rom` 分区大小为 `800M`，`Boot` 分区为`32M`。如果自行对路由器分区后请勿随意不同的发行版本，注意确认 `rom` 分区和 `Boot` 分区一致，否则会导致丢失硬盘其余分区数据。同一发行版本请放心更新、升级
9. 本项目最新版本全部采用 `5.15` 内核，详情参见更新日志
10. 本镜像基于 ：[AutoBuild-Action](https://github.com/Hyy2001X/AutoBuild-Actions) 项目，特别感谢!
11. 代码调试仓库为：[AutoBuild-Action](https://github.com/kokeri/AutoBuild-Actions/)

## **Tips**
由于编译Docker可能导致tproxy透明代理失效，可在` /etc/sysctl.conf `文件中加入 

`net.bridge.bridge-nf-call-ip6tables = 0`

`net.bridge.bridge-nf-call-iptables = 0`

后执行 `sysctl -p` 修复，注意，此步骤会导致 Docker 内部无法正常 DNS 解析，需要手动下发默认 DNS 服务器。

## **更新日志**
- 参见 [更新日志](https://github.com/xopenwrt/X-OpenWrt-New/blob/master/Download.md)

## 使用一键更新固件脚本

   首先需要打开`TTYD 终端`或者使用`SSH`, 按需输入下方指令:

   常规更新固件: `autoupdate`或完整指令`bash /bin/AutoUpdate.sh`

   使用镜像加速更新固件: `autoupdate -P`

   更新固件(不保留配置): `autoupdate -n`
   
   强制刷入固件: `autoupdate -F`
   
   "我不管, 我就是要更新!": `autoupdate -f`

   更新脚本: `autoupdate -x`

   列出相关信息: `autoupdate --list`

   查看所有可用参数: `autoupdate --help`

   **注意: **部分参数可一起使用, 例如 `autoupdate -n -P -F --path /mnt/sda1`

## 使用 tools 固件工具箱

   打开`TTYD 终端`或者使用`SSH`, 执行指令`tools`或`bash /bin/AutoBuild_Tools.sh`即可启动固件工具箱

   当前支持以下功能:

   - USB 扩展内部空间
   - Samba 相关设置
   - 打印端口占用详细列表
   - 打印所有硬盘信息
   - 网络检查 (基础网络 | Google 连接检测)
   - AutoBuild 固件环境修复
   - 系统信息监控
   - 打印在线设备列表

## 鸣谢
   - [AutoBuild-Action](https://github.com/Hyy2001X/AutoBuild-Actions)
   - [Lean's Openwrt Source code](https://github.com/coolsnowwolf/lede)

   - [P3TERX's Blog](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

   - [ImmortalWrt's Source code](https://github.com/immortalwrt)

   - [eSir 's workflow template](https://github.com/esirplayground/AutoBuild-OpenWrt/blob/master/.github/workflows/Build_OP_x86_64.yml)
   
   - [[openwrt-autoupdate](https://github.com/mab-wien/openwrt-autoupdate)] [[Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)]