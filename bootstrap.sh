#!/usr/bin/env bash

#Installing JDK
sudo apt-get update -y
sudo apt install default-jdk -y
#######################################

#Installation of Jenkins	
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y
#######################################

#Installation of Chef-Server
touch /tmp/install-chef-server.sh

echo "#!/bin/bash
apt-get update
apt-get -y install curl

# create staging directories
if [ ! -d /drop ]; then
  mkdir /drop
fi
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# download the Chef server package
if [ ! -f /downloads/chef-server-core_12.17.33_amd64.deb ]; then
  echo \"Downloading the Chef server package...\"
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb
fi

# install Chef server
if [ ! $(which chef-server-ctl) ]; then
  echo \"Installing Chef server...\"
  dpkg -i /downloads/chef-server-core_12.17.33-1_amd64.deb
  chef-server-ctl reconfigure

  echo \"Waiting for services...\"
  until (curl -D - http://localhost:8000/_status) | grep \"200 OK\"; do sleep 15s; done
  while (curl http://localhost:8000/_status) | grep \"fail\"; do sleep 15s; done

  echo \"Creating initial user and organization...\"
  chef-server-ctl user-create chefadmin Chef Admin admin@4thcoffee.com insecurepassword --filename /drop/chefadmin.pem
  chef-server-ctl org-create 4thcoffee "Fourth Coffee, Inc." --association_user chefadmin --filename 4thcoffee-validator.pem
fi

echo \"Your Chef server is ready!" \" >> /tmp/install-chef-server.sh

sudo chmod u+x /tmp/install-chef-server.sh
sudo /tmp/install-chef-server.sh
###########################################################

#Installation of Docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" -y
sudo apt-get update -y
sudo apt-get install docker-ce -y
mkdir app
cd app
echo "FROM ubuntu
	RUN apt update -y
	RUN apt install nodejs -y
	RUN apt install wget -y
	RUN wget http://ipinfo.io/ip -qO - > /hostip
	RUN wget https://raw.githubusercontent.com/cmudevops/ipshow.js/master/ipshow.js" >> Dockerfile
sudo docker build -t ipshow_v1 .
sudo docker run -p 8081:8080 ipshow_v1 node ipshow.js
############################################################

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

