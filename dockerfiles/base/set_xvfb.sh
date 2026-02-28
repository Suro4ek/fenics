#!/bin/bash

# Start Xvfb in background
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &

# Wait for Xvfb to start
sleep 1

# Execute the command passed to the container
exec "$@"