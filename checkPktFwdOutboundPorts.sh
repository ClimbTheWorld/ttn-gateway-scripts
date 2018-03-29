#!/bin/bash
# check if the needed ports for the packet_forwarder are open in the outbound direction
#!/bin/bash
ret=0
curl_output=$(curl -s portquiz.net:123 --max-time 3 >NUL)
if [ $? -ne 0 ]; then
  echo "port :123 is not open in the outbound direction"
  ret=1
else
  echo "port :123 is open in the outbound direction"
fi
  
curl_output=$(curl -s portquiz.net:443 --max-time 3)
if [ $? -ne 0 ]; then
  echo "port 443 is not open in the outbound direction"
  ret=1
else
  echo "port :443 is open in the outbound direction"
fi

curl_output=$(curl -s portquiz.net:1680 --max-time 3)
if [ $? -ne 0 ]; then
  echo "port :1680 is not open in the outbound direction"
  ret=1
else
  echo "port :1680 is open in the outbound direction"
fi

curl_output=$(curl -s portquiz.net:1780 --max-time 3)
if [ $? -ne 0 ]; then
  echo "port :1780 is not open in the outbound direction"
  ret=1
else
  echo "port :1780 is open in the outbound direction"
fi

if [ $ret -eq 0 ]; then 
  echo "needed ports are open. go ahead"
  exit 0
else 
  echo "speak to your sysadmin"
  exit 1
fi
