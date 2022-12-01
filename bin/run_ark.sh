#!/bin/sh
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.sh 
#           [-u ${USER}]            # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#           [-n ${ServerName}]      # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]         # 地图名
#           [-i ${ModIds}]          # 地图 MOD ID 列表，用英文逗号分隔
#           [-c ${PlayerAmount}]    # 最大玩家数
#           [-p ${ServerPassword}]  # 服务器密码
#           [-a ${AminPassword}]    # 管理员密码
#------------------------------------------------

USER="1000"
SERVER_NAME="EXP_ARK_Server"
SERVER_MAP="TheIsland"
GAME_MOD_IDS=""
MAX_PLAYERS=10
SERVER_PASSWORD="EXP123456"
ADMIN_PASSWORD="ADMIN654321"

set -- `getopt n:m:i:c:p:a:u "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -u) USER="$2"
        shift ;;
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
    -a) ADMIN_PASSWORD="$2"
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
    docker exec -d -u $USER $CONTAINER_ID sh -c "/home/steam/bin/ark.sh -n ${SERVER_NAME} -m ${SERVER_MAP} -i ${GAME_MOD_IDS} -c ${MAX_PLAYERS} -p ${SERVER_PASSWORD} -a ${ADMIN_PASSWORD}"
    echo "ARK 启动中 (user=$USER) ..."
    echo "稍后请刷新 steam 服务器列表 ..."
fi
