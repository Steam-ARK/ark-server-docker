# PowerShell
# 停止 docker 服务
#------------------------------------------------
# 命令执行示例：
# bin/stop.ps1
#------------------------------------------------

# 使用 root 用户启动
$ENV:U_ID=0; `
$ENV:G_ID=0; `
docker-compose down
Write-Host "The ARK and Docker is stopped ."