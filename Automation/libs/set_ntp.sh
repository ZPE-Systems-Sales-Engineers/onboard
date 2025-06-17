#!/bin/bash
# This script configure NTP info from the ntp_config.json file
jsonFile=/home/admin/Automation/jsons/ntp_config.json

#"Server": "pool.ntp.org",
#"Zone": "utc",
#"enable_date_and_time_synchronization": "no"
server=$(jq '.Server' $jsonFile)
zone=$(jq '.Zone' $jsonFile)
synch=$(jq '.enable_date_and_time_synchronization' $jsonFile)
tmpFile="/home/admin/doCLIcmds.cli"
echo "cd /settings/date_and_time/" > $tmpFile
echo "set server=$server" >> $tmpFile
echo "set zone=$zone" >> $tmpFile
echo "set enable_date_and_time_synchronization=$synch" >> $tmpFile
echo "commit" >> $tmpFile
su - admin -c "cli -f $tmpFile"
rm $tmpFile
