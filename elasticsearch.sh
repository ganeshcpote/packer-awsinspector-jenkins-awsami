#!/bin/bash

sudo groupadd elasticsearch
sudo useradd -s /sbin/nologin -d /usr/local/elasticsearch -c "Elasticsearch User" -g elasticsearch elasticsearch
sudo dpkg --configure -a

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

#Install Elasticsearch
sudo apt install docker.io -y
cd /tmp
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.deb
sudo dpkg -i elasticsearch-6.3.2.deb
sudo systemctl enable elasticsearch.service