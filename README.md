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

## checkPktFwdOutboundPorts.sh
check if the required outbound ports are open  
  
## .bash_aliases
is holding the aliases/shortcuts for simply managing the gateway - which are shown through the motd - message of the day at login

## motd
$ sudo cat motd >> /etc/motd
will attach the file to the actual motd - message of the day - which is shown on login. It is holding every "alias" which is written in .bash_aliases

## installing teamviewer on headless raspberry pi/raspbian/jessie 
raspberry pi >=v2 armv7 needed - v1/imst's lora lite gw not possible
1. download the package for "Debian, Ubuntu, Raspbian" arm at https://www.teamviewer.com/de/download/linux/
2. sudo dpkg -i <teamviewer_dfjke.deb>
3. sudo apt update
4. sudo apt install -f
5. teamviewer info
6. sudo teamviewer setup
(source: https://www.techrrival.com/install-teamviewer-raspberry-pi/)

### enlarge remote screen size
$ vim /boot/config.txt
remove '#' before:
---- disable_overscan
---- framebuffer_width
---- framebuffer_height

## /etc/wpa_supplicant/wpa_supplicant.conf
to automatically connect to a mobile phone hotspot as soon as available

## get gw status
get a gateway status in json format
curl http://noc.thethingsnetwork.org:8085/api/v2/gateways/piznairuno

### script
gwid=$(curl http://noc.thethingsnetwork.org:8085/api/v2/gateways/gwid | jq -r '.timestamp')  
if [ "null" -eq "$gwid" ]; then   
    echo "not online"  
else  
    echo "is online"  
fi  
### online status
{"timestamp":"2018-11-21T22:18:08.043272260Z","uplink":"3840528","downlink":"841564","location":{"latitude":47.03804,"longitude":8.29894,"altitude":455},"frequency_plan":"EU_863_870","platform":"IMST + Rpi","gps":{"latitude":47.03804,"longitude":8.29894,"altitude":455},"time":"1542838688043272260","rx_ok":3840528,"tx_in":841564}
### offline status
{"error":"status not found","code":5}
