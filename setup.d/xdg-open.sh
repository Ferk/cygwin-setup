#!/bin/sh

cat >/bin/xdg-open <<EOF
#!/bin/sh
exec cmd /C start "$1" "\$@"
EOF
chmod +x /bin/xdg-open

