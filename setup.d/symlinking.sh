#!/bin/sh


export CYGWIN=winsymlinks:native

[ -e /media ] || ln -s /cygdrive /media
ln -s /cygsetup.exe /bin/cygsetup

