#!/bin/bash
# This script configure ethernet interface passed json file
jsonFile=/home/admin/Automation/tmp/$1.json
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
jsonPath="/home/dmin/Automation/jsons"
tmpFile="$tmpPath/doCLIcmds.cli"
ipv4_mode=$(jq '.ipv4_mode' $jsonFile)
ipv4_mode=$(echo "$ipv4_mode" | sed "s/[\"']//g")
if [ $ipv4_mode = "static" ]; then
    ip=$(jq '.ipv4_ip_address' $jsonFile)
    ip=$(echo "$ip" | sed "s/[\"']//g")
    bitmask=$(jq '.ipv4_bitmask' $jsonFile)
    bitmask=$(echo "$bitmask" | sed "s/[\"']//g")
    gateway=$(jq '.ipv4_gateway' $jsonFile)
    gateway=$(echo "$gateway" | sed "s/[\"']//g")
    dns_server=$(jq '.ipv4_dns_server' $jsonFile)
    dns_server=$(echo "$dns_server" | sed "s/[\"']//g")
fi

ethernet_interface=$(jq '.ethernet_interface' $jsonFile)
ethernet_interface=$(echo "$ethernet_interface" | sed "s/[\"']//g")

set_as_primary_connection=$(jq '.set_as_primary_connection' $jsonFile)
set_as_primary_connection=$(echo "$set_as_primary_connection" | sed "s/[\"']//g")
sim1_apn_configuration=$(jq '.sim1_apn_configuration' $jsonFile)
sim1_apn_configuration=$(echo "$sim1_apn_configuration" | sed "s/[\"']//g")

echo "cd /settings/network_connections/" > $tmpFile
echo "add" >> $tmpFile
echo "set name=$1" >> $tmpFile
echo "set type=mobile_broadband_gsm" >> $tmpFile
echo "set ethernet_interface=$ethernet_interface" >> $tmpFile
if [ $ipv4_mode = "static" ]; then
    echo "set ipv4_mode=static" >> $tmpFile
    echo "set ipv4_address=$ip" >> $tmpFile
    echo "set ipv4_bitmask=$bitmask" >> $tmpFile
    echo "set ipv4_gateway=$gateway" >> $tmpFile
    echo "set ipv4_dns_server=$dns_server" >> $tmpFile
else
    echo "set ipv4_mode=$ipv4_mode" >> $tmpFile
fi
echo "set sim-1_apn_configuration=$sim1_apn_configuration" >> $tmpFile
if [ $sim1_apn_configuration = "manual" ]; then
    sim1_access_point_name=$(jq '.sim1_access_point_name' $jsonFile)
    sim1_access_point_name=$(echo "$sim1_access_point_name" | sed "s/[\"']//g")
    echo "set sim-1_access_point_name=$sim1_access_point_name" >> $tmpFile
fi
echo "set connect_automatically=yes" >> $tmpFile
echo "set set_as_primary_connection=$set_as_primary_connection" >> $tmpFile
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
# rm $tmpFile
