#!/bin/bash

WORKDIR=$(pwd)

cd green && docker build -t trafficlight/green:v1.0 . && cd $WORKDIR || exit
cd yellow && docker build -t trafficlight/yellow:v1.0 . && cd $WORKDIR || exit
cd red && docker build -t trafficlight/red:v1.0 . && cd $WORKDIR || exit

docker network create --driver bridge traffic-light --subnet 172.20.0.0/16  --gateway 172.20.0.1

docker run -d --rm --name green-app --network traffic-light trafficlight/green:v1.0
docker run -d --rm --name yellow-app --network traffic-light trafficlight/yellow:v1.0
docker run -d --rm --name red-app --network traffic-light trafficlight/red:v1.0

docker rm nginx-proxy

docker run -d --name nginx-proxy -p 3000:3000 -p 4000:4000 -p 5000:5000 --network traffic-light -v $WORKDIR/nginx/nginx.conf:/etc/nginx/nginx.conf -v $WORKDIR/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf nginx:1.21