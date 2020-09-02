#!/bin/bash

sudo apt-get remove vim -y
sudo apt-get remove unzip -y
sudo apt-get remove binutils -y
sudo apt-get remove login -y --allow-remove-essential

sudo DEBIAN_FRONTEND=noninteractive apt-get remove cron -y

#New package to be deleted
sudo apt-get remove python3-xdg -y

#New Packages to be deleted for Medium vulnerability
sudo apt-get remove accountsservice -y
sudo apt-get remove rpm -y
sudo apt-get remove ncurses-bin -y
sudo apt-get remove cryptsetup -y
sudo apt-get remove man-db -y
sudo apt-get remove xdg-user-dirs -y
sudo apt-get remove byobu -y
sudo apt autoremove -y
