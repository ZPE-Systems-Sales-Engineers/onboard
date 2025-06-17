#!/bin/bash
# this file reads the address and Coordinates from the public IP of the unit
# stores the address and coordinates in the json file and set the info in the NG
myLocData=$(curl http://ip-api.com/json?fields=lat,lon)

longitude=$(echo "$myLocData" | jq -r .lon)
latitude=$(echo "$myLocData" | jq -r .lat)
coord="$latitude,$longitude"

# Fetch geolocation data using ipinfo.io
location_data=$(curl -s ipinfo.io)

# Extract city and region (state) from the JSON response
city=$(echo $location_data | jq -r '.city')
state=$(echo $location_data | jq -r '.region')

address="$city,$state"
if [ "$#" -eq 1 ]; then
    argu=$1
    if [ ${argu^^} = "YES" ]; then
        # setting system Preference parameters
        tmpFile="/home/admin/doCLIcmds.cli"
        echo "cd /settings/system_preferences/" > $tmpFile
        echo "set address_location=$address" >> $tmpFile
        echo "set coordinates=$coord" >> $tmpFile
        echo "set idle_timeout=3600" >> $tmpFile
        echo "set show_hostname_on_webui_header=yes" >> $tmpFile
        echo "commit" >> $tmpFile

        su - admin -c "cli -f $tmpFile"
        rm $tmpFile
    fi
fi

# writes the information in the json file
jsonFile=/home/admin/Automation/jsons/addr_coord.json
echo "{" > $jsonFile
echo -e "\t\"Address\": \"$address\"," >> $jsonFile
echo -e "\t\"Coordinates\": \"$coord\"" >> $jsonFile
echo "}" >> $jsonFile
