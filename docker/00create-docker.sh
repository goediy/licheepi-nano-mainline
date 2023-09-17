#!/bin/bash

docker build -t br-build:latest --build-arg UID=$UID --build-arg USERNAME=$USER -f Dockerfile .
