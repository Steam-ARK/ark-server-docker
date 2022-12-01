# PowerShell
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.ps1 
#           [-u ${USER}]            # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#           [-n ${ServerName}]      # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]         # 地图名
#           [-i ${ModIds}]          # 地图 MOD ID 列表，用英文逗号分隔
#           [-c ${PlayerAmount}]    # 最大玩家数
#           [-p ${ServerPassword}]  # 服务器密码
#           [-a ${AminPassword}]    # 管理员密码
#------------------------------------------------

param(
    [string]$u="1000",
    [string]$n="EXP_ARK_Server",
    [string]$m="Ragnarok",
    [string]$i="",
    [int]$c=10, 
    [string]$p="EXP123456", 
    [string]$a="ADMIN654321"
)

$USER = "1000"
if(![String]::IsNullOrEmpty($u)) {
    if(($u -eq "root") -or ($u -eq "0")) {
        $USER = "root"
    }
}

$SERVER_NAME = $n
$SERVER_MAP = $m
$GAME_MOD_IDS = $i
$MAX_PLAYERS = $c
$SERVER_PASSWORD = $p
$ADMIN_PASSWORD = $a


$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if([String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."

} else {
    docker exec -d -u $USER $CONTAINER_ID sh -c "/home/steam/bin/ark.sh -n ${SERVER_NAME} -m ${SERVER_MAP} -i ${GAME_MOD_IDS} -c ${MAX_PLAYERS} -p ${SERVER_PASSWORD} -a ${ADMIN_PASSWORD}"
    Write-Host "ARK 启动中 (user=$USER) ..."
    Write-Host "稍后请刷新 steam 服务器列表 ..."
}
