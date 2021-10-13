#!/bin/bash

docker run -d --name "edgetpu_exporter" \
  -p 9102:8080\
  adaptant/edgetpu-exporter:arm64 
