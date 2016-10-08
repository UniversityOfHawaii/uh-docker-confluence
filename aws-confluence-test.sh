export AWSIP=$1
source ~/confluence-test.env

./aws-00-start.sh $AWSIP $MYCAS $DBIP $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC
