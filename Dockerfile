#
# dupeguru Dockerfile
#
# https://github.com/jlesage/docker-dupeguru
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.5-v1.3.1

# Define software versions.
ARG DUPEGURU_VERSION=4.0.3

# Define software download URLs.
ARG DUPEGURU_URL=https://launchpad.net/~hsoft/+archive/ubuntu/ppa/+files/dupeguru_${DUPEGURU_VERSION}~xenial_amd64.deb

# Define working directory.
WORKDIR /tmp

# Install dupeGuru.
RUN \
    # Install packages needed by the build.
    apk --no-cache add --virtual build-dependencies binutils curl && \

    # Download the dupeCuru package.
    echo "Downloading dupeGuru package..." && \
    echo "${DUPEGURU_URL}" && \
    curl -# -L -o dupeguru.deb ${DUPEGURU_URL} && \

    # Extract the dupeGuru package.
    ar vx dupeguru.deb && \
    tar xf data.tar.xz -C / && \

    # Setup symbolic links for stuff that need to be outside the container.
    mkdir -p $HOME/.local/share/"Hardcoded Software" && \
    ln -s /config/share $HOME/.local/share/"Hardcoded Software"/dupeGuru && \
    ln -s /config/QtProject.conf $HOME/.config/QtProject.conf && \
    mkdir -p $HOME/.config/"Hardcoded Software" && \
    ln -s /config/dupeGuru.conf $HOME/.config/"Hardcoded Software"/dupeGuru.conf && \
    chown -R $USER_ID:$GROUP_ID $HOME && \

    # Enable direct file deletion by default.
    #sed -i 's/self.direct = False/self.direct = True/' /usr/share/dupeguru/core/gui/deletion_options.py && \

    # Maximize only the main/initial window.
    sed -i 's/<application type="normal">/<application type="normal" title="dupeGuru">/' \
        $HOME/.config/openbox/rc.xml && \

    # Cleanup.
    apk --no-cache del build-dependencies && \
    rm -rf /tmp/*

# Install dependencies.
RUN apk --no-cache add \
        python3 \
        py3-qt5 \
        mesa-dri-swrast \
        dbus

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/dupeguru-icon.png && \
    /opt/install_app_icon.sh "$APP_ICON_URL"

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
