#!/bin/bash 

set -e 

source components/common.sh 

COMPONENT=cart
FUSER=roboshop 

  echo -n "Configure yum Remos for nodejs:"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  >>/tmp/${COMPONENT}.log 
  stat $?

  echo -n "Installing nodejs:"
  yum install nodejs -y  >>/tmp/${COMPONENT}.log
   stat $? 

   echo -n "Adding $FUSER user:" 
   id ${FUSER} >>/tmp/${COMPONENT}.log || useradd ${FUSER} 
   stat $?

   echo -n "Downloading the $COMPONENT:"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" >>/tmp/${COMPONENT}.log
    stat $? 

    echo -n "Clean up of old $COMPONENT content:"
    rm -rf /home/${FUSER}/${COMPONENT} >>/tmp/${COMPONENT}.log 
    stat $?

   echo -n "Extracting $COMPONENT content:"
   cd /home/${FUSER}  >>/tmp/${COMPONENT}.log 
   unzip -o /tmp/${COMPONENT}.zip >>/tmp/${COMPONENT}.log   && mv ${COMPONENT}-main ${COMPONENT} && cd /home/${FUSER}/${COMPONENT} >>/tmp/${COMPONENT}.log 
   stat $?  

    echo -n "Installing $COMPONENT Dependencies:" 
    npm install  &>>/tmp/${COMPONENT}.log
    stat $? 

      echo -n "Setup Systemd file:" 
       sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service 
       mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
       stat $?
      
      echo -n "Starting the service:"
        systemctl daemon-reload    &>>/tmp/${COMPONENT}.log 
        systemctl enable ${COMPONENT} &>>/tmp/${COMPONENT}.log 
        systemctl start ${COMPONENT}  &>>/tmp/${COMPONENT}.log 
        stat $?