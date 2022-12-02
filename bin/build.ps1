# PowerShell
# 构建 docker 镜像
#------------------------------------------------
# 命令执行示例：
# bin/build.ps1
#------------------------------------------------

# 使用 root 用户启动
$ENV:U_ID=0; `
$ENV:G_ID=0; `
docker-compose build
