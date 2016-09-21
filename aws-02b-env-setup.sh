#sudo yum install -y svn
#sudo yum install -y ant
sudo yum install -y git
sudo yum install -y xmlstarlet
echo 'export PATH=$PATH:/home/ec2-user' >> /home/ec2-user/.bashrc

#maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

git clone https://github.com/apereo/java-cas-client.git
cd java-cas-client
mvn -Dmaven.test.skip=true package

