#!/bin/bash
#start the spark mesos dispatcher ot run mesos in cluster mode
#
/opt/spark-2.2.0-bin-hadoop2.7/sbin/start-mesos-dispatcher.sh --master mesos://`cat /tmp/master.ip`:5050  
echo "/opt/spark-2.2.0-bin-hadoop2.7/sbin/start-mesos-dispatcher.sh --master mesos://`cat /tmp/master.ip`:5050" 
