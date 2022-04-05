#!/bin/bash
# 最大并发 Max Connections

server=192.168.100.20:55555
net=192.168.100
startip=100

cpu_num=$(cat /proc/cpuinfo |grep processor |wc -l)
cpu_num=$(($cpu_num - 1))
for i in $(seq 0 $cpu_num); do
# specify separate IP for each process
	taskset -c $i ./wrk2 -t 1 -c 15000 -d 600s --timeout 200s -b $net.`expr $i + $startip` --clientcert sm2-user.pem --clientkey sm2-user.key --protocol gmvpn --cipher ECC-SM4-SM3 -R 600 https://$server/0kb &

# use single IP
	#taskset -c $i ./wrk2 -t 1 -c 15000 -d 600s --timeout 200s --clientcert sm2-user.pem --clientkey sm2-user.key --protocol gmvpn --cipher ECC-SM4-SM3 -R 600 https://$server/0kb &
done
