#!/bin/sh

cat >/bin/xdg-open <<EOF
#!/bin/sh
exec cmd /C start "\$@"
EOF
chmod +x /bin/xdg-open

