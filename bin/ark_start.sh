
CONTAINER_NAME="ARK_SVC"
CONTAINER_ID=`docker ps -aq --filter name="$CONTAINER_NAME"`
docker exec -it $CONTAINER_ID /home/steam/bin/ark.sh
