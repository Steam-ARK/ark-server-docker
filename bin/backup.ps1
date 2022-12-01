#!/bin/sh
# 备份 ARK 的存档/配置
#------------------------------------------------
# 示例：bin/backup.ps1
#------------------------------------------------

$STEAM_DIR = "./volumes/steam"
$STEAM_GAME_DIR = "${STEAM_DIR}/games"
$ARK_APP_DIR = "${STEAM_GAME_DIR}/ark"
$ARK_SAVED_DIR = "${ARK_APP_DIR}/ShooterGame/Saved/SavedArks"
$ARK_CONFIG_DIR = "${ARK_APP_DIR}/ShooterGame/Saved/Config"

$BACKUP_DIR = "./backup"
$VERSION = Get-Date -format "yyyyMMddHH"
$LATEST_BACKUP_DIR = "${BACKUP_DIR}/${VERSION}"
$LATEST_BACKUP_FILE = "${LATEST_BACKUP_DIR}.zip"

Write-Host "删除 1 小时内的重复备份 ..."
if (Test-Path ${LATEST_BACKUP_FILE}) {
    Remove-Item "${LATEST_BACKUP_FILE}" -Recurse -Force
}

Write-Host "创建备份目录 ..."
mkdir "${LATEST_BACKUP_DIR}"

Write-Host "复制存档/配置文件 ..."
Copy-Item "${ARK_SAVED_DIR}" -Destination "${LATEST_BACKUP_DIR}" -Recurse -Force
Copy-Item "${ARK_CONFIG_DIR}" -Destination "${LATEST_BACKUP_DIR}" -Recurse -Force

Write-Host "压缩存档/配置文件 ..."
Compress-Archive -Path "${LATEST_BACKUP_DIR}" -DestinationPath "${LATEST_BACKUP_FILE}"

Write-Host "删除临时目录 ..."
if (Test-Path ${LATEST_BACKUP_DIR}) {
    Remove-Item "${LATEST_BACKUP_DIR}" -Recurse -Force
}

Write-Host "备份完成: ${LATEST_BACKUP_FILE}"
