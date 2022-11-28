#!/bin/bash
# 安装 steam 游戏服务端
#------------------------------------------------
# 命令执行示例：
# bin/install_game.ps1
#------------------------------------------------

Write-Host "此脚本用于在 Docker 中安装 steam 某个游戏的独立服务器 ..."
Write-Host "过程中会开启 steam 终端，请根据提示进行交互 ."

$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if(![String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "请在 steam 终端内依次输入以下命令 :"
    Write-Host '1. [创建游戏目录]: force_install_dir /home/steam/games/${GAME_NAME}'
    Write-Host "   [ARK 示例命令]: force_install_dir /home/steam/games/ark"
    Write-Host "2. [登录匿名用户]: login anonymous"
    Write-Host '3. [安装游戏私服]: app_update ${GAME_ID}'
    Write-Host "   [ARK 示例命令]: app_update 376030"
    Write-Host '4. [更新（可选）]: app_update ${GAME_ID} validate'
    Write-Host "   [ARK 示例命令]: app_update 376030 validate"
    docker exec -it $CONTAINER_ID /home/steam/steamcmd/steamcmd.sh

} else {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."
}

Write-Host "安装脚本终止."
