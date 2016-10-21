#!/bin/bash
if [ -z "$1" ]; then
    echo "server.xml directory required"
    exit
fi

if [ ! -f "$1/server.xml" ]; then
    echo "$1/server.xml not find"
    exit
fi

$JAVA_HOME/bin/keytool -genkey -dname "cn=Author Name, ou=Container, o=UH, l=Honolulu, st=HI, c=US" -alias tomcat -keyalg RSA -storepass $(grep keystorePass $1/server.xml | cut -d\" -f 2) -keypass $(grep keystorePass $1/server.xml | cut -d\" -f 2)
