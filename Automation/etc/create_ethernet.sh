#!/bin/bash
# This script configure ethernet interface passed json file
jsonFile=/home/admin/Automation/tmp/$1.json
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
jsonPath="/home/dmin/Automation/jsons"
tmpFile="$tmpPath/doCLIcmds.cli"
ip=$(jq '.ipv4_ip_address' $jsonFile)
ip=$(echo "$ip" | sed "s/[\"']//g")
bitmask=$(jq '.ipv4_bitmask' $jsonFile)
bitmask=$(echo "$bitmask" | sed "s/[\"']//g")
gateway=$(jq '.ipv4_gateway' $jsonFile)
gateway=$(echo "$gateway" | sed "s/[\"']//g")
dns_server=$(jq '.ipv4_dns_server' $jsonFile)
dns_server=$(echo "$dns_server" | sed "s/[\"']//g")
echo "cd /settings/network_connections/$1/" > $tmpFile
echo "set ipv4_mode=static" >> $tmpFile
echo "set ipv4_address=$ip" >> $tmpFile
echo "set ipv4_bitmask=$bitmask" >> $tmpFile
echo "set ipv4_gateway=$gateway" >> $tmpFile
echo "set ipv4_dns_server=$dns_server" >> $tmpFile
echo "set connect_automatically=yes" >> $tmpFile
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
rm $tmpFile
