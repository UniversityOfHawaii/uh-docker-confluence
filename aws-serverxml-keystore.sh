#!/bin/bash
if [ -f env.txt ]; then
    source env.txt
else 
    KSPP=$2
    KSPW=$3
fi
KSDNAME="cn=Author Name, ou=Container, o=UH, l=Honolulu, st=HI, c=US"
KSALIAS="tomcat"
KSALG="RSA"

if [ -z "$1" ]; then
    echo "server.xml directory required"
    exit
fi

if [ ! -f "$1/server.xml" ]; then
    echo "$1/server.xml not find"
    exit
fi

if [ -z "$KSPP" ]; then
    echo "no passphrase given, using passphrase from $1/server.xml"
$JAVA_HOME/bin/keytool -genkey -dname "$KSDNAME" -alias $KSALIAS -keyalg $KSALG -storepass $(grep keystorePass $1/server.xml | cut -d\" -f 2) -keypass $(grep keystorePass $1/server.xml | cut -d\" -f 2)
    exit
fi

if [ -z "$KSPW" ]; then
$JAVA_HOME/bin/keytool -genkey -dname "$KSDNAME" -alias $KSALIAS -keyalg $KSALG -storepass $KSPP -keypass $KSPP
    exit
fi
#KSPW not implemented yet
#$JAVA_HOME/bin/keytool -genkey -dname "$KSDNAME" -alias $KSALIAS -keyalg $KSALG -storepass $KSPP -keypass $KSPW