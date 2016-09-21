export AWSIP=$1
export AWSUSER=ec2-user
export DBNAME=$2
export DBUSER=$3
export DBUSERPW=$4
export RDSIP=$5
export CONBUILD=$6
export CONID=$7
export CONLIC=$8

if [ -z "$8" ]; then
    echo "Required arguements not set, read this script."
    exit
fi

#export SSHID="$HOME/.ssh/shared_itses_id_rsa.pem"
export SSHID="$HOME/.ssh/em21_itses_id_rsa.pem"

echo "scp ssh keys and install scripts to $AWSUSER@$AWSIP"
scp -i $SSHID $SSHID $AWSUSER@$AWSIP:

scp -i $SSHID aws-*.sh $AWSUSER@$AWSIP:

echo "run ssh-keys scripts on $AWSUSER@$AWSIP"
ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-01-keys.sh

if [ $AWSUSER = "ec2-user" ]; then
    echo "run ami install scripts on $AWSUSER@$AWSIP"
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-02a-docker-install.sh
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-02b-env-setup.sh
else
    # IDK how to fix the permission problem with the docker list so it has to
    # done manually by logging in and running aws-02a-ubu-setup.sh and then
    # aws-02b-ubu-setup.sh
    echo "run ubuntu install scripts on $AWSUSER@$AWSIP"
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-02a-ubu-setup.sh
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-02b-ubu-setup.sh
fi

scp -i $SSHID Dockerfile $AWSUSER@$AWSIP:

scp -i $SSHID my.cnf $AWSUSER@$AWSIP:
scp -i $SSHID testdatabase.jsp $AWSUSER@$AWSIP:
scp -i $SSHID mysql-connector-java-5.1.39-bin.jar $AWSUSER@$AWSIP:
scp -i $SSHID server.xml $AWSUSER@$AWSIP:server.xml
scp -i $SSHID web-5.8.18.xml $AWSUSER@$AWSIP:web.xml.tmpl
#scp -i $SSHID web-5.10.4.xml $AWSUSER@$AWSIP:web.xml.tmpl
scp -i $SSHID setenv.sh $AWSUSER@$AWSIP:
scp -i $SSHID seraph-config.xml $AWSUSER@$AWSIP:seraph-config.xml.tmpl
echo "Transfering large files, this will take a few minutes..."

# prod
rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/wiki-home.zip $AWSUSER@$AWSIP:
##rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/bwiki_dump_2016_09_01_13_31.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz

# test
#rsync -avz -e "ssh -i \"$SSHID\"" ../DockerConfluenceData/wiki-home.tar.gz $AWSUSER@$AWSIP:
##rsync -avz -e "ssh -i \"$SSHID\"" ../DockerConfluenceData/TestDB-no-autocommit.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz

if [ ! -z "$DBROOTPW" ]
then
# Docker MySQL
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03a-mysql.sh $DBNAME $DBROOTPW $DBUSER $DBUSERPW
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-confluence.sh $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC
else
# RDS
    ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-confluence.sh $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC $RDSIP
fi

# accept keys configured for git using keys correctly would be better
#ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-git.sh

ssh -i $SSHID -l $AWSUSER $AWSIP
