#!/bin/bash
# This script configure the serial ports using the  serial_ports.json file
jsonFile=/home/admin/Automation/jsons/serial_ports.json

tmpFile="/home/admin/doCLIcmds.cli"
while IFS= read -r serial_port; do
    echo "Configuring: $serial_port"
    name=$(jq -r ".\"$serial_port\".\"name\"" $jsonFile)
    name=$(echo "$name" | sed "s/[\"']//g")
    web_url=$(jq -r ".\"$serial_port\".\"web_url\"" $jsonFile)
    web_url=$(echo "$web_url" | sed "s/[\"']//g")
    launch_url_via_html5=$(jq -r ".\"$serial_port\".\"launch_url_via_html5\"" $jsonFile)
    launch_url_via_html5=$(echo "$launch_url_via_html5" | sed "s/[\"']//g")
    baud_rate=$(jq -r ".\"$serial_port\".\"baud_rate\"" $jsonFile)
    baud_rate=$(echo "$baud_rate" | sed "s/[\"']//g")
    flow_control=$(jq -r ".\"$serial_port\".\"flow_control\"" $jsonFile)
    flow_control=$(echo "$flow_control" | sed "s/[\"']//g")
    parity=$(jq -r ".\"$serial_port\".\"parity\"" $jsonFile)
    parity=$(echo "$parity" | sed "s/[\"']//g")
    data_bits=$(jq -r ".\"$serial_port\".\"data_bits\"" $jsonFile)
    data_bits=$(echo "$data_bits" | sed "s/[\"']//g")
    stop_bits=$(jq -r ".\"$serial_port\".\"stop_bits\"" $jsonFile)
    stop_bits=$(echo "$stop_bits" | sed "s/[\"']//g")
    mode=$(jq -r ".\"$serial_port\".\"mode\"" $jsonFile)
    mode=$(echo "$mode" | sed "s/[\"']//g")
    enable_device_state_detection_based_in_data_flow=$(jq -r ".\"$serial_port\".\"enable_device_state_detection_based_in_data_flow\"" $jsonFile)
    enable_device_state_detection_based_in_data_flow=$(echo "$enable_device_state_detection_based_in_data_flow" | sed "s/[\"']//g")
    echo "cd /settings/devices/$serial_port/access/" > $tmpFile
    if [ -n $web_url ]; then
        echo "set web_url=$web_url" >> $tmpFile
    fi
    if [ -n $launch_url_via_html5 ]; then
        echo "set launch_url_via_html5=$launch_url_via_html5" >> $tmpFile
    fi
    echo "set baud_rate=$baud_rate" >> $tmpFile
    echo "set parity=$parity" >> $tmpFile
    echo "set data_bits=$data_bits" >> $tmpFile
    echo "set stop_bits=$stop_bits" >> $tmpFile
    echo "set enable_device_state_detection_based_in_data_flow=$enable_device_state_detection_based_in_data_flow" >> $tmpFile
    echo "set mode=$mode" >> $tmpFile
    echo "commit" >> $tmpFile
    if grep -q "detect" <<< "$name"
    then
	    echo "set enable_hostname_detection=yes" >> $tmpFile
	    echo "commit" >> $tmpFile
    else
	    echo "cd /settings/devices/" >> $tmpFile
	    echo "rename $serial_port" >> $tmpFile
	    echo "set new_name=$name" >> $tmpFile
	    echo "commit" >> $tmpFile
    fi
    su - admin -c "cli -f $tmpFile"

done < <(jq -c "keys" $jsonFile | jq -r '.[]')

rm $tmpFile
