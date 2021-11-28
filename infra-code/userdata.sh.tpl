#!/usr/bin/env bash

set -o xtrace
set -x

sudo hostnamectl set-hostname ${hostname}
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo docker network create  server
sudo usermod -a -G docker ubuntu 
curl https://raw.githubusercontent.com/FourTimes/run-time-scripts/main/container-creation.sh -o /home/ubuntu/docker.sh
