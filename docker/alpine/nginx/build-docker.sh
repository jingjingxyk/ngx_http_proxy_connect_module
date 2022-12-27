#!/bin/sh

set -eux
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

day=$(date -u +"%Y%m%dT%H%M%SZ")
day=$(date -u +"%Y%m%dT%H%MZ")
#day=$(date "+%Y%m%d%H")
export DOCKER_BUILDKIT=1
# buildx build --platform linux/aarch64
image="jingjingxyk/nginx:alpine-1.23-connect-proxy-$day"


# example use proxy download source code
# shell之变量默认值  https://blog.csdn.net/happytree001/article/details/120980066
# 使用代理下载源码
# sh build-docker.sh --proxy 1
PROXY_URL=${2:+'http://192.168.3.26:8015'}



docker build -t $image -f Dockerfile . --progress=plain --build-arg PROXY_URL=$PROXY_URL


echo '__DIR__=$(cd "$(dirname "$0")";pwd) &&  cd ${__DIR__} ' > run-test.sh
echo "docker run --rm  --name nginx-connect-proxy -p 8002:80  $image" >> run-test.sh

docker push $image
