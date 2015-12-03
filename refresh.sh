#!/bin/bash
#####################################
# refresh.sh
#
# Author: Michael Lindholm
#####################################
DATE=`date`

# Update slides.txt
ls -v /var/media/slides/* | grep JPG > /var/media/scripts/slides.new.txt

# Diff slides files
diff /var/media/scripts/slides.new.txt /var/media/scripts/slides.txt

# If the files are different then replace slides.txt and kill fbi
if [[ $? != 0 ]]
then
  echo “$DATE - New slides found.  Killing fbi” >> /var/media/scripts/refresh.log
  rm -f /var/media/current/*
  cp /var/media/slides/* /var/media/current/
  mv /var/media/scripts/slides.new.txt /var/media/scripts/slides.txt
  killall -9 fbi
fi