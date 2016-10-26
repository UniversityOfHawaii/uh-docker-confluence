#!/bin/bash
if [ -f env.txt ]; then
    source env.txt
else 
    KSPP=$2
fi

if [ -z "$1" ]; then
    echo "server.xml directory required"
    exit
fi

if [ ! -f "$1/server.tmpl" ]; then
    echo "$1/server.tmpl not find"
    exit
fi

if [ -z "$KSPP" ]; then
    echo "no passphrase given, using randomly generated passphrase"
#when run in container:
#head: /usr/local/atlassian/confluence/conf: invalid number of bytes
#sed "s|PASSPHRASE|$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)|" $1/server.tmpl > $1/server.xml
    sed "s|PASSPHRASE|$(openssl rand -base64 32)|" $1/server.tmpl > $1/server.xml
    exit
fi

sed "s|PASSPHRASE|$KSPP|" $1/server.tmpl > $1/server.xml
