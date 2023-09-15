#!/bin/bash
export PGPASSWORD="postgres"
FAILOVER_TRIGGER_FILE=/var/lib/postgresql/data/failover
TARGET_SERVER=192.168.2.211
CHECK_STANDBY=$(ls -l /var/lib/postgresql/data/standby.signal|awk '{print $5}')

while :
do
	if [ $CHECK_STANDBY = 0 ]; then
        current_status=0

  	if [ $(psql -h $TARGET_SERVER -t --quiet -c "select status from check_health") = 1 ] 
	then
		current_status=0
		echo "ready"
		sleep 5 
		echo $current_status
	else
		for ((var=0 ; var < $1 ; var++));
		do
			current_status=$((current_status+1))
			echo "not ready"
			sleep 5
			echo $current_status
		done
	fi
	echo $current_status
	if [ $current_status = $1 ]
	then
	touch $FAILOVER_TRIGGER_FILE
#	echo "failover_proceded" >> $LOG_FILE
	echo "failover_succecced"
	break
        fi

fi
done

