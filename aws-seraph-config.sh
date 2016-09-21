if [ -z "$1" ]; then
	echo 'First parameter must be cas server'
    exit
fi
MYCAS=$1

if [ -z "$2" ]; then
    MYIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
else
	MYIP=$2
fi

echo "s|@casBaseUrl@|https://$MYCAS/cas|g" > seraph-config.sed
echo "s|\${originalurl}|https://$MYIP/dashboard.action|g" >> seraph-config.sed
echo "s|<param-value>/login.action?\S*</param-value>|<param-value>https://$MYCAS/cas/login?service=https://$MYIP/dashboard.action</param-value>|g" >> seraph-config.sed
echo "s|<param-value>/login.action</param-value>|<param-value>https://$MYCAS/cas/login?service=https://$MYIP/dashboard.action</param-value>|g" >> seraph-config.sed
echo "s|com.atlassian.confluence.user.ConfluenceAuthenticator|org.jasig.cas.client.integration.atlassian.ConfluenceCasAuthenticator|g" >> seraph-config.sed
sed -f seraph-config.sed seraph-config.xml.tmpl > seraph-config.xml
