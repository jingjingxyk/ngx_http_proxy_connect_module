#!/bin/bash

set -eux
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

image=nginx:alpine
image=jingjingxyk/nginx:alpine-1.21.1-connect-proxy-20220811T2356Z
container_id=$(docker create $image)  # returns container ID
docker cp $container_id:/usr/local/nginx/nginx.conf nginx-default.conf

docker rm $container_id
