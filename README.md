# uh-docker-confluence

Initial draft of scripts and Docker file for dockerizing confluence.

These scripts create a "development" version of a dockerized confluence.  Where the various configuration files and such are linked to via docker run vs put into the docker image with COPY.

Expect to have to modify aws-00-start.sh, aws-03b-confluence, and if not using AWS RDS aws-03a-mysql.sh.

aws-00-start.sh with all the proper arguments passed in does all the configuration and building of the docker instance.  The instance is not started automatically (see aws-docker-start.sh).

web.xml and seraph-config.xml need to have the IP address of the server.  Intial aws- scripts set this, but if the AWS instance is restarted and doesn't have an elastic IP, the IP will change and needs to be updated in web.xml and seraph-config.xml

db2rds- scripts to assist setting up an AWS RDS MySQL instance.  NOTE Custom Parameter Group is required (confluence-mysql5-6).

Oracle JDK (jdk-8u101-linux-x64.tar.gz), Database sql files, wiki-home are not supplied here.


NOTES:
The expierences shared with us about dockerizing confluence advise that performance is unacceptable if the database is not near confluence.  

By design, both DB solutions presented here prevent external access to the DB.  With the docker mysql instance this is accomplished by simply not opening a port externaly.  With AWS Relational Database Service (RDS), this is done by creating a Virtual Private Cloud (VPC).

aws-03a-mysql.sh is an example of setting-up a mysql docker instance for confluence initialized with data.

Using AWS RDS (MySQL) requires using Amazon's Parameter Groups vs. a my.cnf.  Which is then populated via mysql and a script run from a machine within the VPC.  And executing ALTER DATABASE [database_name] CHARACTER SET utf8 COLLATE utf8_bin; (you can hold off running this sql command until you get bad collate character from confluence).

If as part of the dockerizing, [if] you upgrade the version of Confluence you'll need to change the build number in the wiki-home/confluence.cfg.xml a couple times.  (On the first start, the build number must be that of the orginal version (it's reported in the error.) On the second start, the number will need to be change to the upgraded version (also reported in the error message)).

Setup SMTP using AWS Simple Email Service (SES). 

IP address, if you are not using Elastic IP address the IP address of the server will change every restart, requiring the IP addresses in the CAS urls be updated (which means they cannot be in the image, but must be linked to) in web.xml and seraph-config.xml

Jira integration - we'll setup a dockerized Jira instance to debug the problems with authentication.

Things to look into:
backup path mapped /var/local/atlassian/confluence/backups
attachement storage /var/local/atlassian/confluence/attachments

