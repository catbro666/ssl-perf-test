#!/bin/bash
# irq binding and RPS
# Example: ./irqbind.sh eth0        # Get
#          ./irqbind.sh eth0 set    # Set

dec2hex() {
    printf "%x" $1
}

abort() {
    echo "$1"
    exit 1
}

set=0

if [ $# -lt 1 ]; then
    abort "Usage: $0 dev [set]"
fi

if [ "$1" == "-h" ] || [ "$1" == "help" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 dev [set]"
    exit 0
fi
dev=$1

#ip link | grep "^[[:digit:]]" | awk -F': ' '{print $2}' | grep $dev
ip link show $dev > /dev/null
if [ $? -ne 0 ]; then
    abort "device $1 not existed!"
fi

if [ "$2" == "set" ]; then
    set=1
fi 

pkill -9 irqbalance

# IRQ numbers of the specified device
start=$(cat /proc/interrupts | grep $dev- | head -1 | awk -F: '{i=$1+0; print i}')
num=$(cat /proc/interrupts | grep $dev- | wc -l)
end=$(expr $start + $num - 1)

# the number of cpu cores
cpunum=$(lscpu | grep '^CPU(s): ' | awk '{print $NF}')

# bind the IRQ numbers to CPUs
for i in $(seq 0 `expr $num - 1`) 
do
    if [ $set -eq 1 ]; then
        echo $i > /proc/irq/`expr $start + $i`/smp_affinity_list	
    fi
    echo -ne "/proc/irq/`expr $start + $i`/smp_affinity_list\t\t"
    cat /proc/irq/`expr $start + $i`/smp_affinity_list
done

# Use RPS if necessary, when the number of queues is less than that of CPUs
# The number of queues should not be greater than that of CPUs
if [ $num -lt $cpunum ]; then
    for i in $(seq 0 `expr $num - 1`) 
    do
        if [ $set -eq 1 ]; then
            mask=0
            n=$i
            while [ $n -le `expr $cpunum - 1` ]
            do
                mask=`expr $mask + $(( 1 << $n ))`
                n=`expr $n + $num`
            done
            echo `dec2hex $mask` > /sys/class/net/$dev/queues/rx-$i/rps_cpus
            #echo `dec2hex $mask` > /sys/class/net/$dev/queues/tx-$i/xps_cpus
        fi
        echo -ne "/sys/class/net/$dev/queues/rx-$i/rps_cpus\t\t"
        cat /sys/class/net/$dev/queues/rx-$i/rps_cpus
        #echo -ne "/sys/class/net/$dev/queues/tx-$i/xps_cpus\t\t"
        #cat /sys/class/net/$dev/queues/tx-$i/xps_cpus
    done
fi


