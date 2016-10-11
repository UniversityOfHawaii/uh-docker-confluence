#!/bin/bash
if [ -f env.txt ]; then
    if [ -f web.xml ]; then
        echo "web.xml exists, not templating web.xml"
        exit
    fi
    source env.txt
else
    if [ -z "$1" ]; then
        echo "CAS required"
        exit
    fi

    MYCAS="$1"
    MYIP="$2"
fi	

if [ -z "$MYIP" ]; then
    MYIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
fi

echo "s|https://cas.institution.edu/cas|https://$MYCAS/cas|g" > web.sed
echo "s|https://confluence.institution.edu/confluence/|https://$MYIP/|g" >> web.sed

sed -f web.sed web.xml.tmpl > web.xml

# copy web.xml to correct place if inside container
if [ -d /usr/local/atlassian/confluence/confluence/WEB-INF/ ]; then
    cp web.xml /usr/local/atlassian/confluence/confluence/WEB-INF/
fi
