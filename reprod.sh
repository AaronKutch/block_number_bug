#!/bin/bash

export NEON_EVM_COMMIT="95c8a7a26b94ad22997a259b10a7145e52bc5c0e"
export PROXY_REVISION="3cadf73812da5a05c9441a921957bb6a9dce39a3"
export FAUCET_COMMIT="v0.12.0"

set +e
docker-compose -f docker-compose.yml down
docker network rm net
set -e

# add `--internal` to insure everything is self contained
docker network create net

docker-compose -f docker-compose.yml build

docker build -f ./curl_container.dockerfile -t curl_container .

docker-compose -f docker-compose.yml up -d --force-recreate

docker run --name curl_container --network net --hostname test --cap-add=NET_ADMIN -t curl_container /bin/bash -s 'sleep infinity'
