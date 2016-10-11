#docker run  -v /etc/localtime:/etc/localtime:ro -v /home/ec2-user/wiki-home:/var/local/atlassian/confluence -v /home/ec2-user/tomcat-logs:/usr/local/atlassian/confluence/logs -p 80:8090 -p 443:8443 $1 /usr/local/atlassian/confluence/bin/start-confluence.sh -fg

# linked for testing
docker run  -v /home/ec2-user/java-cas-client/cas-client-core/target/cas-client-core-3.4.2-SNAPSHOT.jar:/usr/local/atlassian/confluence/confluence/WEB-INF/lib/cas-client-core-3.4.2-SNAPSHOT.jar -v /home/ec2-user/java-cas-client/cas-client-integration-atlassian/target/cas-client-integration-atlassian-3.4.2-SNAPSHOT.jar:/usr/local/atlassian/confluence/confluence/WEB-INF/lib/cas-client-integration-atlassian-3.4.2-SNAPSHOT.jar -v /home/ec2-user/web.xml:/usr/local/atlassian/confluence/confluence/WEB-INF/web.xml -v /etc/localtime:/etc/localtime:ro -v /home/ec2-user/wiki-home:/var/local/atlassian/confluence -v /home/ec2-user/tomcat-logs:/usr/local/atlassian/confluence/logs -v /home/ec2-user/seraph-config.xml:/usr/local/atlassian/confluence/confluence/WEB-INF/classes/seraph-config.xml -p 80:8090 -p 443:8443 $1 /usr/local/atlassian/confluence/bin/start-confluence.sh -fg