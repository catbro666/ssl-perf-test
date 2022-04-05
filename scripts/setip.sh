#!/bin/bash
# Sets multiple IPs on a device
# the number of IPs is same as the number of CPU cores
# Note the netmask 24 bits, and the IP is started from
# xxx.xxx.xxx.100 by default.
#
# Example: ./setip.sh eth0 192.169.100 100

abort() {
    echo "$1"
    exit 1
}

if [ $# -lt 2 ]; then
    abort "Usage: $0 dev network [startip]
Example: ./setip.sh eth0 192.169.100 100"
fi

dev=$1
net=$2

if [ $# -gt 2 ]; then
    startip=$3
else
    startip=100
fi

ip link show $dev > /dev/null
if [ $? -ne 0 ]; then
    abort "device $dev not existed!"
fi

cpu_num=$(cat /proc/cpuinfo |grep processor |wc -l)

for i in $(seq $startip `expr $cpu_num + $startip - 1`)
do
        ifconfig $dev:$i $net.$i/24 up
done
