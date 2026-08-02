#!/bin/sh
echo "Hi ;3"
echo ""

#Disclaimer
echo "ru: Дисклеймер: я не буду ответствинен за ваши окирпиченые устройства, вы запускаете этот скрипт на свой страх и риск"
echo ""
echo "Disclaimer: I will not be responsible for your bricked devices, you run this script at your own risk"


#--------------------------------------------------------------------------------------

#Unlocking bootloader
echo ""
echo "I hope you rebooted your phone to bootloader if not reboot and start over"
echo ""
fastboot devices 
echo ""
read -p "smartphone detected? (y/n) " choice
echo ""
if [ "$choice" == "y" ]; then
	echo ""
	echo "good"
else
	echo "bad, reconnect phone or use another cable"
	echo "script stops"
	exit
fi

read -p "Are you sure to unlock bootloader on your phone? (y/n)" choice
echo ""
if [ "$choice" == "y" ]; then
	echo ""
	echo "use volume buttons to unlock bootloader on pixel (idk how on another phones)"
fastboot flashing unlock
else
	echo "If you refused, then there is a reason for it"
	echo "script stops"
	exit
fi
 echo ""
 echo ""


 #------------------------------------------------------------------------------------------


#--------------------------------------------------

#flashing firmware


echo ""
read -p "Ready to flash? (before starting, move the script to the firmware files or the firmware files to the script, as you wish)? (y/n) " choice
if [ "$choice" == "y" ]; then
echo "flashing vendor kernel boot"
fastboot flash vendor_kernel_boot
echo "flasing boot"
fastboot flash boot boot.img
echo "flashing dtbo"
fastboot flash dtbo dtbo.img
echo "rebooting to bootloader, again"
else
echo "чомска приди"
fi

#-----------------------------------------------------

#flasing vbmeta

read -p "flash vbmeta with disabling verity/verification (relevant for pixel's)? (y/n)" choice
if [ "$choice" == "y" ]; then

fastboot --slot all --verbose --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot -w

else
	echo "ok, I won't flash it"
fi

#---------------------

#flashing vendor_boot

echo "flashing vendor boot"
fastboot flash vendor_boot vendor_boot.img

#---------------------

#rebooting into recovery
 echo "rebooting into recovery"
 fastboot reboot recovery

 echo "if your phone rebooted to recovery, Using the volume and power buttons go to Factory Reset then Format data / factory reset and continue with the formatting process. This will remove encryption and delete all files stored in the internal storage, as well as format your cache partition (if you have one). "

read -p "if you read write 'y'" choice
if [ "$choice" == "y" ]; then
 echo "ok"
 else
 echo "ok"
fi

read -p "Return to the main menu and turn on adb  (write 'y' after doing)" choise
if [ "$choice" == "y" ]; then
