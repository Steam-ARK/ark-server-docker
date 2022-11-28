#!/bin/bash
# 运行 docker 服务
#------------------------------------------------
# 命令执行示例：
# bin/run.ps1 -svc_pwd "${SPWD}" -admin_pwd "${APWD}" -max_players "${AMOUNT}" -svc_map "${MAP_NAME}" -game_mod_ids "{ID1},{ID2},...,{IDn}"
#------------------------------------------------

session_name="ARK_Docker_Server_By_EXP"
svc_map="TheIsland"
group_svc_map="ARK_Maps_By_EXP"
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


set -- `getopt svc_pwd:p:i:g: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -svc_pwd) session_name="$2"
        shift ;;
    -p) PASSWORD="$2"
        shift ;;
    -i) U_ID="$2"
        shift ;;
    -g) G_ID="$2"
        shift ;;
  esac
  shift
done


echo "---------- Input Params ----------"
echo "SESSION_NAME = ${session_name}"
echo "SERVER_MAP = ${svc_map}"
echo "GROUP_SERVER_MAP = ${group_svc_map}"
echo "SERVER_PASSWORD = ${svc_pwd}"
echo "ADMIN_PASSWORD = ${admin_pwd}"
echo "MAX_PLAYERS = ${max_players}"
echo "UPDATE_ON_START = ${update_on_start}"
echo "BACKUP_ON_STOP = ${backup_on_stop}"
echo "PRE_UPDATE_BACKUP = ${pre_update_backup}"
echo "WARN_ON_STOP = ${warn_on_stop}"
echo "ENABLE_CROSSPLAY = ${enable_crossplay}"
echo "DISABLE_BATTLEYE = ${disable_battleye}"
echo "GAME_MOD_IDS = ${game_mod_ids}"
echo "----------------------------------"


SESSION_NAME=${session_name} \
SERVER_MAP=${svc_map} \
GROUP_SERVER_MAP=${group_svc_map} \
SERVER_PASSWORD=${svc_pwd} \
ADMIN_PASSWORD=${admin_pwd}; 
MAX_PLAYERS=${max_players} \
UPDATE_ON_START=${update_on_start} \
BACKUP_ON_STOP=${backup_on_stop} \
PRE_UPDATE_BACKUP=${pre_update_backup} \
WARN_ON_STOP=${warn_on_stop} \
ENABLE_CROSSPLAY=${enable_crossplay} \
DISABLE_BATTLEYE=${disable_battleye} \
GAME_MOD_IDS=${game_mod_ids} \
docker-compose up -d
echo "Server is Running ..."
