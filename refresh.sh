#!/bin/bash
#####################################
# refresh.sh
#
# Author: Michael Lindholm
#####################################

DATE=`date`

# Update slides.txt
ls -v /var/media/slides/* | grep JPG > /var/media/logs/slides.new.txt
md5sum /var/media/slides/* | grep JPG > /var/media/logs/slides.new.md5
md5sum /var/media/current/* | grep JPG > /var/media/logs/slides.current.md5

# Diff slides files
diff /var/media/logs/slides.current.md5 /var/media/logs/slides.new.md5

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
<<<<<<< HEAD
  # Quit fbi gently so the console doesn't get stuck; slides.sh will relaunch
  killall -3 fbi
fi
=======
  killall -9 fbi
fi
>>>>>>> 4b821f2c4cd36ec12c90212effacf73e77ba24d7
