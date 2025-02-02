#!/bin/sh

set -e

export DATA_TRANSPORT_LAYER__ADDRESS_MANAGER=0xdE1FCfB0851916CA5101820A69b13a4E276bd81F
export DATA_TRANSPORT_LAYER__DANGEROUSLY_CATCH_ALL_ERRORS=true
export DATA_TRANSPORT_LAYER__DB_PATH=/data
export DATA_TRANSPORT_LAYER__SYNC_FROM_L1=false
export DATA_TRANSPORT_LAYER__SYNC_FROM_L2=true
export DATA_TRANSPORT_LAYER__DEFAULT_BACKEND=l2
export DATA_TRANSPORT_LAYER__L1_GAS_PRICE_BACKEND=l2
export DATA_TRANSPORT_LAYER__ETH_NETWORK_NAME=mainnet
export DATA_TRANSPORT_LAYER__L2_CHAIN_ID=10
export DATA_TRANSPORT_LAYER__NODE_ENV=production
export DATA_TRANSPORT_LAYER__POLLING_INTERVAL=500
export DATA_TRANSPORT_LAYER__SERVER_HOSTNAME=0.0.0.0
export DATA_TRANSPORT_LAYER__SERVER_PORT=7878
export DATA_TRANSPORT_LAYER__L1_START_HEIGHT=13596466
export DATA_TRANSPORT_LAYER__L1_RPC_ENDPOINT=$L1_RPC_ENDPOINT
export DATA_TRANSPORT_LAYER__L2_RPC_ENDPOINT=https://opt-mainnet.g.alchemy.com/v2/Im6I9y7QNPR3v5kaj73xrm4F99mcuFvG

start() {
  node dist/src/services/run.js &
  PID="$!"
}

stop() {
  echo "Catching signal and sending to PID: $PID" && kill $PID
  while $(kill -0 $PID 2>/dev/null); do sleep 1; done
}

trap 'stop' TERM INT
start
wait $PID
