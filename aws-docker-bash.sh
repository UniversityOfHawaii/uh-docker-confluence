INSTANCE=$(docker ps | grep atlassian | rev | cut -d' ' -f1 | rev)
docker exec -it $INSTANCE /bin/bash 