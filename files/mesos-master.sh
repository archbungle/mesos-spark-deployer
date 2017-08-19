#!/bin/bash
#Start the mesos master
# Start Mesos master (ensure work directory exists and has proper permissions).
nohup /opt/mesos/build/bin/mesos-master.sh --ip=`hostname -i` --work_dir=/var/lib/mesos &
