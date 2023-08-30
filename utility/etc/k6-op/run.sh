#!/bin/bash
#while :
#do
port=6565
for ((i=0 ; i < $1 ; i++));
do
	k6 run test_kafka.js  --address localhost:$(($i + $port)) > /dev/null &
done
#done
