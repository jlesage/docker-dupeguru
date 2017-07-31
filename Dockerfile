#
# dupeguru Dockerfile
#
# https://github.com/jlesage/docker-dupeguru
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.6-v2.0.5

# Define software versions.
ARG DUPEGURU_VERSION=4.0.3

# Define software download URLs.
ARG DUPEGURU_URL=https://launchpad.net/~hsoft/+archive/ubuntu/ppa/+files/dupeguru_${DUPEGURU_VERSION}~xenial_amd64.deb

# Define working directory.
WORKDIR /tmp

# Install dupeGuru.
RUN \
    # Install packages needed by the build.
    add-pkg --virtual build-dependencies binutils curl patch && \

    # Download the dupeGuru package.
    echo "Downloading dupeGuru package..." && \
    curl -# -L -o dupeguru.deb ${DUPEGURU_URL} && \

    # Extract the dupeGuru package.
    ar vx dupeguru.deb && \
    tar xf data.tar.xz -C / && \

    # Fix for Python3.6 support.
    CPYTHON_LIBS="$(find /usr/share/dupeguru -name "*cpython-35m-x86_64*")" && \
    for LIB in $CPYTHON_LIBS; do \
        mv "$LIB" "$(echo "$LIB" | sed "s/cpython-35m-x86_64/cpython-36m-x86_64/")"; \
    done && \

    # Apply patch for os termination signals handling.
    cd /usr/share/dupeguru && \
    curl -# -L https://github.com/jlesage/dupeguru/commit/73dbacace18542e27260514b436c3b7f746fc203.patch | patch -p1 && \
    cd /tmp && \

    # Enable direct file deletion by default.
    #sed-patch 's/self.direct = False/self.direct = True/' /usr/share/dupeguru/core/gui/deletion_options.py && \

    # Maximize only the main/initial window.
    sed-patch 's/<application type="normal">/<application type="normal" title="dupeGuru">/' \
        /etc/xdg/openbox/rc.xml && \

    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="dupeGuru">/a \    <layer>below</layer>' \
        /etc/xdg/openbox/rc.xml && \

    # Make sure dialog windows are always above other ones.
    sed-patch '/<\/applications>/i \  <application type="dialog">\n    <layer>above<\/layer>\n  <\/application>' \
        /etc/xdg/openbox/rc.xml && \

    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/*

# Install dependencies.
RUN add-pkg \
        python3 \
        py3-qt5 \
        mesa-dri-swrast \
        dbus

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/dupeguru-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="dupeGuru" \
    TRASH_DIR="/trash"

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/trash"]

# Metadata.
LABEL \
      org.label-schema.name="dupeguru" \
      org.label-schema.description="Docker container for dupeGuru" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-dupeguru" \
      org.label-schema.schema-version="1.0"
