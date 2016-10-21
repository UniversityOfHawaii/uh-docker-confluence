#!/bin/bash
if [ -f wiki-home.tar.gz ]
then
    echo "TEST Extracting wiki-home this will take a few moments..."
    tar xzf wiki-home.tar.gz
else 
    echo "PRODUCTION Extracting wiki-home this will take a few moments..."
    unzip wiki-home.zip
fi

# remove old log to avoid confusion
rm wiki-home/logs/atlassian-confluence.log
# re index confluence to avoid various errors
rm -rf wiki-home/index
rm -rf wiki-home/journal

mkdir -p tomcat-logs

#docker build .
./docker-compose build
