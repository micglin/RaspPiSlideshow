#!/bin/bash
#####################################
# setup.sh
#
# Author: Michael Lindholm
#####################################
# Update apt
sudo apt-get update

# Upgrade OS
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y fbi screen omxplayer

# Create base directories
sudo mkdir -p /var/media/scripts
sudo mkdir -p /var/media/current
sudo mkdir -p /var/media/slides
sudo mkdir -p /var/media/videos
sudo chmod -R 777 /var/media

# git scripts magic goes here
# wget http://git/video.sh -O /var/media/scripts/video.sh
# wget http://git/slides.sh -O /var/media/scripts/slides.sh
# wget http://git/refresh.sh -O /var/media/scripts/refresh.sh

#Setup Crontab
cat <<EOF | sudo crontab -
*/30 * * * * /var/media/scripts/video.sh
@reboot /var/media/scripts/slides.sh
* * * * * /var/media/scripts/refresh.sh
EOF