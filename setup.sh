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
sudo apt-get install -y fbi screen omxplayer imagemagick python-pygame

# Create working directories
sudo mkdir -p /var/media/scripts
sudo mkdir -p /var/media/logs
sudo mkdir -p /var/media/current	# Working directory for running slideshow
sudo mkdir -p /var/media/slides 	# Upload location for new slide files
sudo mkdir -p /var/media/videos
sudo mkdir -p /var/media/data
sudo mkdir -p /var/media/data/yimg
sudo mkdir -p /var/media/logos
sudo chmod -R 777 /var/media

# Pull scripts from git repo
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/video.sh -O /var/media/scripts/video.sh
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/slides.sh -O /var/media/scripts/slides.sh
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/refresh.sh -O /var/media/scripts/refresh.sh
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/disp.py -O /var/media/scripts/disp.py
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/media/bg.jpg -O /var/media/bg.jpg
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/media/1.jpg -O /var/media/slides/1.jpg
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/media/2.jpg -O /var/media/slides/2.jpg
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/media/3.jpg -O /var/media/slides/3.jpg
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/logos/logo.png -O /var/media/logos/logo.png
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/data/stock.json -O /var/media/data/stock.json
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/data/weather.json -O /var/media/data/weather.json
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/data/line1.txt -O /var/media/data/line1.txt
wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/data/line2.txt -O /var/media/data/line2.txt
wget https://app.kronusec.com/pear/get/repo/checkin.sh -O /var/media/scripts/checkin.sh

# Make executable

sudo chmod a+x /var/media/scripts/*.sh

#Setup Crontab
cat <<EOF | sudo crontab -
*/30 * * * * /var/media/scripts/video.sh
@reboot /var/media/scripts/slides.sh
* * * * * /var/media/scripts/refresh.sh
* * * * * /var/media/scripts/checkin.sh 1>/dev/null 2>&1
EOF

# Create the service enabled file
sudo touch /var/media/enabled
