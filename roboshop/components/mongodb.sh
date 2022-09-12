#!/bin/bash

source components/common.sh  

COMPONENT=mongodb

echo -n "Configuring the MongoDB repo:"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo 
stat $?

echo -n "Installing ${COMPONENT}:" 
yum install -y mongodb-org
stat $? 

echo -n "Updating the $COMPONENT config:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 
stat $?

echo -n "Start the $COMPONENT service:" 
systemctl enable mongod  >> /tmp/${COMPONENT}.log
systemctl start mongod 
stat $?
