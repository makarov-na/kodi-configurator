#!/bin/bash

#Установка пакетов 
sudo apt-get --assume-yes install mc
sudo apt-get --assume-yes install vim
sudo apt-get --assume-yes install htop
sudo apt-get --assume-yes install rsync

#Установка transmission
sudo apt-get --assume-yes install transmission-daemon
sudo service transmission-daemon stop
sleep 10
sudo cp -r /etc/transmission-daemon ~/.config/transmission-daemon
sudo cp ./settings.json ~/.config/transmission-daemon
sudo chown -R xbian ~/.config
sudo chmod -R ug+rw ~/.config
sudo sed -i 's/CONFIG_DIR=.*/CONFIG_DIR=\"\/home\/xbian\/\.config\/transmission\-daemon\"/' /etc/default/transmission-daemon
cat /etc/default/transmission-daemon | grep -v USER= | sudo tee /etc/default/transmission-daemon
echo 'USER=xbian' | sudo tee -a /etc/default/transmission-daemon
sudo sed -i 's/USER=.*/USER=xbian/'  /etc/init.d/transmission-daemon
sudo sed -i 's/setuid.*/setuid xbian/'  /etc/init/transmission-daemon.conf
sudo sed -i 's/setgid.*/setgid xbian/'  /etc/init/transmission-daemon.conf

#Скрипты бекапирования
mkdir -p /home/xbian/backup_logs
mkdir -p /home/xbian/backup_scripts
chmod u+x ./backup_from_wdred4g_to_wdgreen1g.sh
cp ./backup_from_wdred4g_to_wdgreen1g.sh /home/xbian/backup_scripts
cp ./backup_from_wdred4g_to_seagate.sh /home/xbian/backup_scripts
cp ./backup_from_wdred4g_to_seagate_run_in_back.sh /home/xbian/backup_scripts

#Запуск бекапирования каждый день в 10:00
crontab -l | { cat; echo "0 10 * * * /home/xbian/backup_scripts/backup_from_wdred4g_to_wdgreen1g.sh"; } | sort|uniq |crontab -

#Настройка SMB
sudo cp ./shares.conf /etc/samba/
sudo sed -i 's/SHARESMB=yes/SHARESMB=no/' /etc/usbmount/usbmount.conf
