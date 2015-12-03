#!/bin/bash
#####################################
# slides.sh
#
# Author: Michael Lindholm
#####################################
# Generate slides.txt on first run.
/var/media/scripts/refresh.sh

# Start FBI
while true
do
  DATE=`date`

  # Collect the PID of fbi
  _PID=`pidof fbi`

  # If PID is NOT running restart it.
  if [[ $? != 0 ]]
  then
    echo “$DATE - fbi not running.  Restarting.” >> /var/media/scripts/slides.log
    /usr/bin/fbi -T 1 -d /dev/fb0 --noverbose -a -t 3 -l /var/media/scripts/slides.txt
  fi
  sleep 5
done