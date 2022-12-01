#!/bin/sh
# 备份 ARK 的存档、配置
#------------------------------------------------
# 示例：bin/backup.ps1
#------------------------------------------------

$STEAM_DIR = "./volumes/steam"
$STEAM_GAME_DIR = "${STEAM_DIR}/games"
$ARK_APP_DIR = "${STEAM_GAME_DIR}/ark"
$ARK_SAVED_DIR = "${ARK_APP_DIR}/ShooterGame/Saved/SavedArks"
$ARK_CONFIG_DIR = "${ARK_APP_DIR}/ShooterGame/Saved/Config"

$BACKUP_DIR = "./backup"
$VERSION = Get-Date -format "yyMMddHH"
$LATEST_BACKUP_DIR = "${BACKUP_DIR}/${VERSION}"

if (Test-Path ${LATEST_BACKUP_DIR}) {
    Remove-Item ${LATEST_BACKUP_DIR} -Recurse -Force
}
mkdir ${LATEST_BACKUP_DIR}

Copy-Item "${ARK_SAVED_DIR}/*" -Destination ${LATEST_BACKUP_DIR}
Copy-Item "${ARK_CONFIG_DIR}/*" -Destination ${LATEST_BACKUP_DIR}