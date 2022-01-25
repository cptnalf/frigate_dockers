#!/bin/bash

# need to have the script updated.
# can't mount /tmp/cache, permission issues.
#   - maybe the tmpfs-mode=1777 would fix this?
#     for now the frigate.sh script makes the subdir and chown's it.

sudo docker run -d \
  --name frigate \
  --restart=unless-stopped \
  --runtime=nvidia \
  --privileged \
  --gpus all \
  --network ingress \
  --mount type=tmpfs,target=/tmp,tmpfs-size=805306368 \
  -v /srv/shinobi/frigate/media:/media/frigate \
  -v /srv/shinobi/frigate/config:/config \
  -v /etc/localtime:/etc/localtime:ro \
  --device /dev/apex_0 \
  -e FRIGATE_CAM_UN=frigate \
  -e FRIGATE_CAM_PW=etagirf \
  -e MPLCONFIGDIR=/config/mpl \
  -e PUID=1000 -e PGID=44 \
  -p 5002:5000 \
  -p 1935:1945 \
  cptnalf/frigate:0.9.4
