# RaspPiSlideshow
Scripts/configs for a simple image slideshow on Raspberry Pi

To setup a Raspberry Pi from scratch.

Download and image Raspbian Lite to an SD card:

Base Image
Download URL:
Raspbian Lite: https://downloads.raspberrypi.org/raspbian_lite_latest
Downloaded from: https://www.raspberrypi.org/downloads/raspbian/

(currently) Perform initial boot and configuration of device, expand file system to fill SD card.

from ssh session or console:
	wget https://raw.githubusercontent.com/micglin/RaspPiSlideshow/master/setup.sh
	chmod a+x setup.sh
	./setup.sh

(currently) SCP slideshow files to /var/media/slideshow
			SCP videos files to /var/media/videos
			
Slideshow will cycle through all jpeg files, in ascending file name order.

Video will play on the hour and the half-hour.

Upload a new set of image files to /var/media/slideshow, and the slideshow will automatically reset to the new content within 60 seconds.
