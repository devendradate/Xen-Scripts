#!/bin/bash

#Find all running vm's uuid

UUID=$(xe vm-list  | grep running -B 2 | grep uuid | awk '{ print $5 }')
echo $UUID

# Take all UUID of running VM and force shutdown it
for name in $UUID
do
  xe vm-shutdown uuid=$name force=true
done

sleep 20s

# Shutdown the main Xen server too
init 0
