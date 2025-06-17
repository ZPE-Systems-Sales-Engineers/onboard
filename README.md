Introduction:
	The purpose of the project is to allows customer to onboard the NG SR products for remote location with minimal
 works needed to get the unit up and running as soon as possible.

Usage: 
The configuration is defined in the json files in jsons folder.
Uncomment the lines in the script onboarding.sh under Automation folder to run the wanted configuration 

Folder Structures
Automation (contain main executable script onboarding.sh)
	|- libs (contains all the executable scripts)
	|- etc (helpful scripts that is used by libs scripts)
	|- jsons (These are file contains the configuration information)
	|- objs (contains VMs iso/qcow2 files)
	|- tmp (temporary files creates and deleted by the scripts)

Example create interfaces in the GSR
The Automation folder must be in /home/admin of Nodegrid
Open the Automation/jsons/ network_interfaces.json
Modify or add defines information to create the interfaces
<important> the “type” field must be set correctly.  It is used in the script to create the interfaces
The key options are the same as what is used in the CLI commands.  Must match exactly
Uncomment the line “libs/create_network_interfaces.sh in the onboarding.sh
Executes the ./onboarding.sh of the Automation folder

Available scripts on the initial commit
# get_system_info - creates the jsons/system_about.json file with the System::About information
#libs/get_system_info.sh
# set the address and coordinates of the NG system::preference, address_coord.json file
# argument yes - to updates the info in the NG
# no argument means to only update the json file
#libs/set_address_coord.sh yes
# using the ntp_config.json file and configure the ntp information into the NG
#libs/set_ntp.sh
# create network interfaces using the *** newtork_interfaces.json
#libs/create_network_interfaces.sh
# set the serial devices ttyS ports using the *** serial_ports.json
#libs/configure_serial.sh
# add IP managed devices using the *** ip_managed_devices.json
#libs/add_ip_managed.sh
# create vlan tagged/untagged interfaces *** vlan_interface.json
#libs/create_vlan.sh
# create ipsec tunnel client using the *** network_ipsec.json
#libs/create_ipsec.sh

