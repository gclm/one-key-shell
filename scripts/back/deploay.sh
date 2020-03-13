#!/bin/sh

## java env
export JAVA_HOME=/opt/dev_tools/jdk1.8.0_181
export JRE_HOME=$JAVA_HOME/jre

## exec shell name
EXEC_SHELL_NAME=$1\.sh

## service name
SERVICE_NAME=$1
SERVICE_DIR=/mooc

JAR_NAME=$SERVICE_NAME\.jar

PID=pid/$SERVICE_NAME\.pid

# WORK_DIR=$SERVICE_DIR/work
WORK_DIR=$SERVICE_DIR

#function start
start(){
    cd $WORK_DIR
    if [ ! -d "log" ]; then
        mkdir log
    fi
    nohup $JRE_HOME/bin/java -Xms256m -Xmx512m -jar $JAR_NAME >log/$SERVICE_NAME.out 2>&1 &
    echo $! > $SERVICE_DIR/$PID
    echo "#### start $SERVICE_NAME"
}

# function stop
stop(){
    cd $WORK_DIR
    if [ -f "$SERVICE_DIR/$PID" ]; then
        kill `cat $SERVICE_DIR/$PID`
        rm -rf $SERVICE_DIR/$PID
    fi
    echo "#### stop $SERVICE_NAME"
    sleep 6
    TEMP_PID=`ps -ef | grep -w "$SERVICE_NAME" | grep "java" | awk '{print $2}'`
    if [ "$TEMP_PID" == "" ]; then
        echo "#### $SERVICE_NAME process not exists or stop success"
    else
        echo "#### $SERVICE_NAME process pid is:$TEMP_PID ."
        kill -9 $TEMP_PID
    fi
}

# function clean
clean(){
    cd $WORK_DIR
    if [ ! -d "lastDeploy" ]; then
        mkdir lastDeploy
    else
        rm lastDeploy/$SERVICE_NAME*
    fi
    if [ -f "$JAR_NAME" ]; then
        mv $JAR_NAME lastDeploy
    fi
}

case "$2" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 2
        start
        echo "#### restart $SERVICE_NAME"
        ;;
    clean)
        stop
        sleep 2
        clean
        echo "#### clean $SERVICE_NAME"
        ;;
    *)
       ## restart
       stop
       sleep 2
       start
       ;;
esac
exit 0