#!/bin/sh

if [ ! -z "$GLUSTER" ]; then
  umount /srv/mount || echo "Not mounted, no need to umount"
  mkdir /srv/mount
  mount -t glusterfs "$GLUSTER" "/srv/mount"
else
  echo "No gluster config will do nothing"
fi
sleep infinity
