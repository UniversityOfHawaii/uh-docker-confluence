# uh-docker-confluence

Initial draft of scripts and Docker file for dockerizing confluence.

These scripts create a "development" version of a dockerized confluence.  Where the various configuration files and such are linked to via docker run vs put into the docker image with COPY.

Expect to have to modify aws-00-start.sh, aws-03b-confluence, and if not using AWS RDS aws-03a-mysql.sh.

aws-00-start.sh with all the proper arguments passed in does all the configuration and building of the docker instance.  The instance is not started automatically (see aws-docker-start.sh).

db2rds- scripts to assist setting up an AWS RDS MySQL instance.  NOTE Custom Parameter Group is required (confluence-mysql5-6).

Database sql files, wiki-home are not supplied here.
