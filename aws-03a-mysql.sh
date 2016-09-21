cd

if [ ! -f initialize.sql ]; then
    tar xzf initialize.sql.tar.gz
    mv TestDB-no-autocommit.sql initialize.sql
fi

#DBNAME=$(head initialize.sql | grep Database | cut -d' ' -f 8)
DBNAME=$1
DBROOTPW=$2
DBUSER=$3
DBUSERPW=$4


echo "docker run -v /etc/localtime:/etc/localtime:ro -v /home/ec2-user/my.cnf:/etc/mysql/my.cnf -v /home/ec2-user/initialize.sql:/docker-entrypoint-initdb.d/initialize.sql -v /home/ec2-user/mysql-logs:/var/log/mysql -p 3306:3306 --name some-mysql -e MYSQL_DATABASE=$DBNAME -e MYSQL_ROOT_PASSWORD=$DBROOTPW -e MYSQL_USER=$DBUSER -e MYSQL_PASSWORD=$DBUSERPW -d mysql:latest"
docker run -v /etc/localtime:/etc/localtime:ro -v /home/ec2-user/my.cnf:/etc/mysql/my.cnf -v /home/ec2-user/initialize.sql:/docker-entrypoint-initdb.d/initialize.sql -v /home/ec2-user/mysql-logs:/var/log/mysql -p 3306:3306 --name some-mysql -e MYSQL_DATABASE=$DBNAME -e MYSQL_ROOT_PASSWORD=$DBROOTPW -e MYSQL_USER=$DBUSER -e MYSQL_PASSWORD=$DBUSERPW -d mysql:latest


