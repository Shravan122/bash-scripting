#!/bin/bash

set -e 

source components/common.sh 

COMPONENT=redis

echo -n "Configuring the $COMPONENT repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>> /tmp/${COMPONENT}.log
stat $?

echo -n "Installing $COMPONENT:"
yum install redis-6.2.7 -y  &>> /tmp/${COMPONENT}.log
stat $? 

echo -n "Whitelisting the redis config:"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf 
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
stat $?

echo -n "Starting $COMPONENT:"
 systemctl  daemon-reload  &>> /tmp/${COMPONENT}.log
 systemctl  enable $COMPONENT  &>> /tmp/${COMPONENT}.log
 systemctl  restart  $COMPONENT  &>> /tmp/${COMPONENT}.log
 systemctl  start   $COMPONENT &>> /tmp/${COMPONENT}.log 
 stat $?


# Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf 


