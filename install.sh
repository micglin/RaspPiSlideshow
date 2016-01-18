#!/bin/bash
#####################################
# setup.sh
#
# Author: Michael Lindholm, Ben Allen
#####################################

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
cp video.sh /var/media/scripts
cp slides.sh /var/media/scripts
cp refresh.sh /var/media/scripts
cp disp.py /var/media/scripts

cp media/bg.jpg /var/media/bg.jpg

cp 1.jpg /var/media/slides/
cp 2.jpg /var/media/slides/
cp 3.jpg /var/media/slides/

cp logos/* /var/media/logos/

cp -rp data/* /var/media/data/

wget https://app.kronusec.com/pear/get/repo/checkin.sh -O /var/media/scripts/checkin.sh

# Make executable

sudo chmod a+x /var/media/scripts/*.sh
sudo chmod a+x /var/media/scripts/*.py

#Setup Crontab
cat <<EOF | sudo crontab -
*/30 * * * * /var/media/scripts/video.sh
@reboot /var/media/scripts/slides.sh
* * * * * /var/media/scripts/refresh.sh
* * * * * /var/media/scripts/checkin.sh 1>/dev/null 2>&1
EOF

# Create the service enabled file
sudo touch /var/media/enabled
