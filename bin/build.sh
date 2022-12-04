#!/bin/bash
# ------------------------
# 构建镜像
# bin/build.sh [-c OFF]
#   -c 是否启用缓存构建: OFF/ON(默认)
# ------------------------

CACHE="ON"

set -- `getopt c: "$@"`
while [ -n "$1" ]
do
  case "$1" in
    -c) CACHE="$2"
        shift ;;
  esac
  shift
done


function del_image {
  image_name=$1
  image_id=`docker images -q --filter reference=${image_name}`
  if [ ! -z "${image_id}" ]; then
    echo "delete [${image_name}] ..."
    docker image rm -f ${image_id}
    echo "done ."
  fi
}

function build_image {
    image_name=$1
    dockerfile=$2
    del_image ${image_name}
    if [ "x${CACHE}" = "xOFF" ]; then
        docker build --no-cache -t ${image_name} -f ${dockerfile} .
    else
        docker build -t ${image_name} -f ${dockerfile} .
    fi
}

echo "build image ..."
image_name=`echo ${PWD##*/}`
build_image ${image_name} "Dockerfile"

U_ID=0 \
G_ID=0 \
docker-compose build

docker image ls | grep "${image_name}"
echo "finish ."