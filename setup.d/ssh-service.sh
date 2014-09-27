#!/bin/sh

if ssh-host-config -y -c ntsec -u cyg_server
then
	netsh advfirewall firewall add rule name=SSH dir=in action=allow protocol=tcp localport=22
	net start sshd
fi