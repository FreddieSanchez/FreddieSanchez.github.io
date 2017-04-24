%Headless Pi

Grab the latest raspbian 
https://downloads.raspberrypi.org/raspbian_latest.torrent

note this is the device, not the partition
```sudo dd bs=4M if=2017-01-11-raspbian-jessie.img of=/dev/mmcblk0```

mount the second partition, edit it with your wireless config
https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md

Touch /boot/ssh to enable SSH for a headless setup.
The default password is ```raspberry```
https://www.raspberrypi.org/documentation/remote-access/ssh/

Setup the rasp-config

* Turn off GUI
* expand the main partition.
* reboot

Edit the date
```date --set="20091015 04:30"```