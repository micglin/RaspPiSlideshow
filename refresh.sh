#!/bin/bash
#####################################
# refresh.sh
#
# Author: Michael Lindholm
#####################################

DATE=`date`

# Update slides.txt
ls -v /var/media/slides/* | grep JPG > /var/media/logs/slides.new.txt

# Diff slides files
diff /var/media/logs/slides.new.txt /var/media/logs/slides.txt

# If the files are different then replace slides.txt and kill fbi
if [[ $? != 0 ]]
then
  echo “$DATE - New slides found.  Killing fbi” >> /var/media/logs/refresh.log
  # Flush current slide deck
  rm -f /var/media/current/*
  # Update slide deck
  cp /var/media/slides/* /var/media/current/
  # Set new slide list file
  mv /var/media/logs/slides.new.txt /var/media/logs/slides.txt
  # Quit fbi gently so the console doesn't get stuck; slides.sh will relaunch
  killall -3 fbi
fi