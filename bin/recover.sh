#!/bin/bash
#------------------------------------------------
# 恢复 ARK 的存档/配置
# bin/recover.sh -v ${yyyyMMddHH}
#------------------------------------------------

STEAM_DIR="./volumes/steam"
STEAM_GAME_DIR="${STEAM_DIR}/games"
ARK_APP_DIR="${STEAM_GAME_DIR}/ark"
ARK_SAVED_DIR="${ARK_APP_DIR}/ShooterGame/Saved"

BACKUP_DIR="./backup"
VERSION=$2
if [[ "x${VERSION}" = "x" ]]; then
    echo "请输入恢复时间点, 格式为: bin/recover.sh yyyyMMddHH"
    echo "可恢复的存档文件见 ${BACKUP_DIR} 目录"
    exit 1
fi


echo "解压存档文件 ${RECOVER_FILE} ..."
RECOVER_FILE="${BACKUP_DIR}/${VERSION}.zip"
unzip ${RECOVER_FILE}


echo "恢复存档 ${VERSION} ..."
RECOVER_DIR="${BACKUP_DIR}/${VERSION}"
rm -rf ${ARK_SAVED_DIR}
mkdir -p ${ARK_SAVED_DIR}
mv ${RECOVER_DIR}/* ${ARK_SAVED_DIR}/


echo "删除缓存 ..."
CACHE_DIR="${BACKUP_DIR}/${VERSION}"
rm -rf "${CACHE_DIR}"


echo "恢复完成"
