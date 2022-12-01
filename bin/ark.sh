#!/bin/sh
# 启动 ARK 服务（docker 内执行）
#------------------------------------------------
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------


# ARK 服务端安装路径
STEAM_ARK_DIR="/home/steam/games/ark"
# 服务器名称（在 steam 服务器列表上看到的名称）
SERVER_NAME="EXP_ARK_Server"
# 地图名
SERVER_MAP="TheIsland"
# 地图 MOD ID 列表，用英文逗号分隔
GAME_MOD_IDS=""
# 最大玩家数
MAX_PLAYERS=10
# 玩家加入服务器时需要提供的密码
SERVER_PASSWORD="EXP123456"
# 管理员通过 RCON 在线管理服务器的密码
ADMIN_PASSWORD="ADMIN654321"
# 服务端管理工具 RCON 的连接端口
RCON_PORT=32330

set -- `getopt n:m:i:c:p:a "$@"`
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
    -a) ADMIN_PASSWORD="$2"
        shift ;;
  esac
  shift
done


${STEAM_ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer ${SERVER_MAP}?listen\
?SessionName=${SERVER_NAME}\
?MaxPlayers=${MAX_PLAYERS}\
?ServerPassword=${SERVER_PASSWORD}\
?ServerAdminPassword=${ADMIN_PASSWORD}\
?RCONEnabled=True\
?RCONPort=${RCON_PORT}\
?GameModIds=${GAME_MOD_IDS}\
?ServerAutoForceRespawnWildDinosInterval\
?AllowCrateSpawnsOnTopOfStructures=True\
    -ForceAllowCaveFlyers \
    -AutoDestroyStructures \
    -NoBattlEye \
    -crossplay \
    -server\
&
