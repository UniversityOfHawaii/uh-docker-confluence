export AWSIP=$1
export AWSUSER=$2
#export SSHID="$HOME/.ssh/shared_itses_id_rsa.pem"
export SSHID="$HOME/.ssh/em21_itses_id_rsa.pem"
if [ -z "$2" ]
then
    AWSUSER="ec2-user"
fi

echo "scp ssh keys and install scripts to $AWSUSER@$AWSIP"
scp -i $SSHID $SSHID $AWSUSER@$AWSIP:

scp -i $SSHID db2rds-*.sh $AWSUSER@$AWSIP:

echo "run ssh-keys scripts on $AWSUSER@$AWSIP"
scp -i $SSHID aws-01-keys.sh $AWSUSER@$AWSIP:
ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-01-install.sh

echo "Transfering large files, this will take a few minutes..."

# prod
#rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/bwiki_dump_2016_09_01_13_31.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz
# test
rsync -avz -e "ssh -i \"$SSHID\"" ../DockerConfluenceData/TestDB-no-autocommit.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz

ssh -i $SSHID -l $AWSUSER $AWSIP ./db2rds-01-install.sh

#ssh -i $SSHID -l $AWSUSER $AWSIP
# mysql -h <host_name> -P 3306 -u <db_master_user> -p<password> dbname


