#!/bin/sh

docker run -p 4000:4000 \
  -v ${PWD}s/conf:/cube/conf \
  -e CUBEJS_DEV_MODE=true \
  cubejs/cube:latest