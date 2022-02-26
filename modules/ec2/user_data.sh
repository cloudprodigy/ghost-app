#!/bin/bash -xe

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y mysql-server nginx sendmail ruby-full
sudo useradd ghost-admin -s /bin/bash && sudo mkdir -p /home/ghost-admin/.ssh
sudo touch /home/ghost-admin/.ssh/authorized_keys
sudo echo "${ssh_public_key}" > /home/ghost-admin/.ssh/authorized_keys
sudo chmod 700 /home/ghost-admin/.ssh
sudo chmod 600 /home/ghost-admin/.ssh/authorized_keys
chown -R ghost-admin:ghost-admin /home/ghost-admin/
sudo usermod -aG sudo ghost-admin

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${root_password}'"

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash
sudo apt-get install -y nodejs
sudo npm install ghost-cli@latest -g

sudo mkdir -p /var/www/ghost
sudo chown -R ubuntu:ubuntu /var/www/ghost && cd /var/www/ghost

sudo -u ubuntu ghost install \
    --url "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" \
    --db "mysql" \
    --dbhost "localhost" \
    --dbuser "root" \
    --dbpass "${root_password}" \
    --dbname "${db_name}" \
    --process systemd \
    --no-prompt \
    --start

#Cron
sudo mkdir /backup
sudo crontab<<EOF
MAILTO=balkaran.brar@gmail.com
0 0 * * * mysqldump -u root -p$root_password --all-databases > /backup/db_backup.sql
0 0 * * * tar -czf /backup/app_backup.tgz /var/www/ghost 
EOF

#setup codedeploy agent
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile
