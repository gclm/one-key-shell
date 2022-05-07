#!/bin/bash

echo "Clover.prefPane"
sudo rm -rf /Library/PreferencePanes/Clover.prefPane

# 删除 ESP 分区下的 nvram.plist
echo "删除 ESP 分区下的 nvram.plist"
rm -rf /Volumes/EFI/nvram.plist

# 删除 RC 脚本
echo "删除 RC 脚本"
rm -rf "/etc/rc.clover.lib"
rm -rf "/etc/rc.boot.d/10.save_and_rotate_boot_log.local"
rm -rf "/etc/rc.boot.d/20.mount_ESP.local"
rm -rf "/etc/rc.boot.d/70.disable_sleep_proxy_client.local.disabled"
rm -rf "/etc/rc.boot.d/80.save_nvram_plist.local"
rm -rf "/etc/rc.shutdown.local"
rm -rf "/etc/rc.boot.d"
rm -rf "/etc/rc.shutdown.d"

# 删除 Clover 新开发的 NVRAM 守护程序 `CloverDaemonNew`
echo " 删除 Clover 新开发的 NVRAM 守护程序 CloverDaemonNew"
#launchctl unload '/Library/LaunchDaemons/com.slice.CloverDaemonNew.plist'
rm -rf '/Library/LaunchDaemons/com.slice.CloverDaemonNew.plist'
rm -rf '/Library/Application Support/Clover/CloverDaemonNew'
rm -rf '/Library/Application Support/Clover/CloverLogOut'
rm -rf '/Library/Application Support/Clover/CloverWrapper.sh'