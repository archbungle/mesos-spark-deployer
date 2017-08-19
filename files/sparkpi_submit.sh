#!/bin/bash
#submit the test sparkpi job
/opt/spark-2.2.0-bin-hadoop2.7/bin/spark-submit --class org.apache.spark.examples.SparkPi --master mesos://`cat /tmp/master.ip`:7077 --deploy-mode cluster --supervise --executor-memory 4G --total-executor-cores 8 /opt/spark-2.2.0-bin-hadoop2.7/examples/jars/spark-examples_2.11-2.2.0.jar 10000
