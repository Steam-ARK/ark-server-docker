#!/bin/bash
#------------------------------------------------
# 停止 docker 服务
# bin/stop.sh
#------------------------------------------------

# 使用 root 用户停止
U_ID=0 \
G_ID=0 \
docker-compose down
echo "The ARK and Docker is stopped ."