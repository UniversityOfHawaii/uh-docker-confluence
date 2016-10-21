#!/bin/bash
echo "running ssh-keygen to setup ~/.ssh"
# Overwrite if prompted
echo -e 'y\n'|ssh-keygen -t rsa -b 4096 -q -N "" -f ~/.ssh/my_id_rsa

mv *itses_id_rsa.pem ~/.ssh/
#mv em21_itses_id_rsa.pem.pub ~/.ssh/
#mv svn_id_rsa ~/.ssh/
#mv svn_id_rsa.pub ~/.ssh/

#cd ~/.ssh/
#ln -s svn_id_rsa id_rsa
#ln -s svn_id_rsa.pub id_rsa.pub
#cd
