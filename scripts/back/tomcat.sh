#!/bin/bash

# 配置环境变量  需要根据自己的服务情况自行修改
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.x86_64
export PATH=$JAVA_HOME/bin:$PATH
export CATALINA_HOME=/root/tomcat/apache-tomcat-7.0.82

case "$1" in 
start)  
    echo "Starting Tomcat..."
    sh $CATALINA_HOME/bin/startup.sh  
;;   

stop)
    echo "Stopping Tomcat..." 
    sh $CATALINA_HOME/bin/shutdown.sh  
;;

restart)  
    echo "Stopping Tomcat..."
    sh $CATALANA_HOME/bin/shutdown.sh
    sleep 2
    echo "Starting Tomcat..."
    sh $CATALANA_HOME/bin/startup.sh
    echo "restarting Tomcat Successful"
;;   

*)
    echo "Usage: $prog {start|stop|restart}"
;;
esac 
exit 0