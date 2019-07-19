# README dd
Lukas, ASMON, 15.11.2017

## do it better respect the following
* don't use the SD card reader of the laptop(mostly not connected through a fast interface). Use a usb card reader instead.
* connect the usb card reader directly to the laptop not through an usb-hub
* use the bs= specifier in the output dd -> dd if=imagefile |pv| sudo dd of=/dev/sdx bs=30M conv=sync
## dd and pishrinkb
(Source: https://linuxundich.de/raspberry-pi/pishrink-verkleinert-raspberry-pi-images/)
### Help to call PiShrink:
$ pishrink.sh
Usage: /home/toff/bin/pishrink.sh [-s] imagefile.img [newimagefile.img]
### shrink available RasPi-Image:
$ sudo pishrink.sh raspberry-pi.img
### shrink available image and remain the original:
$ sudo pishrink.sh raspberry-pi.img raspberry-pi_pishrink.img
### deactivate auto-resize of the image:
$ sudo pishrink.sh -s raspberry-pi.img raspberry-pi_klein.img
  
## dd and zipped image
### dd harddisk to zipped image
$ sudo dd if=/dev/sdXY | pv | gzip --best +sdXY.img.gz  
$ sudo dd if=/dev/sdb bs=30MM status=progress conv=sync |pv|gzip --best >loraGW_$(date +%F).gz  



### dd zipped image to harddisk
$ sudo gunzip <sdXY.img.gz | pv | sudo  dd of=/dev/sdb bs=30M   


## mounting harddisk image files 
(https://wiki.archlinux.de/title/Image-Erstellung_mit_dd)  
  
to mount a harddiskimagefile in a Linux system, here one way: image = /path/to/file z.B.: /mnt/server.img  
  
$ kpartx -a -v image  
add map loop0p1 (253:0): 0 433692 linear /dev/loop0 63  
add map loop0p2 (253:1): 0 64260 linear /dev/loop0 433755  
  
$ ls -l /dev/mapper/  
insgesamt 0  
lrwxrwxrwx 1 root root     16  7. Dez 02:18 control -> ../device-mapper  
brw------- 1 root root 253, 0  7. Dez 14:13 loop0p1  
brw------- 1 root root 253, 1  7. Dez 14:13 loop0p2  
  
Now you can mount your partition  
  
$ mount /dev/mapper/loop0p1 /mnt/  
  
## known issues:
if the image, which was taken from a 8GB card was written to a 16GB card -> error output:   
15926820864 bytes (16 GB, 15 GiB) copied, 1596.08 s, 10.0 MB/s2.07GiB 0:26:41 [1.34MiB/s] [   <=>                                            ]  
dd: error writing '/dev/sdb': No space left on device  
11+15183 records in  
15193+0 records out  
15931539456 bytes (16 GB, 15 GiB) copied, 1620.55 s, 9.8 MB/s  
2.07GiB 0:27:05 [ 1.3MiB/s] [ <=>   
