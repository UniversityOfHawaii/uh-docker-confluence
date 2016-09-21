# $(curl http://169.254.169.254/latest/meta-data/public-ipv4)
echo "s|https://cas.institution.edu/cas|https://$1/cas|g" > cas-web.sed
echo "s|https://confluence.institution.edu/confluence/|https://$2/|g" >> cas-web.sed

sed -f cas-web.sed web.xml.tmpl > web.xml

