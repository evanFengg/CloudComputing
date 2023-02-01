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

# Run sysbench file io tests in sequential write mode and sequential read mode
# Each test is run 5 times on each VM configuration
echo "File IO Test in Sequential Write Mode"
echo "-------------------------------------"
for ((counter = 1; counter < 6; counter++))
do
    echo "Test $counter"
    # Create the files to test
    sysbench --test=fileio --file-num=64 --file-total-size=4G prepare
    # Run the actual test
    sysbench --test=fileio --file-num=64 --file-total-size=4G --file-test-mode=seqwr --max-time=60 run
    # Cleanup the test files
    sysbench --test=fileio cleanup
    # Drop the cache
    sh -c 'echo 3 > /proc/sys/vm/drop_caches'
done

echo "File IO Test in Sequential Read Mode"
echo "------------------------------------"
for ((counter = 1; counter < 6; counter++))
do
    echo "Test $counter"
    # Create the files to test
    sysbench --test=fileio --file-num=64 --file-total-size=4G prepare
    # Run the actual test
    sysbench --test=fileio --file-num=64 --file-total-size=4G --file-test-mode=seqrd --max-time=60 run
    # Cleanup the test files
    sysbench --test=fileio cleanup
    # Drop the cache
    sh -c 'echo 3 > /proc/sys/vm/drop_caches'
done
