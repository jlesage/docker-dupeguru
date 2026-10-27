#
# dupeguru Dockerfile
#
# https://github.com/jlesage/docker-dupeguru
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG DUPEGURU_VERSION=4.3.1

# Define software download URLs.
ARG DUPEGURU_URL=https://github.com/arsenetar/dupeguru/archive/${DUPEGURU_VERSION}.tar.gz

# Build dupeGuru.
FROM alpine:3.20 AS dupeguru
ARG DUPEGURU_URL
COPY src/dupeguru /build
RUN /build/build.sh "$DUPEGURU_URL"

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.20-v4.14.0

ARG DUPEGURU_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        py3-qt5 \
        py3-distro \
        py3-mutagen \
        py3-polib \
        py3-semantic-version \
        py3-send2trash \
        py3-sphinx \
        py3-xxhash \
        # Needed for dark mode support.
        adwaita-qt \
        # Need a font.
        font-croscore

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/dupeguru-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=dupeguru /tmp/dupeguru-install/usr/ /usr/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "dupeGuru" && \
    set-cont-env APP_VERSION "$DUPEGURU_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    set-cont-env TRASH_DIR "/trash" && \
    true

# Define mountable directories.
VOLUME ["/storage"]
VOLUME ["/trash"]

# Metadata.
LABEL \
    org.label-schema.name="dupeguru" \
    org.label-schema.description="Docker container for dupeGuru" \
    org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
    org.label-schema.vcs-url="https://github.com/jlesage/docker-dupeguru" \
    org.label-schema.schema-version="1.0"
