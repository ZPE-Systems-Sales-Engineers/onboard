#!/bin/bash
# This script get the Nodegrid system informaition and fill out the information on the system_about.json
tmpFile=/home/admin/temp.cli
jsonFile=jsons/system_about.json
su - admin -c "cli \"show /system/about\"" > $tmpFile
echo "{" > $jsonFile
while read -r line; do
       IFS=":" read -r first last <<< "$line"
       first="${first//$'\n'/}"
       first=$(echo "$first" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
       last="${last//$'\n'/}"
       last=$(echo "$last" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
       first="\"$first\""
       last="\"$last\""
       # echo $first 
       # echo $last
       echo -e "\t$first: $last," >> $jsonFile 
done < $tmpFile
echo -e "\t$first: $last" >> $jsonFile 
echo "}" >> $jsonFile
rm $tmpFile
model=`cat $jsonFile | jq '.model'`
echo $model
