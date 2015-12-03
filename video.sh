#!/bin/bash
#####################################
# video.sh
#
# Author: Michael Lindholm
#####################################

# Capture first video filename to variable
VIDEO=`ls /var/media/videos/* | head -n 1`

# Play video file, output sound to HDMI
/usr/bin/omxplayer -o hdmi $VIDEO
