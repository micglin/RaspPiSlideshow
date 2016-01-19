#!/bin/bash
#####################################
# setup.sh
#
# Author: Michael Lindholm, Ben Allen
#####################################

############################################
# Check if this script is running as root.
if [[ `whoami` != "root" ]]
then
  echo "This install must be run as root or with sudo."
  exit
fi

# Create working directories
mkdir -p /var/media/scripts
mkdir -p /var/media/logs
mkdir -p /var/media/current	# Working directory for running slideshow
mkdir -p /var/media/slides 	# Upload location for new slide files
mkdir -p /var/media/videos
mkdir -p /var/media/data
mkdir -p /var/media/data/yimg
mkdir -p /var/media/logos
chmod -R 777 /var/media

# Pull scripts from git repo
cp video.sh /var/media/scripts
cp slides.sh /var/media/scripts
cp refresh.sh /var/media/scripts
cp disp.py /var/media/scripts

cp media/bg.jpg /var/media/bg.jpg

cp media/1.jpg /var/media/slides/
cp media/2.jpg /var/media/slides/
cp media/3.jpg /var/media/slides/

cp logos/* /var/media/logos/

cp -rp data/* /var/media/data/

wget https://app.kronusec.com/pear/get/repo/checkin.sh -O /var/media/scripts/checkin.sh

# Make executable

chmod a+x /var/media/scripts/*.sh
chmod a+x /var/media/scripts/*.py

#Setup Crontab
cat <<EOF | sudo crontab -
*/30 * * * * /var/media/scripts/video.sh
@reboot /var/media/scripts/slides.sh
* * * * * /var/media/scripts/refresh.sh
* * * * * /var/media/scripts/checkin.sh 1>/dev/null 2>&1
EOF

# Create the service enabled file
sudo touch /var/media/enabled

apt-get install -y nginx php5 php5-fpm php5-gd

mkdir -p /usr/share/nginx/www/
cp -rp www/* /usr/share/nginx/www/

cat <<EOF >/etc/nginx/sites-enabled/default
# Default Site
server {
        listen   80; ## listen for ipv4; this line is default and implied

        root /usr/share/nginx/www;
        index index.php index.html index.htm;

        location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
        }

        location ~ /\.ht {
                deny all;
        }
}
EOF

ln -s /var/media/slides/ /usr/share/nginx/www/share
chmod -R 777 /usr/share/nginx/www/share
chmod -R 777 /var/media/slides/

/etc/init.d/nginx restart
