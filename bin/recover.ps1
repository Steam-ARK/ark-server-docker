# PowerShell
#------------------------------------------------
# 恢复 ARK 的存档/配置
# bin/recover.ps1 -v ${yyyyMMddHH}
#------------------------------------------------

param([string]$v="")

$STEAM_DIR = "./volumes/steam"
$STEAM_GAME_DIR = "${STEAM_DIR}/games"
$ARK_APP_DIR = "${STEAM_GAME_DIR}/ark"
$ARK_SAVED_DIR = "${ARK_APP_DIR}/ShooterGame/Saved"

$BACKUP_DIR = "./backup"
$VERSION = $v
if([String]::IsNullOrEmpty(${VERSION})) {
    Write-Host "请输入恢复时间点, 格式为: bin/recover.sh yyyyMMddHH"
    Write-Host "可恢复的存档文件见 ${BACKUP_DIR} 目录"
    Exit
}


Write-Host "解压存档文件 ${RECOVER_FILE} ..."
$RECOVER_FILE = "${BACKUP_DIR}/${VERSION}.zip"
Expand-Archive -Path ${RECOVER_FILE} -DestinationPath ${BACKUP_DIR}


Write-Host "恢复存档 ${VERSION} ..."
$RECOVER_DIR = "${BACKUP_DIR}/${VERSION}"
Remove-Item ${ARK_SAVED_DIR} -Recurse -Force
New-Item -Path ${ARK_SAVED_DIR} -ItemType Directory
Move-Item ${RECOVER_DIR}/* ${ARK_SAVED_DIR}/


Write-Host "删除缓存 ..."
$CACHE_DIR = "${BACKUP_DIR}/${VERSION}"
Remove-Item "${CACHE_DIR}" -Recurse -Force


Write-Host "恢复完成"
