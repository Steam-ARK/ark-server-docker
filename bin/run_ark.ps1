# PowerShell
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.ps1 
#           [-n ${ServerName}]      # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]         # 地图名
#           [-i ${ModIds}]          # 地图 MOD ID 列表，用英文逗号分隔
#           [-p ${PlayerAmount}]    # 最大玩家数
#------------------------------------------------


param(
    [string]$n="EXP_ARK_Server",
    [string]$m="TheIsland",
    [string]$i="",
    [int]$p=10
)

$SERVER_NAME = $n
$SERVER_MAP = $m
$GAME_MOD_IDS = $i
$MAX_PLAYERS = $p


$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if([String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."

} else {
    docker exec -it $CONTAINER_ID sh -c "/home/steam/bin/ark.sh -n ${SERVER_NAME} -m ${SERVER_MAP} -i ${GAME_MOD_IDS} -p ${MAX_PLAYERS}"
    Write-Host "ARK 启动中 ..."
    Write-Host "稍后请刷新 steam 服务器列表 ..."
}
