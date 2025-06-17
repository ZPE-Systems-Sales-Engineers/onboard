#!/bin/bash
# tagged vlans using vlan_interface.json
jsonFile=/home/admin/Automation/jsons/vlan_interface.json
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
jsonPath="/home/dmin/Automation/jsons"
tmpFile="$tmpPath/doCLIcmds.cli"
while IFS= read -r vlan; do
    echo "VLAN ID: $vlan"
    data=$(jq -c ".\"$vlan\"" $jsonFile)
    tmpJson=$tmpPath/$vlan.json
    # The json_data; contains the tagged/untagged interfaces
    json_data=$(jq -n $data)
    for key in $(echo "$json_data" | jq -r 'keys[]'); do
        if [ $key = "tagged" ]; then
            tagged=$(echo "$json_data" | jq -r ".$key")
		elif [ $key = "untagged" ]; then
   			untagged=$(echo "$json_data" | jq -r ".$key")
    	fi
    done
	echo "cd /settings/switch_vlan/" > $tmpFile
    echo "add" >> $tmpFile
    echo "set vlan=$vlan" >> $tmpFile
    echo "set tagged_ports=$tagged" >> $tmpFile
    echo "set untagged_ports=$untagged" >> $tmpFile
    echo "commit" >> $tmpFile
	su - admin -c "cli -f $tmpFile"
done < <(jq -c "keys" $jsonFile | jq -r '.[]')
rm $tmpFile
