# PowerShell
#------------------------------------------------
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
#------------------------------------------------
# 示例：bin/run_ark.ps1 
#           [-u ${USER}]                        # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#           [-s ${ServerName}]                  # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]                     # 地图名
#           [-n ${PlayerAmount}]                # 最大玩家数
#           [-p ${ServerPassword}]              # 服务器密码
#           [-a ${AminPassword}]                # 管理员密码
#           [-d ${Difficulty}]                  # 游戏难度
#           [-h ${HarvestAmount}]               # 资源获得倍率
#           [-t ${TamingSpeed}]                 # 驯服恐龙倍率
#           [-r ${ResourcesRespawnPeriod}]      # 资源重生倍率
#           [-g ${CropGrowthSpeed}]             # 作物生长倍率
#           [-x ${XPMultiplier}]                # 经验获得倍率
#           [-i ${ModIds}]                      # 地图 MOD ID 列表，用英文逗号分隔
#------------------------------------------------

param(
    [string]$u="1000",
    [string]$s="EXP_ARK_Server",
    [string]$m="TheIsland",
    [int]$c=10, 
    [string]$p="EXP123456", 
    [string]$a="ADMIN654321",
    [string]$d="0.2",
    [string]$h="1.0",
    [string]$t="1.0",
    [string]$r="1.0",
    [string]$g="1.0",
    [string]$x="1.0",
    [string]$i=""
)

$USER = "1000"
if(![String]::IsNullOrEmpty($u)) {
    if(($u -eq "root") -or ($u -eq "0")) {
        $USER = "root"
    }
}

$SERVER_NAME = $s
$SERVER_MAP = $m
$MAX_PLAYERS = $c
$SERVER_PASSWORD = $p
$ADMIN_PASSWORD = $a
$DIFFICULTY_MULT = $d
$HARVEST_MULT = $h
$TAMING_MULT = $t
$RESOURCE_MULT = $r
$GROWTH_MULT = $g
$XP_MULT = $x
$GAME_MOD_IDS = $i


$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if([String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."

} else {
    docker exec -d -u $USER $CONTAINER_ID /home/steam/bin/ark.sh `
        -s "${SERVER_NAME}" `
        -m "${SERVER_MAP}" `
        -c "${MAX_PLAYERS}" `
        -p "${SERVER_PASSWORD}" `
        -a "${ADMIN_PASSWORD}" `
        -d "${DIFFICULTY_MULT}" `
        -h "${HARVEST_MULT}" `
        -t "${TAMING_MULT}" `
        -r "${RESOURCE_MULT}" `
        -g "${GROWTH_MULT}" `
        -x "${XP_MULT}" `
        -i "${GAME_MOD_IDS}"
    Write-Host "ARK 启动中 (user=$USER) ..."
    Write-Host "稍后请刷新 steam 服务器列表 ..."
}
