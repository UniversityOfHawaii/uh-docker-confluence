sudo yum update -y
sudo yum install -y mysql
tar xvfz initialize.sql.tar.gz
echo "TODO execute ALTER DATABASE [database_name] CHARACTER SET utf8 COLLATE utf8_bin;"
echo "mysql -h <host_name> -P 3306 -u <db_master_user> -p<password> dbname < sqlfile"
# mysql -h <host_name> -P 3306 -u <db_master_user> -p<password> dbname < sqlfile
#mysql -h $1 -P 3306 -u $2 -p$3 $4 < $5
