#!/usr/bin/env bash

set -e

echo "Hi ;3"
echo ""

# Disclaimer
echo "ru: Дисклеймер: я не буду ответственен за ваши окирпиченные устройства, вы запускаете этот скрипт на свой страх и риск"
echo "en: Disclaimer: I will not be responsible for your bricked devices, you run this script at your own risk"
echo "--------------------------------------------------------------------------------------"

# Unlocking bootloader
echo ""
echo "reboot your phone to bootloader if you havent already"
echo ""
fastboot devices 
echo ""

read -rp "smartphone detected? (y/n) " choice
echo ""

case "$choice" in
    *y*|*Y*)
        echo "good"
        ;;
    *)
        echo "bad, reconnect phone or use another cable"
        echo "script stops"
        exit 1
        ;;
esac

read -rp "Are you sure to unlock bootloader on your phone? (y/n) " choice
echo ""

case "$choice" in
    *y*|*Y*)
        echo "use volume buttons to unlock bootloader on pixel (idk how on another phones)"
        fastboot flashing unlock
        ;;
    *)
        echo "If you refused, then there is a reason for it"
        echo "script stops"
        exit 1
        ;;
esac

echo ""
echo ""

# Flashing firmware
echo ""
read -rp "Ready to flash? (before starting, move the script to the firmware files or the firmware files to the script, as you wish)? (y/n) " choice

case "$choice" in
    *y*|*Y*)
        if [ -f "vendor_kernel_boot.img" ]; then
            echo "flashing vendor kernel boot"
            fastboot flash vendor_kernel_boot vendor_kernel_boot.img
        fi

        echo "flashing boot"
        fastboot flash boot boot.img

        echo "flashing dtbo"
        fastboot flash dtbo dtbo.img
        ;;
    *)
        echo "чомска приди"
        exit 0
        ;;
esac

# Flashing vbmeta
read -rp "flash vbmeta with disabling verity/verification (relevant for pixels)? (y/n) " choice

case "$choice" in
    *y*|*Y*)
        fastboot --slot all --verbose --disable-verity --disable-verification flash vbmeta vbmeta.img
        fastboot -w
        ;;
    *)
        echo "ok, I won't flash it"
        ;;
esac

# Flashing vendor_boot
echo "flashing vendor boot"
fastboot flash vendor_boot vendor_boot.img

# Rebooting into recovery & Sideload
echo "rebooting into recovery"
fastboot reboot recovery

echo ""
echo "if your phone rebooted to recovery, using the volume and power buttons go to Factory Reset then Format data / factory reset and continue with the formatting process. This will remove encryption and delete all files stored in the internal storage, as well as format your cache partition (if you have one)."
echo ""

read -rp "if you read write 'y': " choice
case "$choice" in
    *y*|*Y*)
        echo "ok"
        ;;
    *)
        echo "ok"
        ;;
esac

read -rp "Return to the main menu and turn on adb (write 'y' after doing): " choice

case "$choice" in
    *y*|*Y*)
        if [ -f "lineage.zip" ]; then
            echo "starting adb sideload..."
            adb sideload lineage.zip
            echo "all done!"
        else
            echo "lineage.zip not found, run 'adb sideload <filename>.zip' manually"
        fi
        ;;
    *)
        echo "skipping adb sideload"
        ;;
esac
