#!/bin/bash
# This script configure ethernet interface passed json file
jsonFile=/home/admin/Automation/tmp/$1.json
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
jsonPath="/home/dmin/Automation/jsons"
tmpFile="$tmpPath/doCLIcmds.cli"

name=$(jq '.name' $jsonFile)
name=$(echo "$name" | sed "s/[\"']//g")
vlanid=$(jq '.vlanid' $jsonFile)
vlanid=$(echo "$vlanid" | sed "s/[\"']//g")
ipv4_mode=$(jq '.ipv4_mode' $jsonFile)
ipv4_mode=$(echo "$ipv4_mode" | sed "s/[\"']//g")
ip=$(jq '.ipv4_address' $jsonFile)
ip=$(echo "$ip" | sed "s/[\"']//g")
ethernet_interface=$(jq '.interface' $jsonFile)
ethernet_interface=$(echo "$ethernet_interface" | sed "s/[\"']//g")
bitmask=$(jq '.ipv4_bitmask' $jsonFile)
bitmask=$(echo "$bitmask" | sed "s/[\"']//g")
gateway=$(jq '.ipv4_gateway' $jsonFile)
gateway=$(echo "$gateway" | sed "s/[\"']//g")
dns_server=$(jq '.ipv4_dns_server' $jsonFile)
dns_server=$(echo "$dns_server" | sed "s/[\"']//g")
echo "cd /settings/network_connections/" > $tmpFile
echo "add" >> $tmpFile
echo "set name=$name" >> $tmpFile
echo "set type=vlan" >> $tmpFile
echo "set vlan_id=$vlanid" >> $tmpFile
if [ $ipv4_mode = "static" ]; then
    echo "set ipv4_mode=static" >> $tmpFile
    echo "set ipv4_address=$ip" >> $tmpFile
    echo "set ipv4_bitmask=$bitmask" >> $tmpFile
    echo "set ipv4_gateway=$gateway" >> $tmpFile
    echo "set ipv4_dns_server=$dns_server" >> $tmpFile
else
    echo "set ipv4_mode=$ipv4_mode" >> $tmpFile
fi
echo "set ethernet_interface=$ethernet_interface" >> $tmpFile
echo "set connect_automatically=yes" >> $tmpFile
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
# rm $tmpFile
