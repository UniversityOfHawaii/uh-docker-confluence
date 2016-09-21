FROM java:8

# Setup useful environment variables
ENV CONF_HOME     /var/local/atlassian/confluence
ENV CONF_INSTALL  /usr/local/atlassian/confluence
ENV CONF_VERSION  5.8.18
#ENV CONF_VERSION  5.10.4

# Install Atlassian Confluence and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 xmlstarlet \
    && apt-get clean \
    && mkdir -p                "${CONF_HOME}" \
#    && chmod -R 700            "${CONF_HOME}" \
#    && chown daemon:daemon     "${CONF_HOME}" \
    && mkdir -p                "${CONF_INSTALL}/conf" \
    && curl -Ls                "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz" | tar -xz --directory "${CONF_INSTALL}" --strip-components=1 --no-same-owner \
#    && chmod -R 700            "${CONF_INSTALL}/conf" \
#    && chmod -R 700            "${CONF_INSTALL}/temp" \
#    && chmod -R 700            "${CONF_INSTALL}/logs" \
#    && chmod -R 700            "${CONF_INSTALL}/work" \
#    && chown -R daemon:daemon  "${CONF_INSTALL}/conf" \
#    && chown -R daemon:daemon  "${CONF_INSTALL}/temp" \
#    && chown -R daemon:daemon  "${CONF_INSTALL}/logs" \
#    && chown -R daemon:daemon  "${CONF_INSTALL}/work" \
    && echo -e                 "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
                               "${CONF_INSTALL}/conf/server.xml"

#RUN ./seraph-config.sh
# linked for testing
#COPY seraph-config.xml  /usr/local/atlassian/confluence/confluence/WEB-INF/classes/seraph-config.xml

# linked for testing
#COPY java-cas-client/cas-client-core/target/cas-client-core-3.4.2-SNAPSHOT.jar /usr/local/atlassian/confluence/confluence/WEB-INF/lib/
#COPY java-cas-client/cas-client-integration-atlassian/target/cas-client-integration-atlassian-3.4.2-SNAPSHOT.jar /usr/local/atlassian/confluence/confluence/WEB-INF/lib/  

COPY mysql-connector-java-5.1.39-bin.jar /usr/local/atlassian/confluence/confluence/WEB-INF/lib/mysql-connector-java-5.1.39-bin.jar

# linked for testing
#COPY web.xml /usr/local/atlassian/confluence/confluence/WEB-INF/web.xml

# SSL
ADD server.xml /usr/local/atlassian/confluence/conf/server.tmpl
# use sed to replace PASSPHRASE in server.tmpl with a randomly generated password then grep the password out when creating the keystore
RUN sed "s|PASSPHRASE|$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)|" /usr/local/atlassian/confluence/conf/server.tmpl > /usr/local/atlassian/confluence/conf/server.xml && $JAVA_HOME/bin/keytool -genkey -dname "cn=Author Name, ou=Container, o=UH, l=Honolulu, st=HI, c=US" -alias tomcat -keyalg RSA -storepass $(grep keystorePass /usr/local/atlassian/confluence/conf/server.xml | cut -d\" -f 2)

#latex
RUN apt-get install -y dvipng && \
  apt-get install -y texlive && \
  apt-get install -y preview-latex-style && \
  apt-get install -y texlive-latex-base && \
  apt-get install -y texlive-extra-utils && \
  apt-get install -y texlive-math-extra && \
  apt-get install -y mimetex

#JVM tuning
COPY setenv.sh /usr/local/atlassian/confluence/bin/setenv.sh
# -Xms6g -Xmx6g 


# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
#USER daemon:daemon

# Expose default HTTP connector port.
EXPOSE 8090 8443

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/local/atlassian/confluence", "/usr/local/atlassian/confluence"]

# Set the default working directory as the installation directory.
WORKDIR ${CONF_INSTALL}

# Run Atlassian JIRA as a foreground process by default.
CMD ["/usr/local/atlassian/confluence/bin/start-confluence.sh", "-fg"]

