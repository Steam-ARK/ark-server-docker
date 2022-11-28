#!/bin/bash
# 安装 steam 游戏服务端
#------------------------------------------------
# 命令执行示例：
# bin/install_game.sh
#------------------------------------------------

echo "此脚本用于在 Docker 中安装 steam 某个游戏的独立服务器 ..."
echo "过程中会开启 steam 终端，请根据提示进行交互 ."

CONTAINER_NAME="ARK_SVC"
CONTAINER_ID=`docker ps -aq --filter name="$CONTAINER_NAME"`
if [[ "${CONTAINER_ID}x" = "x" ]] ; then
    echo "[$CONTAINER_NAME] 容器没有运行 ..."
else
    echo "请在 steam 终端内依次输入以下命令 :"
    echo '1. [创建游戏目录]: force_install_dir /home/steam/games/${GAME_NAME}'
    echo "   [ARK 示例命令]: force_install_dir /home/steam/games/ark"
    echo "2. [登录匿名用户]: login anonymous"
    echo '3. [安装游戏私服]: app_update ${GAME_ID}'
    echo "   [ARK 示例命令]: app_update 376030"
    echo '4. [更新（可选）]: app_update ${GAME_ID} validate'
    echo "   [ARK 示例命令]: app_update 376030 validate"
    docker exec -it $CONTAINER_ID /home/steam/steamcmd/steamcmd.sh
fi

echo "安装脚本终止."
