#!/bin/bash
./store.sh
echo 600            > /proc/sys/net/core/netdev_budget
echo 128            > /proc/sys/net/core/dev_weight
echo 0              > /proc/sys/net/ipv4/tcp_fin_timeout
echo 0              > /proc/sys/net/ipv4/tcp_tw_reuse
echo 0              > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo 1025 65535     > /proc/sys/net/ipv4/ip_local_port_range
echo 131072         > /proc/sys/net/core/somaxconn
echo 262144         > /proc/sys/net/ipv4/tcp_max_orphans
echo 262144         > /proc/sys/net/core/netdev_max_backlog
echo 262144         > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo 4000000        > /proc/sys/fs/nr_open
echo 8000000        > /proc/sys/fs/file-max
echo 0              > /proc/sys/net/ipv4/tcp_abort_on_overflow
