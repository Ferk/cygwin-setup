#!/bin/sh

mkdir -p ~/.config
cd ~/.config

{ 
	git pull --recurse-submodules
} || {
	git clone --recursive https://github.com/Ferk/xdg_config.git . && \
	./symlink.sh -f
}
