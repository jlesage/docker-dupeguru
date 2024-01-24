#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

mkdir -p "$XDG_CONFIG_HOME/Hardcoded Software" \
         "$XDG_DATA_HOME/Hardcoded Software/dupeGuru" \
         "$XDG_CACHE_HOME"

# Upgrade previous installations.
[ ! -f /config/debug.log ] || mv -v /config/debug.log "$XDG_DATA_HOME/Hardcoded Software/dupeGuru/"
[ ! -d /config/share ] || mv -v /config/share/* "$XDG_DATA_HOME/Hardcoded Software/dupeGuru/"
[ ! -d /config/share ] || rm -r /config/share
[ ! -f /config/QtProject.conf ] || mv -v /config/QtProject.conf "$XDG_CONFIG_HOME/"
[ ! -f /config/dupeGuru.conf ] || mv -v /config/dupeGuru.conf "$XDG_CONFIG_HOME/Hardcoded Software/"

# Install default config if needed.
[ -f "$XDG_CONFIG_HOME/Hardcoded Software/dupeGuru.conf" ] || cp -v /defaults/dupeGuru.conf "$XDG_CONFIG_HOME/Hardcoded Software/"
[ -f "$XDG_CONFIG_HOME/QtProject.conf" ] || cp -v /defaults/QtProject.conf "$XDG_CONFIG_HOME/"

# vim:ts=4:sw=4:et:sts=4
