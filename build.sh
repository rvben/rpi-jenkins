#!/bin/bash

PREFIX="rvben"
IMAGE="rpi-jenkins"
VERSION=`date +'%Y%m%d'`
LOCAL_REGISTRY="rpi1:5443"

# docker build --rm --no-cache -t $PREFIX/$IMAGE:$VERSION .
docker build --rm -t $PREFIX/$IMAGE:$VERSION .
docker tag $PREFIX/$IMAGE:$VERSION $PREFIX/$IMAGE:latest

docker tag $PREFIX/$IMAGE:$VERSION $LOCAL_REGISTRY/$PREFIX/$IMAGE:$VERSION
docker tag $PREFIX/$IMAGE:$VERSION $LOCAL_REGISTRY/$PREFIX/$IMAGE:latest
docker push $LOCAL_REGISTRY/$PREFIX/$IMAGE:$VERSION
docker push $LOCAL_REGISTRY/$PREFIX/$IMAGE:latest
