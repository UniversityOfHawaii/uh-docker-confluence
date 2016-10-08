#!/bin/bash
if [ -f env.txt ]; then
    source env.txt
else
    DBNAME=$1
    DBUSER=$2
    DBUSERPW=$3
    CONBUILD=$4
    CONID=$5
    CONLIC=$6
    DBIP=$7
    MYIP=$8
fi

if [ -z "MYIP" ]; then
    MYIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
fi

# if there is no DBIP address assume docker mysql on same IP
if [ -z "$DBIP" ]
then
    DBIP="$MYIP"
    echo "Extracting wiki-home this will take a few moments..."
    tar xzf wiki-home.tar.gz
    ./aws-seraph-config.sh cas-test.its.hawaii.edu $MYIP
    ./aws-cas-web.sh cas-test.its.hawaii.edu $MYIP 
else # RDS
	# prod
    echo "PRODUCTION Extracting wiki-home this will take a few moments..."
    # prod wiki-home
#    unzip wiki-home.zip
    # test cas for production testing
#    ./aws-seraph-config.sh cas-test.its.hawaii.edu $MYIP
#    ./aws-cas-web.sh cas-test.its.hawaii.edu $MYIP 
    # prod cas
#    ./aws-seraph-config.sh authn.hawaii.edu $MYIP
#    ./aws-cas-web.sh authn.hawaii.edu $MYIP 

	# test on RDS
    echo "TEST Extracting wiki-home this will take a few moments..."
    tar xzf wiki-home.tar.gz
    ./aws-seraph-config.sh cas-test.its.hawaii.edu $MYIP
    ./aws-cas-web.sh cas-test.its.hawaii.edu $MYIP 

fi

# remove old log to avoid confusion
rm wiki-home/logs/atlassian-confluence.log
# re index confluence to avoid various errors
rm -rf wiki-home/index
rm -rf wiki-home/journal

mkdir -p tomcat-logs

./aws-cfg.sh $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC $DBIP 

docker build .
#docker run -v /etc/localtime:/etc/localtime:ro -v /home/ec2-user/wiki-home:/var/local/atlassian/confluence -v /home/ec2-user/tomcat-logs:/usr/local/atlassian/confluence/logs -p 8080:8080 -p 8090:8090 -p 8443:8443 5521144fab9f /usr/local/atlassian/confluence/bin/start-confluence.sh -fg

