#!/bin/bash

typeFile=/home/admin/Automation/etc/NgTypes.txt

if grep -q "pdu_apc" $typeFile; then
    echo "String found!"
else
    echo "String not found."
fi

