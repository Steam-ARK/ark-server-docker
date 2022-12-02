#!/bin/bash
# 备份 ARK 的存档/配置
#------------------------------------------------
# 示例：bin/backup.sh
#------------------------------------------------

STEAM_DIR="./volumes/steam"
STEAM_GAME_DIR="${STEAM_DIR}/games"
ARK_APP_DIR="${STEAM_GAME_DIR}/ark"
ARK_SAVED_DIR="${ARK_APP_DIR}/ShooterGame/Saved/SavedArks"
ARK_CONFIG_DIR="${ARK_APP_DIR}/ShooterGame/Saved/Config"
ARK_LOGS_DIR="${ARK_APP_DIR}/ShooterGame/Saved/Logs"

BACKUP_DIR="./backup"
VERSION=$(date "+%Y%m%d%H")
LATEST_BACKUP_DIR="${BACKUP_DIR}/${VERSION}"
LATEST_BACKUP_FILE="${LATEST_BACKUP_DIR}.zip"

echo "删除 1 小时内的重复备份 ..."
if [[ -f "${LATEST_BACKUP_FILE}" ]]; then
    rm -f "${LATEST_BACKUP_FILE}"
fi

echo "创建备份目录 ..."
mkdir -p "${LATEST_BACKUP_DIR}"

echo "复制存档/配置文件 ..."
cp -r "${ARK_SAVED_DIR}" "${LATEST_BACKUP_DIR}"
cp -r "${ARK_CONFIG_DIR}" "${LATEST_BACKUP_DIR}"

echo "压缩存档/配置文件 ..."
zip -r "${LATEST_BACKUP_FILE}" "${LATEST_BACKUP_DIR}"

echo "删除临时目录 ..."
if [[ -d "${LATEST_BACKUP_DIR}" ]]; then
    rm -rf "${LATEST_BACKUP_DIR}"
fi

echo "删除 3 天前的存档 ..."
_3_DAY_AGO=`date -d "3 day ago" +%Y%m%d`
rm -f "${BACKUP_DIR}/${_3_DAY_AGO}*"

echo "备份完成: ${LATEST_BACKUP_FILE}"
