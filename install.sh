#!/bin/bash

sudo apt-get --assume-yes install mc
sudo apt-get --assume-yes install vim
sudo apt-get --assume-yes install htop
sudo apt-get --assume-yes install rsync
sudo apt-get --assume-yes install transmission-daemon
sudo service transmission-daemon stop
sudo cp -r /etc/transmission-daemon ~/.config/transmission-daemon
sudo cp ./settings.json ~/.config/transmission-daemon
sudo chown -R xbian ~/.config

cat /etc/default/transmission-daemon | grep -v CONFIG_DIR | grep -v USER | sudo tee /etc/default/transmission-daemon
echo 'CONFIG_DIR="/home/xbian/.config/transmission-daemon"' | sudo tee -a /etc/default/transmission-daemon
echo 'USER=xbian' | sudo tee -a /etc/default/transmission-daemon
sudo sed -i 's/USER=.*/USER=xbian/'  /etc/init.d/transmission-daemon

mkdir -p /home/xbian/backup_logs
mkdir -p /home/xbian/backup_scripts
chmod u+x ./backup_from_wdred4g_to_wdgreen1g.sh
cp ./backup_from_wdred4g_to_wdgreen1g.sh /home/xbian/backup_scripts
crontab -l | { cat; echo "0 10-22 * * * /home/xbian/backup_scripts/backup_from_wdred4g_to_wdgreen1g.sh"; } | sort|uniq |crontab -

cp ./shares.conf /etc/samba/

