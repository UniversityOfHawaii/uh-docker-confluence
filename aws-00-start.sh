export AWSIP=$1
export AWSUSER=ec2-user
export MYCAS=$2
export DBIP=$3
export DBNAME=$4
export DBUSER=$5
export DBUSERPW=$6
export CONBUILD=$7
export CONID=$8
export CONLIC=$9

if [ -z "$9" ]; then
    echo "Required arguements not set, read this script."
    exit
fi

export DTS=$(date +%Y%m%d%H%M)
echo "s|mycas|$MYCAS|g" > env.$DTS.sed
echo "s|myip|$AWSIP|g" >> env.$DTS.sed
echo "s|dbip|$DBIP|g" >> env.$DTS.sed
echo "s|dbname|$DBNAME|g" >> env.$DTS.sed
echo "s|dbuserpw|$DBUSERPW|g" >> env.$DTS.sed
echo "s|dbuser|$DBUSER|g" >> env.$DTS.sed
echo "s|conbuild|$CONBUILD|g" >> env.$DTS.sed
echo "s|conid|$CONID|g" >> env.$DTS.sed
echo "s|conlic|$CONLIC|g" >> env.$DTS.sed
sed -f env.$DTS.sed env.tmpl > ~/confluence-env.$DTS.txt
rm env.$DTS.sed

#export SSHID="$HOME/.ssh/shared_itses_id_rsa.pem"
export SSHID="$HOME/.ssh/em21_itses_id_rsa.pem"

echo "scp ssh keys and install scripts to $AWSUSER@$AWSIP"
scp -i $SSHID $SSHID $AWSUSER@$AWSIP:

scp -i $SSHID aws-*.sh $AWSUSER@$AWSIP:
scp -i $SSHID ~/confluence-env.$DTS.txt $AWSUSER@$AWSIP:env.txt
chmod 700 ~/confluence-env.$DTS.txt

echo "run ssh-keys scripts on $AWSUSER@$AWSIP"
ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-01-keys.sh

scp -i $SSHID env.$DTS.sed $AWSUSER@$AWSIP:
 

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
rsync -avz -e "ssh -i \"$SSHID\"" jdk-8u101-linux-x64.tar.gz $AWSUSER@$AWSIP:

# prod
#rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/wiki-home.zip $AWSUSER@$AWSIP:
##rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/bwiki_dump_2016_09_01_13_31.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz

# test
rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/wiki-home.tar.gz $AWSUSER@$AWSIP:
##rsync -avz -e "ssh -i \"$SSHID\"" /Volumes/64G/TestDB-no-autocommit.sql.tar.gz $AWSUSER@$AWSIP:initialize.sql.tar.gz

# Docker MySQL
#ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03a-mysql.sh $DBNAME $DBROOTPW $DBUSER $DBUSERPW
#ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-confluence.sh $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC
# RDS
#ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-confluence.sh $DBNAME $DBUSER $DBUSERPW $CONBUILD $CONID $CONLIC $DBIP

ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03a-confluence.sh

# accept keys configured for git using keys correctly would be better
#ssh -i $SSHID -l $AWSUSER $AWSIP ./aws-03b-git.sh

ssh -i $SSHID -l $AWSUSER $AWSIP
