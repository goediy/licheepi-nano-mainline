#!/bin/bash
docker run --ipc=host --rm -it \
  -v $PWD/:/home/$USER/work \
  br-build \
  /usr/bin/bash


