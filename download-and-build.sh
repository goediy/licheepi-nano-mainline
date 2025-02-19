#!/bin/bash
docker run --user $(id -u) --ipc=host --rm -it \
  -v $PWD/:/workdir/work \
  br-build \
  /workdir/br-build.sh


