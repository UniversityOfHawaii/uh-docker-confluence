if [ -z "$1" ]; then
    echo "DB Name required"
    exit
fi
if [ -z "$2" ]; then
    echo "DB User required"
    exit
fi
if [ -z "$3" ]; then
    echo "DB User password required"
    exit
fi
if [ -z "$4" ]; then
    echo "Confluence build number required"
    exit
fi
if [ -z "$5" ]; then
    echo "Confluence servier id required"
    exit
fi
if [ -z "$6" ]; then
    echo "Confluence license required"
    exit
fi

DBNAME=$1
DBUSER=$2
DBUSERPW=$3
CONBUILD=$4
CONID=$5
CONLIC=$6

MYIP=$7
if [ -z "$7" ]; then
    MYIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
fi

CFGFILE=wiki-home/confluence.cfg.xml
if [ ! -f $CFGFILE.bak ]; then
    cp $CFGFILE $CFGFILE.bak
fi

echo "Configuring $CFGFILE with $DBNAME $DBUSER $DBUSERPW $MYIP"

xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='hibernate.connection.password']" --value $DBUSERPW $CFGFILE
xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='confluence.webapp.context.path']" --value / $CFGFILE
xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='hibernate.connection.url']" --value "jdbc:mysql://$MYIP/$DBNAME?autoReconnect=true&useUnicode=true&characterEncoding=utf8&useSSL=false" $CFGFILE
xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='hibernate.connection.username']" --value $DBUSER $CFGFILE

xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='confluence.setup.server.id']" --value $CONID $CFGFILE
xmlstarlet edit --inplace --update "/confluence-configuration/properties/property[@name='atlassian.license.message']" --value $CONLIC $CFGFILE
xmlstarlet edit --inplace --update "/confluence-configuration/buildNumber" --value $CONBUILD $CFGFILE

