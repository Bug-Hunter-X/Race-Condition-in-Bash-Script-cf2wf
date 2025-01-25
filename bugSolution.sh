#!/bin/bash

# This script demonstrates a solution to the race condition bug using a lock file.

# Create a lock file
lockFile="my.lock"

# Function to acquire the lock
acquireLock() {
  while ! flock -n "$lockFile"; do
    sleep 0.1
  done
}

# Function to release the lock
releaseLock() {
  flock -u "$lockFile"
}

# Create two files
touch file1.txt
touch file2.txt

# Process 1
( acquireLock; while true; do echo "Process 1" >> file1.txt; sleep 0.1; done ) &
PID1=$!

# Process 2
( acquireLock; while true; do echo "Process 2" >> file2.txt; sleep 0.1; done ) &
PID2=$!

# Wait for a certain period before killing the processes
sleep 5
kill $PID1 $PID2
releaseLock

# Examine output - the files should be consistently written without corruption
cat file1.txt
cat file2.txt
rm $lockFile