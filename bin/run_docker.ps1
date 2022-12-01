# PowerShell
# 运行 docker 服务
#------------------------------------------------
# 命令执行示例：
# bin/run_docker.ps1
#------------------------------------------------


# 使用内置的 steam 用户启动
$ENV:U_ID=1000; `
$ENV:G_ID=1000; `
docker-compose up -d
Write-Host "Server is Running ..."
