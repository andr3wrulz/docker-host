#!/usr/bin/env bash

cd ~/docker

docker system prune
docker image prune
docker volume prune
