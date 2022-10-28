#!/bin/bash

set -eux
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}


# 获取最新容器tag
container_latest_tag=$(curl -L -s 'https://hub.docker.com/v2/repositories/jingjingxyk/nginx/tags/?page_size=1&page=1&ordering=last_updated'|jq '."results"[]["name"]'| sed 's/\"//g')
echo $container_latest_tag

image="docker.io/jingjingxyk/nginx:$container_latest_tag"

docker pull $image

container_id=$(docker create $image)  # returns container ID
docker cp $container_id:/usr/local/nginx/etc/nginx.conf nginx-default.conf
docker cp $container_id:/usr/local/nginx/etc/conf.d/default.conf nginx-default-domain.conf

docker rm $container_id



exit 0

image=nginx:alpine
container_id=$(docker create $image)  # returns container ID
docker cp $container_id:/etc/nginx/nginx.conf nginx-default.conf
docker cp $container_id:/etc/nginx/conf.d/default.conf nginx-default-domain.conf
docker rm $container_id
