#!/usr/bin/env bash

USER=abc

service nginx start

user_exists(){ id "$1" >/dev/null 2>&1; }

if user_exists "$USER"; then
  echo ""
else
  adduser $USER --uid ${PUID:0} --gid ${PGID:0} --disabled-password --disabled-login --gecos 'a,b,c,d'
fi
mkdir -p /tmp/cache
chown $USER /tmp/cache

exec runuser -u $USER -- python3 -u -m frigate
