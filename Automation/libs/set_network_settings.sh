#!/bin/bash
# This script configure the network::Settings of the NG
jsonFile=/home/admin/Automation/jsons/network_settings.json
tmpFile="/home/admin/doCLIcmds.cli"
echo "cd /settings/network_settings/" > $tmpFile
echo "set hostname=$(jq '.hostname' $jsonFile)" >> $tmpFile
echo "set domain_name=$(jq '.domain_name' $jsonFile)" >> $tmpFile
echo "set enable_ipv4_ip_forward=$(jq '.enable_ipv4_ip_forward' $jsonFile)" >> $tmpFile
echo "set enable_ipv6_ip_forward=$(jq '.enable_ipv6_ip_forward' $jsonFile)" >> $tmpFile
echo "set ipv4_loopback=$(jq '.ipv4_loopback' $jsonFile)" >> $tmpFile
echo "set ipv6_loopback=$(jq '.ipv6_loopback' $jsonFile)" >> $tmpFile
echo "set reverse_path_filtering=$(jq '.reverse_path_filtering' $jsonFile)" >> $tmpFile
echo "commit" >> $tmpFile

su - admin -c "cli -f $tmpFile"
rm $tmpFile
