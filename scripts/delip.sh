#!/bin/bash
# Deletes the IPs set by setip.sh
#
# Example: ./detip.sh eth0 100

abort() {
    echo "$1"
    exit 1
}

if [ $# -lt 1 ]; then
    abort "Usage: $0 dev [startip]
Example: ./detip.sh eth0 100"
fi

dev=$1
if [ $# -gt 1 ]; then
    startip=$2
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
        ifconfig $dev:$i 0.0.0.0
done
