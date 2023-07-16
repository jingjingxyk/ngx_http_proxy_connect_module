#!/bin/sh

set -eux
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

day=$(date -u +"%Y%m%dT%H%M%SZ")
day=$(date -u +"%Y%m%dT%H%MZ")
#day=$(date "+%Y%m%d%H")
export DOCKER_BUILDKIT=1
# buildx build --platform linux/aarch64
image="jingjingxyk/nginx:1.25.1-alpine-3.17-connect-proxy-$day"


# 使用代理下载源码
# sh build-docker.sh --proxy http://192.168.3.26:8015

PROXY_CONFIG_STRING=''
while [ $# -gt 0 ]; do
  case "$1" in
  --proxy)
    export HTTP_PROXY="$2"
    export HTTPS_PROXY="$2"
    export NO_PROXY="127.0.0.1,localhost,127.0.0.0/8,10.0.0.0/8,100.64.0.0/10,172.16.0.0/12,192.168.0.0/16,198.18.0.0/15,169.254.0.0/16"
    PROXY_CONFIG_STRING="--build-arg PROXY_URL=$2"
    shift
    ;;
  --*)
    echo "Illegal option $1"
    ;;
  esac
  shift $(($# > 0 ? 1 : 0))
done



docker build -t $image -f Dockerfile . --progress=plain  $PROXY_CONFIG_STRING


echo '__DIR__=$(cd "$(dirname "$0")";pwd) &&  cd ${__DIR__} ' > run-test.sh
cat >> run-test.sh <<EOF
docker run --rm  \
--name nginx-connect-proxy \
-p 8002:80 \
-v ./etc/nginx.conf:/usr/local/nginx/etc/nginx.conf \
-v ./etc/conf.d:/usr/local/nginx/etc/conf.d \
-v ./wildcard.your-domain.com.fullchain.pem:/tls/wildcard.your-domain.com.fullchain.pem \
-v ./wildcard.your-domain.com.key.pem:/tls/wildcard.your-domain.com.key.pem  \
$image

EOF

docker push $image
