# ttn-gateway-scripts
Lukas, ASMON, 27.3.2018

## sshRPI.sh 
discovering and ssh-login to rpi without knowing its IP. rpi must be in the same subnet (due to set through DHCP from WIFI) - by its MAC-address
  
## uploadLogsToFTP.sh
uploading logfiles to ftp - ex. using as a cronjob  
  
## README-dd-usage.md
backup and restore SD cards and mount partitions from imagefiles in Linux as well as a known issues
  
## getMyPublicIP.sh
return public ip  

## .bash_aliases
is holding the aliases/shortcuts for simply managing the gateway - which are shown through the motd - message of the day at login

## motd
$ sudo cat motd >> /etc/motd
will attach the file to the actual motd - message of the day - which is shown on login. It is holding every "alias" which is written in .bash_aliases

## installing teamviewer on headless raspberry pi/raspbian/jessie
1. download the package for "Debian, Ubuntu, Raspbian" arm at https://www.teamviewer.com/de/download/linux/
2. sudo dpkg -i <teamviewer_dfjke.deb>
3. sudo apt update
4. sudo apt install -f
5. teamviewer info
6. sudo teamviewer setup
(source: https://www.techrrival.com/install-teamviewer-raspberry-pi/)
