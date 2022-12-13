#!/bin/bash
#------------------------------------------------
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.sh 
#           [-u ${USER}]                        # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#           [-s ${ServerName}]                  # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]                     # 地图名
#           [-i ${ModIds}]                      # 地图 MOD ID 列表，用英文逗号分隔
#           [-n ${PlayerAmount}]                # 最大玩家数
#           [-p ${ServerPassword}]              # 服务器密码
#           [-a ${AminPassword}]                # 管理员密码
#           [-d ${Difficulty}]                  # 游戏难度
#           [-h ${HarvestAmount}]               # 资源获得倍率
#           [-t ${TamingSpeed}]                 # 驯服恐龙倍率
#           [-r ${ResourcesRespawnPeriod}]      # 资源重生倍率
#           [-g ${CropGrowthSpeed}]             # 作物生长倍率
#           [-x ${XPMultiplier}]                # 经验获得倍率
#------------------------------------------------

USER="1000"
SERVER_NAME="EXP_ARK_Server"
SERVER_MAP="TheIsland"
GAME_MOD_IDS=""
MAX_PLAYERS=10
SERVER_PASSWORD="EXP123456"
ADMIN_PASSWORD="ADMIN654321"
DIFFICULTY_MULT="0.2"
HARVEST_MULT="1.0"
TAMING_MULT="1.0"
RESOURCE_MULT="1.0"
GROWTH_MULT="1.0"
XP_MULT="1.0"

set -- `getopt s:m:i:n:p:a:d:h:t:r:g:x: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -s) SERVER_NAME="$2"
        shift ;;
    -m) SERVER_MAP="$2"
        shift ;;
    -i) MOD_IDS="$2"
        shift ;;
    -n) MAX_PLAYERS="$2"
        shift ;;
    -p) SERVER_PASSWORD="$2"
        shift ;;
    -a) ADMIN_PASSWORD="$2"
        shift ;;
    -d) DIFFICULTY_MULT="$2"
        shift ;;
    -h) HARVEST_MULT="$2"
        shift ;;
    -t) TAMING_MULT="$2"
        shift ;;
    -r) RESOURCE_MULT="$2"
        shift ;;
    -g) GROWTH_MULT="$2"
        shift ;;
    -x) XP_MULT="$2"
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
    docker exec -d -u $USER $CONTAINER_ID sh -c "/home/steam/bin/ark.sh -s ${SERVER_NAME} -m ${SERVER_MAP} -i ${GAME_MOD_IDS} -n ${MAX_PLAYERS} -p ${SERVER_PASSWORD} -a ${ADMIN_PASSWORD} -d ${DIFFICULTY_MULT} -h ${HARVEST_MULT} -t ${TAMING_MULT} -r ${RESOURCE_MULT} -g ${GROWTH_MULT} -x ${XP_MULT}"
    echo "ARK 启动中 (user=$USER) ..."
    echo "稍后请刷新 steam 服务器列表 ..."
fi
