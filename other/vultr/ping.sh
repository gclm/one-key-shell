#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#fonts color
Red="\033[31m" 
Font="\033[0m"
Blue="\033[36m"

echo "========================================="
echo "From Local to Vultr 15 DCs Ping Test "
echo "========================================="

echo -e "${Blue}01 Tokyo${Font}"
ping -c 10 hnd-jp-ping.vultr.com 
echo "============================="
echo -e "${Blue}02 Singapore${Font}"
ping -c 10 sgp-ping.vultr.com 

echo "============================="
echo -e "${Blue}03 Amsterdam${Font}"
ping -c 10 ams-nl-ping.vultr.com 

echo "============================="
echo -e "${Blue}04 Paris${Font}"
ping -c 10 par-fr-ping.vultr.com 

echo "============================="
echo -e "${Blue}05 Frankfurt${Font}"
ping -c 10 fra-de-ping.vultr.com 

echo "============================="
echo -e "${Blue}06 London${Font}"
ping -c 10 lon-gb-ping.vultr.com 

echo "============================="
echo -e "${Blue}07 New York${Font}"
ping -c 10 nj-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}08 Chicago${Font}"
ping -c 10 il-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}09 Dallas${Font}"
ping -c 10 tx-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}10 Atlanta${Font}"
ping -c 10 ga-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}11 Los Angeles${Font}"
ping -c 10 lax-ca-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}12 Miami${Font}"
ping -c 10 fl-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}13 Seattle${Font}"
ping -c 10 wa-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}14 Silicon Valley${Font}"
ping -c 10 sjo-ca-us-ping.vultr.com 

echo "============================="
echo -e "${Blue}15 Sydney${Font}"
ping -c 10 syd-au-ping.vultr.com 
