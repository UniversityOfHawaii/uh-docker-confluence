#!/bin/bash
./aws-seraph-config.sh
./aws-cas-web.sh
./aws-cfg.sh

/usr/local/atlassian/confluence/bin/start-confluence.sh -fg
