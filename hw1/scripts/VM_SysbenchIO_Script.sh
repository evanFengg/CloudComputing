#!/bin/bash


# This gets the total memory in MB allocated to the VM to detect current VM Configuration
mem=$(free -m | grep "Mem:" | awk '{print $2}')

if [ $mem -le 512 ];
then
    echo "Low-memory QEMU VM Sysbench File IO Tests: 2 core, 512 MB Memory"
    echo "================================================================"
    
elif [ $mem -le 1024 ];
then
    echo "Middle-memory QEMU VM Sysbench File IO Tests: 2 core, 1024 MB Memory"
    echo "===================================================================="
    
elif [ $mem -le 2048 ];
then
    echo "High-memory QEMU VM Sysbench File IO Tests: 2 core, 2048 MB Memory"
    echo "=================================================================="
    
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
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
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
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
done
