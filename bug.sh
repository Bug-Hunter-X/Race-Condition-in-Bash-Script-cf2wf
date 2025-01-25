#!/bin/bash

# This script demonstrates a race condition bug.

# Create two files
touch file1.txt
touch file2.txt

# Start two processes simultaneously that attempt to modify the files.
# If the processes run concurrently, they can overlap and the outcome is unpredictable
( while true; do echo "Process 1" >> file1.txt; sleep 0.1; done ) & 
( while true; do echo "Process 2" >> file2.txt; sleep 0.1; done ) & 

# Wait for a certain period before killing the processes
sleep 5
kill %1 %2

#Examine output - files will be corrupted and contain inconsistent data if race condition occurs
cat file1.txt
cat file2.txt