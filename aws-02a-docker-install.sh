#!/bin/bash
# For AWS ami os sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
# security tools will require times are in synch, set time zone and pray we don't have to NTP
sudo ln -sf /usr/share/zoneinfo/Pacific/Honolulu /etc/localtime
echo 'export PATH=$PATH:/home/ec2-user' >> /home/ec2-user/.bashrc

curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > docker-compose
chmod +x docker-compose
