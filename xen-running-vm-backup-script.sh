#!/bin/bash

# List of all RUNNING VM
echo "Get List of all Running VM's"
xe vm-list is-control-domain=false is-a-snapshot=false power-state=running

# Take NAME of VM
echo "Enter Name of a VM"
read NAME
# Take UUID of VM
echo "Enter UUID of a VM"
read UUID

# Get New Snapshot ID
NEW_UUID=$(xe vm-snapshot uuid=$UUID new-name-label=$NAME)

# Convert Snapshot to VM
xe template-param-set is-a-template=false ha-always-run=false uuid=$NEW_UUID

# Select EXPORT format
echo "Select format for export --> xva ovf ova"
read FORMAT

# Export accordinf to format
if [ "$FORMAT" == "xva" ]; then
   xe vm-export vm=$NEW_UUID filename=$NAME-$(date +"%Y-%m-%d-%H-%M").xva
elif [ "$FORMAT" == "ovf" ]; then
   xe vm-export vm=$NEW_UUID filename=$NAME-$(date +"%Y-%m-%d-%H-%M").ovf
else
   xe vm-export vm=$NEW_UUID filename=$NAME-$(date +"%Y-%m-%d-%H-%M").ova
fi

# Destroy Snapshots
echo "Destroying Snapshots"
xe vm-uninstall uuid=$NEW_UUID force=true
