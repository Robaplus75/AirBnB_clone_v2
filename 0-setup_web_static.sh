#!/usr/bin/env bash
# for setting up the servers for deployment

apt-get -y update
apt-get -y upgrade
apt-get -y install nginx
mkdir -p /data/web_static/releases/test /data/web_static/shared
echo "<h1> hollow world!!" | tee /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current
chown -hR ubuntu:ubuntu /data/
sed -i '38i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default
service nginx start
