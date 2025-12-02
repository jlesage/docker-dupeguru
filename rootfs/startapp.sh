#!/bin/sh

# Added to avoid the following error message:
#   MESA-LOADER: failed to open swrast: Error loading shared library
#   /usr/lib/xorg/modules/dri/swrast_dri.so: No such file or directory
#   (search paths /usr/lib/xorg/modules/dri, suffix _dri)
# We could instead install `mesa-dri-gallium`, but this increases the image
# size a lot.
export QT_QPA_PLATFORM=xcb
export QT_XCB_GL_INTEGRATION=none

cd /storage
exec /usr/bin/dupeguru
# vim:ft=sh:ts=4:sw=4:et:sts=4
