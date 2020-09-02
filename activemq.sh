#!/bin/bash

#Install JDK 1.8
sudo mkdir /usr/lib/jvm
cd /usr/lib/jvm

sudo tar -xvf /tmp/jdk-8u251-linux-x64.tar.gz

sudo echo $'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk1.8.0_251/bin:/usr/lib/jvm/jdk1.8.0_251/db/bin:/usr/lib/jvm/jdk1.8.0_251/jre/bin" \nJ2SDKDIR="/usr/lib/jvm/jdk1.8.0_251" \nJ2REDIR="/usr/lib/jvm/jdk1.8.0_251/jre" \nJAVA_HOME="/usr/lib/jvm/jdk1.8.0_251" \nDERBY_HOME="/usr/lib/jvm/jdk1.8.0_251/db"' > /etc/environment

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_251/bin/java" 0
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_251/bin/javac" 0
sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_251/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_251/bin/javac

sudo java -version

# rm jdk-8u241-linux-x64.tar.gz

#Install ActiveMQ
cd /opt
sudo wget https://downloads.apache.org/activemq/5.15.13/apache-activemq-5.15.13-bin.tar.gz
sudo tar zxf apache-activemq-5.15.13-bin.tar.gz
sudo ln -s /opt/apache-activemq-5.15.13 activemq
sudo service /opt/apache-activemq-5.15.13/bin/activemq start
sudo service /opt/apache-activemq-5.15.13/bin/activemq status
sudo /opt/apache-activemq-5.15.13/bin/activemq --version
# sudo rm apache-activemq-5.15.13-bin.tar.gz