#!/bin/bash
# 启动 ARK 服务
#------------------------------------------------

ark_dir="/home/steam/games/ark"
session_name="ARK_Docker_Server_By_EXP"
svc_map="TheIsland"
map_group="ARK_Maps_By_EXP"
svc_pwd="svc010203"
admin_pwd="admin040506"
max_players=20
update_on_start="false"
backup_on_stop="false"
pre_update_backup="true"
warn_on_stop="true"
enable_crossplay="false"
disable_battleye="false"
game_mod_ids=""


STEAM_ARK_DIR=$ark_dir
# 服务端端口
GAME_CLIENT_PORT=7777
# 暴露给玩家连接主机的端口（总是 GAME_CLIENT_PORT + 1）
UDP_SOCKET_PORT=7778
# 暴露给 Steam 用于搜索服务时的端口
SERVER_LIST_PORT=27015
# 服务端命令行管理工具 RCON 的连接端口
RCON_PORT=27020
# 服务器名称（在 steam 服务器上看到的）
SESSION_NAME=$session_name
# 在 steam 服务器上的组内名称（唯一即可）
SESSION_GROUP="GN_${SESSION_NAME}"
# 地图名
SERVER_MAP=$svc_map
# 这个服务器上的地图组名称（当有多个图希望互通时，就把它们的地图组设置为一样）
MAP_GROUP=$map_group
SERVER_PASSWORD=$svc_pwd
ADMIN_PASSWORD=$admin_pwd
MAX_PLAYERS=$max_players
UPDATE_ON_START=$update_on_start
BACKUP_ON_STOP=$backup_on_stop
PRE_UPDATE_BACKUP=$pre_update_backup
WARN_ON_STOP=$warn_on_stop
ENABLE_CROSSPLAY=$enable_crossplay
DISABLE_BATTLEYE=$disable_battleye
GAME_MOD_IDS=$game_mod_ids
# 服务器上传缓存的位置玩家上传到方舟的角色和物品的缓存）
SAVE_DIR="/home/steam/saved/ark"


${STEAM_ARK_DIR}/ShooterGame/Binaries/Linux/ShooterGameServer ${SERVER_MAP}?\
listen?Port=${GAME_CLIENT_PORT}?\
QueryPort=${SERVER_LIST_PORT}?\
AltSaveDirectoryName="${SESSION_GROUP}"?\
SessionName="${SESSION_NAME}"?\
MaxPlayers=${MAX_PLAYERS}?\
ServerAutoForceRespawnWildDinosInterval=259200?\
AllowCrateSpawnsOnTopOfStructures=True \
    -ForceAllowCaveFlyers \
    -AutoDestroyStructures \
    -clusterid="${MAP_GROUP}" \
    -ClusterDirOverride="${SAVE_DIR}" \
    -NoBattlEye \
    -crossplay \
    -nosteamclient \
    -game \
    -server \
    -log
