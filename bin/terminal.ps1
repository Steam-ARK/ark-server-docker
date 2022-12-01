# PowerShell
# 进入 ARK 容器的交互终端
#------------------------------------------------
# 示例：bin/terminal.ps1
#------------------------------------------------

$CONTAINER_NAME = "ARK_SVC"
$CONTAINER_ID = (docker ps -aq --filter name="$CONTAINER_NAME")
if([String]::IsNullOrEmpty($CONTAINER_ID)) {
    Write-Host "[$CONTAINER_NAME] 容器没有运行 ..."

} else {
    docker exec -it $CONTAINER_ID bash
}
