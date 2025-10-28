#!/bin/bash

# Unset git proxy configurations
git config --global --unset http.proxy || true
git config --global --unset https.proxy || true

# Avoid this error from the second start of the container
# failed to start daemon, ensure docker is not running or delete /var/run/docker.pid: process with PID 10 is still running
sudo rm -f /var/run/docker.pid

# Start dockerd in the background
# add --storage-driver=fuse-overlayfs to
# avoid ERRO[2025-10-27T09:15:03.770212158+07:00] failed to mount overlay: invalid argument     storage-driver=overlay2
sudo dockerd --storage-driver=fuse-overlayfs &

# Wait for dockerd to initialize
sleep 2

# Execute the provided command
exec "$@"