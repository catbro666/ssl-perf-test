#!/bin/bash

# Calculates the sum of the wrk results
# Example: ./test-sum.sh tps

if [ $# -eq 0 ]; then
    test=tps
else
    test=$1
fi

./test-$test.sh | grep "Requests/sec" | awk 'BEGIN {sum=0} {sum+=$2} END{print sum}'
