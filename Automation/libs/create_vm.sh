#!/bin/bash
# This script creates VM using the create_vm.json file
jsonPath=/home/admin/Automation/jsons
tmpPath=/home/admin/Automation/tmp
jsonFile=$tmpPath/ATTlte.json
tmpFile=$tmpPath/doCLIcmds.cli

cp -f /run/media/sdb1/SilverPeak/images/ECV-9.2.10.3_95050.qcow2 /run/media/sdb1/SilverPeak/EdgeConnect.qcow2
# Make sure spcustom.iso is at the ~SilverPeak active directory (run/media/sdb1/SilverPeak)
customiso="spcustom.iso"
filename="EdgeConnect.qcow2"
VMNAME='EdgeConnect'
CPUS=2
RAM=6144
FILENAME="EdegeConnect.qcow2"
VMPATH='/run/media/sdb1/SilverPeak'
   virt-install \
   --virt-type kvm \
   --name $VMNAME \
   --ram $RAM --vcpus $CPUS \
   --cpu host-passthrough \
   --osinfo linux --os-variant  linux2020 \
   --network bridge=br0,model=virtio \
   --network bridge=br1,model=virtio \
   --network bridge=br2,model=virtio \
   --network bridge=br3,model=virtio \
   --disk path="$VMPATH"/"$FILENAME" \
   --cdrom "$VMPATH"/"$customiso" \
   --graphics vnc,listen=0.0.0.0 --noautoconsole \
   --import \
   --autostart --check-cpu
#rm $tmpFile
