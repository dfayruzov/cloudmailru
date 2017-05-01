#!/bin/bash

groupmod -o -g ${PGID:-1000} abc
usermod -o -u ${PUID:-1000} abc
chown -R abc:abc /home/abc
chown -R abc:abc /cloud

/usr/bin/expect <<EOF
set timeout 60
spawn su - abc -c "/usr/bin/vncpasswd"
expect "Password:"
send "$VNCPASS\r"
expect "Verify:"
send "$VNCPASS\r"
expect eof
EOF

rm -rf /tmp/.X*-lock /tmp/.X11-unix
su - abc -c "vnc4server $DISPLAY && umask 002 && cloud"
