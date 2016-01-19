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
sudo apt-get install -y fbi screen omxplayer imagemagick python-pygame git

# Clone the github directory
mkdir -p git-tmp
cd $HOME
cd git-tmp
rm -rf RaspPiSlideshow
git clone https://github.com/micglin/RaspPiSlideshow
cd RaspPiSlideshow
chmod a+x install.sh
sudo ./install.sh
