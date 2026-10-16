#!/bin/sh

pkill -x quickshell 2>/dev/null
sleep 0.5

exec quickshell -c /home/moonwuzy/.config/quickshell
