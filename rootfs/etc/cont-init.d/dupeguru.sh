#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Install default config if needed.
if [ ! -f /config/dupeGuru.conf ]
then
  cp /home/guiapp/.config/"Hardcoded Software"/dupeGuru.conf.default /config/dupeGuru.conf
  chown $USER_ID:$GROUP_ID /config/dupeGuru.conf
fi

# vim: set ft=sh :
