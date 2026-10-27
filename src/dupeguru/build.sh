#!/bin/sh
#
# Build dupeGuru.
#

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
# Do not pass --strip-all: that removes the dynamic symbols Python extension
# modules need in order to load.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--as-needed"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log() {
    echo ">>> $*"
}

DUPEGURU_URL="${1:-}"

if [ -z "$DUPEGURU_URL" ]; then
    log "ERROR: dupeGuru URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    build-base \
    curl \
    gettext \
    py3-distro \
    py3-mutagen \
    py3-pip \
    py3-polib \
    py3-qt5 \
    py3-semantic-version \
    py3-send2trash \
    py3-setuptools \
    py3-sphinx \
    py3-xxhash \
    python3 \
    python3-dev \

#
# Download sources.
#
log "Downloading dupeGuru..."
mkdir /tmp/dupeguru
curl -# -L -f "$DUPEGURU_URL" | tar xz --strip 1 -C /tmp/dupeguru

#
# Compile dupeGuru.
#
log "Patching dupeGuru..."
patch -p1 -d /tmp/dupeguru < "$SCRIPT_DIR"/pygettext-no-imp.patch
patch -p1 -d /tmp/dupeguru < "$SCRIPT_DIR"/dont-follow-directory-symlinks.patch

log "Compiling dupeGuru..."
make -C /tmp/dupeguru -j"$(nproc)" PREFIX=/usr NO_VENV=1 DESTDIR=/tmp/dupeguru-install install

# The container does not use the installed desktop entry.
rm -rf /tmp/dupeguru-install/usr/share/applications

# Tests are not needed at runtime.
find /tmp/dupeguru-install/usr/share/dupeguru -type d -name tests -prune -exec rm -rf {} +
