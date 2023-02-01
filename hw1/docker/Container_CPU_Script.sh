#!/bin/bash



#Arg = 0 - low-memory config, 512 MB
#Arg = 1 - middle-memory config, 1 GB
#Arg = 2 - high-memory config, 2GB

contain_config=$(( 0 ))

if [ $contain_config -eq 0 ];
then
    echo "Low-memory Docker Container Sysbench CPU Tests: 2 core, 512 MB Memory"
    echo "==========================================================="
    
elif [ $contain_config -eq 1 ];
then
    echo "Middle-memory Docker Container Sysbench CPU Tests: 2 core, 1024 MB Memory"
    echo "================================================================"
    
elif [ $contain_config -eq 2 ];
then
    echo "High-memory Docker Container Sysbench CPU Tests: 2 core, 2048 MB Memory"
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
