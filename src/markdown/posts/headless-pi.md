% Headless Pi
% Freddie Sanchez
% 2017-Feb-09

#sh #pi

Grab the latest raspbian 
https://downloads.raspberrypi.org/raspbian_latest.torrent


## Flashing the image

First find the 
```bash
$ sudo fdisk -l
```
note this is the device, not the partition
```bash
sudo dd bs=4M if=2017-01-11-raspbian-jessie.img of=/dev/mmcblk0
```

mount the second partition, edit it with your wireless config
https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md

```bash
$ sudo vim etc/wpa_supplicant/wpa_supplicant.conf

network={
        ssid="MyWiFiName"
        psk="MyWiFiPassword"
        proto=RSN
        key_mgmt=WPA-PSK
        pairwise=CCMP
        auth_alg=OPEN
}
```

Touch ssh on the boot (first) partition (not /boot) to enable SSH for a headless setup.

The default password is ```raspberry```
https://www.raspberrypi.org/documentation/remote-access/ssh/

Setup the rasp-config

* Turn off GUI
* expand the main partition.
* reboot
* edit timezone info

_2017-Feb-09_
