#!/bin/bash

curl -O https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install
sudo bash install
sudo /etc/init.d/awsagent start
sudo /opt/aws/awsagent/bin/awsagent status
