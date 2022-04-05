#!/bin/bash
# 长连接HTTP业务测试 RPS

server=192.168.100.20:55555
net=192.168.100
startip=100

cpu_num=$(cat /proc/cpuinfo |grep processor |wc -l)
cpu_num=$(($cpu_num - 1))
for i in $(seq 0 $cpu_num); do
# specify separate IP for each process
	taskset -c $i ./wrk2 -t 1 -c 10 -d 30s --timeout 15s -b $net.`expr $i + $startip` --clientcert sm2-user.pem --clientkey sm2-user.key --protocol gmvpn --cipher ECC-SM4-SM3 -R 5000 https://$server/1kb &

# use single IP
	#taskset -c $i ./wrk2 -t 1 -c 10 -d 30s --timeout 15s --clientcert sm2-user.pem --clientkey sm2-user.key --protocol gmvpn --cipher ECC-SM4-SM3 -R 5000 https://$server/1kb &

done
