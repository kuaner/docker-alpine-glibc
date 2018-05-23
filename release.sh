#!/bin/bash

REPO=d.autops.xyz

VER=3.7

docker build -t $REPO/base:$VER .

docker push $REPO/base:$VER