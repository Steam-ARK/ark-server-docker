#!/bin/sh
#------------------------------------------------
# 启动 ARK 服务（docker 内执行）
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.sh 
#           [-s ${ServerName}]                  # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]                     # 地图名
#           [-i ${ModIds}]                      # 地图 MOD ID 列表，用英文逗号分隔
#           [-c ${PlayerAmount}]                # 最大玩家数
#           [-p ${ServerPassword}]              # 服务器密码
#           [-a ${AminPassword}]                # 管理员密码
#           [-d ${Difficulty}]                  # 游戏难度
#           [-h ${HarvestAmount}]               # 资源获得倍率
#           [-t ${TamingSpeed}]                 # 驯服恐龙倍率
#           [-r ${ResourcesRespawnPeriod}]      # 资源重生倍率
#           [-g ${CropGrowthSpeed}]             # 作物生长倍率
#           [-x ${XPMultiplier}]                # 经验获得倍率
#------------------------------------------------

# ARK 服务端安装路径
STEAM_ARK_DIR="/home/steam/games/ark"
# 服务器名称（在 steam 服务器列表上看到的名称）
SERVER_NAME="EXP_ARK_Server"
# 地图名
SERVER_MAP="TheIsland"
# 创意工坊的 MOD ID 列表，用英文逗号分隔
MOD_IDS=""
# 最大玩家数
MAX_PLAYERS=10
# 玩家加入服务器时需要提供的密码
SERVER_PASSWORD="EXP123456"
# 管理员通过 RCON 在线管理服务器的密码
ADMIN_PASSWORD="ADMIN654321"
# 服务端管理工具 RCON 的连接端口
RCON_PORT=32330
# 游戏难度
DIFFICULTY_MULT="0.2"
# 资源获得倍率
HARVEST_MULT="1.0"
# 驯服恐龙倍率
TAMING_MULT="1.0"
# 资源重生倍率
RESOURCE_MULT="1.0"
# 作物生长倍率
GROWTH_MULT="1.0"
# 经验获得倍率
XP_MULT="1.0"


set -- `getopt s:m:i:c:p:a:d:h:t:r:g:x: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -s) SERVER_NAME="$2"
        shift ;;
    -m) SERVER_MAP="$2"
        shift ;;
    -i) MOD_IDS="$2"
        shift ;;
    -c) MAX_PLAYERS="$2"
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


nohup ${STEAM_ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer ${SERVER_MAP}?listen\
?SessionName=${SERVER_NAME}\
?MaxPlayers=${MAX_PLAYERS}\
?ServerPassword=${SERVER_PASSWORD}\
?ServerAdminPassword=${ADMIN_PASSWORD}\
?serverPVE=True\
?RCONEnabled=True\
?RCONPort=${RCON_PORT}\
?GameModIds=${MOD_IDS}\
?ActiveMods=${MOD_IDS}\
?ShowFloatingDamageText=True\
?DifficultyOffset=${DIFFICULTY_MULT}\
?HarvestAmountMultiplier=${HARVEST_MULT}\
?TamingSpeedMultiplier=${TAMING_MULT}\
?ResourcesRespawnPeriodMultiplier=${RESOURCE_MULT}\
?CropGrowthSpeedMultiplier=${GROWTH_MULT}\
?XPMultiplier=${XP_MULT}\
?ServerAutoForceRespawnWildDinosInterval\
    -AutoDestroyStructures \
    -NoBattlEye \
    -crossplay \
    -server \
    -servergamelog \
    -log \
&
