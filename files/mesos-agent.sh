#!/bin/bash
#Start the mesos slave 
# Start Mesos master (ensure work directory exists and has proper permissions).
nohup /opt/mesos/build/bin/mesos-agent.sh --master=`cat /tmp/master.ip`:5050 --work_dir=/var/lib/mesos &
