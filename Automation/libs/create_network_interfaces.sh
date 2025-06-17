#!/bin/bash
# This script configure network interfaces using the newtork_interfaces.json file
jsonFile=/home/admin/Automation/jsons/network_interfaces.json
tmpPath="/home/admin/Automation/tmp"
etcPath="/home/admin/Automation/etc"
jsonPath="/home/dmin/Automation/jsons"
tmpFile="$tmpPath/doCLIcmds.cli"
while IFS= read -r interface; do
    echo "Interface: $interface"
    data=$(jq -c ".\"$interface\"" $jsonFile)
    tmpJson=$tmpPath/$interface.json
    # The json_data; contains all the interface arguments in json format
    json_data=$(jq -n $data)
    echo $json_data > "$tmpJson"
    for key in $(echo "$json_data" | jq -r 'keys[]'); do
        # bridge, ethernet, mobile_broadband_gsm
        if [ $key = "type" ]; then
            value=$(echo "$json_data" | jq -r ".$key")
	    case "$value" in
                "ethernet")
                    $etcPath/create_ethernet.sh $interface
                ;;
                "bridge")
	            $etcPath/create_bridge.sh $interface
                ;;
                "mobile_broadband_gsm")
	            $etcPath/create_lte.sh $interface
                ;;
                "vlan")
	            $etcPath/create_vlan.sh $interface
                ;;
            esac
	fi
    done

done < <(jq -c "keys" $jsonFile | jq -r '.[]')
rm $tmpFile
