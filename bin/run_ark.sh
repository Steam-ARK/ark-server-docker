#!/bin/sh
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.sh 
#           [-n ${ServerName}]      # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]         # 地图名
#           [-i ${ModIds}]          # 地图 MOD ID 列表，用英文逗号分隔
#           [-c ${PlayerAmount}]    # 最大玩家数
#           [-p ${ServerPassword}]  # 服务器密码
#------------------------------------------------

SERVER_NAME="EXP_ARK_Server"
SERVER_MAP="TheIsland"
GAME_MOD_IDS=""
MAX_PLAYERS=10
SERVER_PASSWORD="EXP123456"

set -- `getopt n:m:i:c:p "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -n) SERVER_NAME="$2"
        shift ;;
    -m) SERVER_MAP="$2"
        shift ;;
    -i) GAME_MOD_IDS="$2"
        shift ;;
    -c) MAX_PLAYERS="$2"
        shift ;;
    -p) SERVER_PASSWORD="$2"
        shift ;;
  esac
  shift
done


CONTAINER_NAME="ARK_SVC"
CONTAINER_ID=`docker ps -aq --filter name="$CONTAINER_NAME"`
if [[ "${CONTAINER_ID}x" = "x" ]] ; then
    echo "[$CONTAINER_NAME] 容器没有运行 ..."
else
    docker exec -it $CONTAINER_ID sh -c "/home/steam/bin/ark.sh -n ${SERVER_NAME} -m ${SERVER_MAP} -i ${GAME_MOD_IDS} -c ${MAX_PLAYERS} -p ${SERVER_PASSWORD}"
    echo "ARK 启动中 ..."
    echo "稍后请刷新 steam 服务器列表 ..."
fi
