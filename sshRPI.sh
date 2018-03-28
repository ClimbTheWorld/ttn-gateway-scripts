#!/bin/bash
#
# ssh into RPi without its IP in the same subnet (due to set through DHCP from WIFI) - by its Mac
#
# Lukas, ASMON, 9.3.2017
#
#user on Gateway
USER="<user>"
#mac-address: "b8:27:e1:71:91:08"
MAC="<mac-address>"

function USAGE {
    echo *** ssh into RPi without its IP in the same subnet (due to set through DHCP from WIFI) - by its Mac
    echo "Option \"help\""
    echo "usage: $ $0 -fh"
    echo "-f: force - needs 'sudo'"
    echo "-h: help"
}


cidr2mask() {
    # Number of args to shift, 255..255, first non-255 byte, zeroes
    set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
    [ $1 -gt 1 ] && shift $1 || shift
    echo ${1-0}.${2-0}.${3-0}.${4-0}
}

# Function calculates CIDR - number of bit in a netmask
# EX.
# MASK=255.255.254.0
# numbits=$(mask2cidr $MASK)
#
mask2cidr() {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}

# Function counts ones in netmask from netmask's-hex-form 
# MASK=0xffffff00
# numbits=$(mask2cidr $MASK)
#
countBitsOfMask() {
    for var in "$1"
    do
        var=`echo $var | cut -d "x" -f 2`
        code=`echo $var | tr 'a-z' 'A-Z'`
        converted=`echo "ibase=16; obase=2; $code" | bc`
        ones=`echo $converted | grep -o "1" | wc -l`
    done
    echo $ones
}

# Function deletes arp table and rebuilds it
function REBUILDARP {
    if [ $EUID -ne 0 ]
    then
        echo "ERROR! -f needs sudo"
        exit 1
    fi

    arp -a -d;
    
    # get ip of GW
    GWIP=`netstat -nr | grep '^default' | sed -E "s/[[:space:]]+/ /g" | cut -d " " -f 2`    # 172.20.10.1
    echo GWIP $GWIP
    
    # get default interface
    IF=`netstat -nr | grep '^default' | sed -E "s/[[:space:]]+/ /g" | cut -d " " -f 6`      # en0
    echo IF $IF
    
    # get default broadcast address - ex. 172.20.10.15
    BROADCAST=`ifconfig $IF | grep "inet " | cut -d " " -f 6`
    echo BROADCAST $BROADCAST
    
    # get default subnetmask in hex - ex. 0xfffffff0
    SUBNETMASKHEX=`ifconfig en0 | grep "inet "  | cut -d " " -f 4`
    echo SUBNETMASKHEX $SUBNETMASKHEX
    
    SUBNETMASKHEXSHORT=`echo $SUBNETMASKHEX | cut -d "x" -f 2`
    echo SUBNETMASKHEXSHORT $SUBNETMASKHEXSHORT
    
    # count set bits in subnetmask - ex. 0xffffff00 -> 24
    NBITS=$(countBitsOfMask $SUBNETMASKHEX)
    echo BITS $NBITS
    
    # get hostmask - ex. 255
    CIDR=$((0xffffffff - $SUBNETMASKHEX))
    echo CIDR $CIDR
    test=$(mask2cidr $SUBNETMASKHEXSHORT)
    echo MASK2CIDR $test
    
    # get active subnet - as long as it starts with zero
    SUBNET=`ifconfig en0 | grep "inet " | cut -d " " -f 2 | cut -d "." -f 1 -f 2 -f 3`      # 172.20.10  
    SUBNET=$SUBNET.0
    echo SUBNET $SUBNET
    
    # rebuild arp table with nmap
    NMAPCMD=`nmap $SUBNET/$NBITS -n -sP | grep report | awk '{print $5}'`                                      
    echo NMAPCMD $NMAPCMD
}

### Example
# The option string f:gh::i: means that the are four options. 
# *  f has a required argument
# *  g has no argument
# *  h has an optional argument
# *  i has a required argument
#
# Rules:
#   1. Each single character stands for an option.
#   2. A : (colon character) tells that the option has a required argument.
#   3. A :: (two consequent colon character) tells that the option has an optional argument.
#
# Sets positional parameters to command-line arguments.
# What happens if you use "$*" instead of "$@"?
# getopt vs getopts: http://abhipandey.com/2016/03/getopt-vs-getopts/
### end Example

while getopts ":fh" FLAG; do
    case ${FLAG} in
        f ) 
            #echo "Option \"force\""
            REBUILDARP
            ;;
        h ) 
            #echo "Option \"help\""
            USAGE
            ;;
        \? ) #unrecognized option - show help
            echo -e \\n"Option -${BOLD}$OPTARG${OFF} not allowed."
            USAGE
            ;;
    esac
  shift 
done

IP=`arp -an | grep $MAC | awk '{print $2}'| tr -d '()'`
if [ -ez $IP ]
then 
    echo RPi probably not in the network!
    exit 1
fi
    
echo IP=$IP
ssh $USER@$IP   

exit 0
