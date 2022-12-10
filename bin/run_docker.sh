#!/bin/bash
#------------------------------------------------
# 运行 docker 服务
# bin/run_docker.sh
#           [-u ${USER}]            # 指定启动终端的用户，默认非 root（可以用 UID 代替 USERNAME）
#------------------------------------------------

ID=1000

set -- `getopt u: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -u) ID="$2"
        shift ;;
  esac
  shift
done

if [[ "${ID}x" = "rootx" ]] || [[ "${ID}x" = "0x" ]] ; then
    ID=0
else
    ID=1000
fi



U_ID=${ID} \
G_ID=${ID} \
docker-compose up -d
echo "Docker is running (uid=${ID}) ..."
