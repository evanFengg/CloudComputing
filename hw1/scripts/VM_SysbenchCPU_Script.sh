#!/bin/bash



# This gets the total memory in MB allocated to the VM to detect current VM Configuration
mem=$(free -m | grep "Mem:" | awk '{print $2}')

if [ $mem -le 512 ];
then
    echo "Low-memory QEMU VM Sysbench CPU Tests: 2 core, 512 MB Memory"
    echo "==========================================================="
    
elif [ $mem -le 1024 ];
then
    echo "Middle-memory QEMU VM Sysbench CPU Tests: 2 core, 1024 MB Memory"
    echo "================================================================"
    
elif [ $mem -le 2048 ];
then
    echo "High-memory QEMU VM Sysbench CPU Tests: 2 core, 2048 MB Memory"
    echo "=============================================================="
    
else
    echo "Incorrect Memory to run sysbench, needs to match preset configurations"
    exit 1
fi

# Run sysbench CPU test for 5 times on each VM configuration
for ((counter = 1; counter < 6; counter++))
do
    echo "Test $counter"
    echo "------"
    sysbench --test=cpu --cpu-max-prime=10000 --time=30 run
done
