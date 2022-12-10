#!/bin/bash
#------------------------------------------------
# 进入容器的交互终端
# bin/terminal.sh
#           [-u ${USER}]            # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#------------------------------------------------

USER="1000"

set -- `getopt u: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -u) USER="$2"
        shift ;;
  esac
  shift
done

if [[ "${USER}x" = "rootx" ]] || [[ "${USER}x" = "0x" ]] ; then
    USER="root"
else
    USER="1000"
fi



CONTAINER_NAME="ARK_SVC"
CONTAINER_ID=`docker ps -aq --filter name="$CONTAINER_NAME"`
if [[ "${CONTAINER_ID}x" = "x" ]] ; then
    echo "[$CONTAINER_NAME] 容器没有运行 ..."
else
    docker exec -it -u $USER $CONTAINER_ID bash
fi
