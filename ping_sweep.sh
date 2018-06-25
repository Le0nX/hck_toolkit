#!/bin/bash

for i in `seq 1 255`
	do ping -c 1 192.168.1.$i | tr \\n ' ' | awk '/1 packets received/ {print $2}'
done
