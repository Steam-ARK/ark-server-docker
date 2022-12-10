# PowerShell
#------------------------------------------------
# 进入容器的交互终端
# bin/terminal.ps1 
#           [-u ${USER}]            # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#------------------------------------------------

param(
    [string]$u="1000"
)

$USER = "1000"
if(![String]::IsNullOrEmpty($u)) {
    if(($u -eq "root") -or ($u -eq "0")) {
        $USER = "root"
    }
}


$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if([String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."

} else {
    docker exec -it -u $USER $CONTAINER_ID bash
}
