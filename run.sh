#!/bin/bash
#set -x
#脚本变量
APP_PATH=/usr/local/webserver/apps/jenkins
APP_NAME=jenkins.war
HTTP_HOST=127.0.0.1
HTTP_PORT=8008
#菜单项
usage() {
 echo "Usage: sh run.sh [start|stop|restart|status|log]"
 exit 1
}

is_exist(){
 pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
 #如果不存在返回1，存在返回0
 if [ -z "${pid}" ]; then
 return 1
 else
 return 0
 fi
}
#启动脚本
start(){
 is_exist
 if [ $? -eq "0" ]; then
  echo "${APP_NAME} is already running. pid=${pid} ."
 else
  #.jar和log文件位置；定义内存大小；端口等。
  nohup java -jar -Xms256M -Xmx512M -XX:PermSize=128M -XX:MaxPermSize=256M $APP_PATH/$APP_NAME --ajp13Port=-1 --httpPort=$HTTP_PORT --httpListenAddress=$HTTP_HOST   > run.log   2>&1 & 
  if [[ $2 = "log" ]]; then
   #打印log日志：
   tail -f $APP_PATH/run.log
  fi
 fi
}
#停止脚本
stop(){
 is_exist
 if [ $? -eq "0" ]; then
 kill -9 $pid
 echo "${APP_NAME} is stop"
 else
 echo "${APP_NAME} is not running"
 fi
}
#显示当前jar运行状态
status(){
 is_exist
 if [ $? -eq "0" ]; then
 echo "${APP_NAME} is running. Pid is ${pid}"
 else
 echo "${APP_NAME} is cease."
 fi
}
#查看日志
log(){
 is_exist
 if [ $? -eq "0" ]; then
 	if [ $1 -gt 0 ]; then
  		#打印log日志：
 		echo "${APP_NAME} is already running. pid=${pid} ."
   		tail -fn$2 $APP_PATH/run.log
	else
   		tail -f $APP_PATH/run.log
 	fi
 else
 echo "${APP_NAME} is not running"
 fi
}
#重启脚本
restart(){
 stop
 start
}

case "$1" in
 "start")
 start
 ;;
 "stop")
 stop
 ;;
 "status")
 status
 ;;
 "log")
 log
 ;;
 "restart")
 restart
 ;;
 *)
 usage
 ;;
esac
