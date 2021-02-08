#!/bin/bash

# Limelight addon (Kill it and start it each time Yabai starts)
killall limelight &>/dev/null
/usr/local/bin/limelight --config "$HOME/.limelightrc" &>/dev/null &
