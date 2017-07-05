#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

mkdir -p /config/share

# Upgrade previous installations.
if [ -f /config/debug.log ]
then
  mv /config/debug.log /config/share/
fi

# Install default config if needed.
if [ ! -f /config/dupeGuru.conf ]
then
  cp /defaults/dupeGuru.conf /config/dupeGuru.conf
fi

# Adjust ownership.
chown -R $USER_ID:$GROUP_ID /config

# vim: set ft=sh :
