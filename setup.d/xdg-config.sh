#!/bin/sh

mkdir -p ~/.config
cd ~/.config

git pull || git clone https://github.com/Ferk/xdg_config.git .

./symlink.sh -f