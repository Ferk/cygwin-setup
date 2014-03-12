#!/bin/sh

cat >/bin/sudo <<EOF
#!/usr/bin/bash
cygstart --action=runas "\$@"
EOF
chmod +x /bin/sudo
