#!/bin/bash

modprobe bonding

#mode: 0 balance-rr, 1 active-backup, 2 balance-xor, 3broadcast
#      4 802.3ad, 5balance-tlb, 6 balance-alb
ip link add bond0 type bond mode 0 miimon 100

ifconfig eth2 down
ifconfig eth3 down
ifconfig eth4 down
ifconfig eth5 down

sudo ip link set eth2 master bond0
sudo ip link set eth3 master bond0
sudo ip link set eth4 master bond0
sudo ip link set eth5 master bond0

ifconfig bond0 192.168.200.10/24

# delete bond0
#ip link delete bond0
