#!/bin/sh

cat >/bin/sudo <<EOF
#!/usr/bin/bash
while getopts "vAknSa:g:p:u:lbEHPC:c:r:t:" opt
do
	case "\$opt" in
		u) 	user="\$OPTARG" ;;
		b)  ;; # cygstart always opens new window
		*)	echo "sudo: no support for '-\$opt'" ;;
	esac
done
shift \$((OPTIND-1))
cygstart --action=runas "\$@"
EOF
chmod +x /bin/sudo
