#!/bin/bash
#while :
#do
port=6565
for ((i=0 ; i < $1 ; i++));
do
	port=$(($port+1000))
	k6 run test_logstash.js --address localhost:$(($i + $port)) > /dev/null &
#	for ((j=1 ; j < $2+1 ; j++));
#	do
#		k6 run test_kafka$j.js --address localhost:$(($j + $port)) > /dev/null &
#
#	done
done
#done
