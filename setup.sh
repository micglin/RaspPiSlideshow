#!/bin/bash
#####################################
# setup.sh
#
# Author: Michael Lindholm
#####################################
# Update apt cache
sudo apt-get update

# Upgrade OS packages
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y fbi screen omxplayer

# Create working directories
sudo mkdir -p /var/media/scripts
sudo mkdir -p /var/media/logs
sudo mkdir -p /var/media/current	# Working directory for running slideshow
sudo mkdir -p /var/media/slides 	# Upload location for new slide files
sudo mkdir -p /var/media/videos
sudo chmod -R 777 /var/media

# Pull scripts from git repo
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/video.sh -O /var/media/scripts/video.sh
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/slides.sh -O /var/media/scripts/slides.sh
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/refresh.sh -O /var/media/scripts/refresh.sh

#Setup Crontab
cat <<EOF | sudo crontab -
*/30 * * * * /var/media/scripts/video.sh
@reboot /var/media/scripts/slides.sh
* * * * * /var/media/scripts/refresh.sh
EOF
