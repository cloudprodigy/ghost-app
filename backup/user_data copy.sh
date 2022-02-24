#!/bin/bash -xe

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y mysql-server nginx
sudo useradd ghost-admin -s /bin/bash && sudo mkdir -p /home/ghost-admin/.ssh
sudo touch /home/ghost-admin/.ssh/authorized_keys
sudo echo "${ssh_public_key}" > /home/ghost-admin/.ssh/authorized_keys
sudo chmod 700 /home/ghost-admin/.ssh
sudo chmod 600 /home/ghost-admin/.ssh/authorized_keys
chown -R ghost-admin:ghost-admin /home/ghost-admin/
sudo usermod -aG sudo ghost-admin

# setup mysql users
echo "SETTING UP DB ROOT USER"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${root_password}'"
#sudo mysql -u root -p"$root_password" -e "CREATE DATABASE '$db_name';create user '${db_user}'@'localhost' identified by '${user_password}';  grant all on '${db_name}'.* to '${db_user}'@'localhost';FLUSH PRIVILEGES;" 2> /dev/null

mysql -u root -p"$root_password" -e "create database $db_name;"
# echo "CREATING DATABASE"
# echo "Root password is '${root_password}"

# echo "create database '${db_name}';" | mysql -u root --password=${root_password} 2> /dev/null
# echo "create user '${db_user}'@'localhost' identified by '${user_password}';" | mysql -u root --password=${root_password}
# echo "grant all on '${db_name}'.* to '${db_user}'@'localhost'; flush privileges;" | mysql -u root --password=${root_password}

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash
sudo apt-get install -y nodejs
sudo npm install ghost-cli@latest -g

sudo mkdir -p /var/www/ghost
sudo chown -R ubuntu:ubuntu /var/www/ghost

sudo -u ubuntu cd /var/www/ghost && ghost install \
    --url "http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" \
    --db "mysql" \
    --dbhost "localhost" \
    --dbuser "root" \
    --dbpass "${root_password}" \
    --dbname "${db_name}" \
    --process systemd \
    --no-prompt \
    --start

# sudo chown -R ghost-admin:ghost-admin /var/www/ghost