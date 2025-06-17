#!/bin/bash
# This script creates ip devices using the ip_managed_devices.json file
jsonPath=/home/admin/Automation/jsons
tmpPath=/home/admin/Automation/tmp
mjsonFile=$jsonPath/ip_managed_devices.json
tmpFile=$tmpPath/doCLIcmds.cli
etcPath=/home/admin/Automation/etc
typeFile=/home/admin/Automation/etc/NgTypes.txt

# loop through all target devices
while IFS= read -r type; do
	if grep -q  $type $typeFile; then
    	echo "adding type: $type"
	else
    	echo "Error $type is not valid!"
		exit 0
	fi
    data=$(jq -c ".\"$type\"" $mjsonFile)
    # Check if this is an array of data
    if [[ $data == *"["* ]]; then
        # puts data into json array
        objects=$(echo "$data" | jq -c '.[]')
        # Iterate over each object
        for obj in $objects; do
            name=$(echo "$obj" | jq -r '.name')
            echo $(jq -n $obj) > $tmpPath/$name.json
            source $etcPath/create_ip_managed.sh $type $name.json
        done
    else
        data=$(jq -c ".\"$type\"" $mjsonFile)
        json_data=$(jq -n $data)
        name=$(echo $json_data | jq -r ".name")
        echo $(jq -n $data) > $tmpPath/$name.json
        source $etcPath/create_ip_managed.sh $type $name.json
    fi
done < <(jq -c "keys" $mjsonFile | jq -r '.[]')
