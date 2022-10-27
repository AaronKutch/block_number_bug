
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

# curl -X POST -d '{"wallet": "0xBf660843528035a5A4921534E156a27e64B231fE", "amount": 100000000}' 'http://faucet:3333/request_neon'

# curl -s --header "content-type: application/json" --data '{"method":"eth_getBalance","params":["0xBf660843528035a5A4921534E156a27e64B231fE","latest"],"id":1,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"method":"eth_getBalance","params":["0xb3d82b1367d362de99ab59a658165aff520cbd4d","latest"],"id":1,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"id":13,"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["0xf869808568c61714008324b2b094b3d82b1367d362de99ab59a658165aff520cbd4d82053980820102a00484e066a63e138c60c4074d941e15ddc9bbfab994e3dfe588470f428d265978a07ad2e28646273ac4022d1747b3b26ed3a3d01ad7561bdb732d6ff43a144e91c8"]}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"method":"eth_getBalance","params":["0xBf660843528035a5A4921534E156a27e64B231fE","latest"],"id":1,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"method":"eth_getBalance","params":["0xb3d82b1367d362de99ab59a658165aff520cbd4d","latest"],"id":1,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"method":"eth_getTransactionByHash","params":["0xc54e758da0c6c3efb827df44d713b20752543060c5f77add26a2820fd2538446"],"id":1,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "content-type: application/json" --data '{"method":"eth_blockNumber","params":[],"id":93,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "Content-Type: application/json" --data '{"method":"eth_getBlockByNumber","params":["latest",false],"id":99,"jsonrpc":"2.0"}' http://proxy:9090/solana

# curl -s --header "Content-Type: application/json" --data '{"method":"eth_getBlockByNumber","params":["finalized",false],"id":99,"jsonrpc":"2.0"}' http://proxy:9090/solana
