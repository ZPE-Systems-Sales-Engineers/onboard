#!/bin/bash
# This script creates ip devices in Managed device
# first arg: device type
# second arg: json file created in the tmp
type=$1
jsonFile=/home/admin/Automation/tmp/$2
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
tmpFile="$tmpPath/doCLIcmds.cli"

echo "cd /settings/devices/" > $tmpFile
echo "add" >> $tmpFile
echo "set type=$type" >> $tmpFile

allkeys=$(jq -r 'keys[]' $jsonFile)
# Iterate over keys
for key in ${allkeys[@]}; do
   val=$(jq ".$key" $jsonFile)
   cmd=$(echo "$key" | sed "s/[\"']//g")
   val=$(echo "$val" | sed "s/[\"']//g")
   if [[ $cmd == "read_write_multisession" ]]; then
       cmd="read-write_multisession"
   elif [[ $cmd == "allow_pre_shared_ssh_key" ]]; then
       cmd="allow_pre-shared_ssh_key"
   fi
   echo "set $cmd=$val" >> $tmpFile
done
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
rm $tmpFile
