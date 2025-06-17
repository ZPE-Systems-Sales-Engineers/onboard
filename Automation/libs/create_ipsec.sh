#!/bin/bash
# This script configure network ipsec tunnel as client using the network_ipsec.json file
jsonPath=/home/admin/Automation/jsons
tmpPath=/home/admin/Automation/tmp
jsonFile=$jsonPath/network_ipsec.json
tmpFile=$tmpPath/doCLIcmds.cli
name=$(jq -c ".name" $jsonFile)
name=$(echo "$name" | sed "s/[\"']//g")
initiate_tunnel=$(jq '.initiate_tunnel' $jsonFile)
initiate_tunnel=$(echo "$initiate_tunnel" | sed "s/[\"']//g")
ike_profile=$(jq '.ike_profile' $jsonFile)
ike_profile=$(echo "$ike_profile" | sed "s/[\"']//g")
authentication_method=$(jq '.authentication_method' $jsonFile)
authentication_method=$(echo "$authentication_method" | sed "s/[\"']//g")
secret=$(jq '.secret' $jsonFile)
secret=$(echo "$secret" | sed "s/[\"']//g")
left_id=$(jq '.left_id' $jsonFile)
left_id=$(echo "$left_id" | sed "s/[\"']//g")
left_address=$(jq '.left_address' $jsonFile)
left_address=$(echo "$left_address" | sed "s/[\"']//g")
left_ip_address=$(jq '.left_ip_address' $jsonFile)
left_ip_address=$(echo "$left_ip_address" | sed "s/[\"']//g")
left_source_ip_address=$(jq '.left_source_ip_address' $jsonFile)
left_source_ip_address=$(echo "$left_source_ip_address" | sed "s/[\"']//g")
left_subnet=$(jq '.left_subnet' $jsonFile)
left_subnet=$(echo "$left_subnet" | sed "s/[\"']//g")
right_id=$(jq '.right_id' $jsonFile)
right_id=$(echo "$right_id" | sed "s/[\"']//g")
right_address=$(jq '.right_address' $jsonFile)
right_address=$(echo "$right_address" | sed "s/[\"']//g")
right_source_ip_address=$(jq '.right_source_ip_address' $jsonFile)
right_source_ip_address=$(echo "$right_source_ip_address" | sed "s/[\"']//g")
right_subnet=$(jq '.right_subnet' $jsonFile)
right_subnet=$(echo "$right_subnet" | sed "s/[\"']//g")
enable_monitoring=$(jq '.enable_monitoring' $jsonFile)
enable_monitoring=$(echo "$enable_monitoring" | sed "s/[\"']//g")
echo "cd /settings/ipsec/tunnel" > $tmpFile
echo "add" >> $tmpFile
echo "set name=$name" >> $tmpFile
echo "set initiate_tunnel=$initiate_tunnel" >> $tmpFile
echo "set ike_profile=$ike_profile" >> $tmpFile
echo "set authentication_method=$authentication_method" >> $tmpFile
echo "set secret=$secret" >> $tmpFile
echo "set left_id=$left_id" >> $tmpFile
echo "set left_address=$left_address" >> $tmpFile
echo "set left_ip_address=$left_ip_address" >> $tmpFile
echo "set left_source_ip_address=$left_source_ip_address" >> $tmpFile
echo "set left_subnet=$left_subnet" >> $tmpFile
echo "set right_id=$right_id" >> $tmpFile
echo "set right_address=$right_address" >> $tmpFile
echo "set right_source_ip_address=$right_source_ip_address" >> $tmpFile
echo "set right_subnet=$right_subnet" >> $tmpFile
echo "set enable_monitoring=$enable_monitoring" >> $tmpFile
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
rm $tmpFile
