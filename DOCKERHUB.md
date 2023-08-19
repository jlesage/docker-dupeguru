# Docker container for dupeGuru
[![Release](https://img.shields.io/github/release/jlesage/docker-dupeguru.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-dupeguru/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/dupeguru/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/dupeguru/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/dupeguru?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/dupeguru)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/dupeguru?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/dupeguru)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-dupeguru/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-dupeguru/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-dupeguru)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [dupeGuru](https://dupeguru.voltaicideas.net).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![dupeGuru logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/dupeguru-icon.png&w=110)](https://dupeguru.voltaicideas.net)[![dupeGuru](https://images.placeholders.dev/?width=256&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=dupeGuru&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://dupeguru.voltaicideas.net)

dupeGuru is a tool to find duplicate files on your computer. It can scan either
filenames or contents. The filename scan features a fuzzy matching algorithm
that can find duplicate filenames even when they are not exactly the same.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is given as an example
    and parameters should be adjusted to your need.

Launch the dupeGuru docker container with the following command:
```shell
docker run -d \
    --name=dupeguru \
    -p 5800:5800 \
    -v /docker/appdata/dupeguru:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/dupeguru
```

Where:

  - `/docker/appdata/dupeguru`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `/home/user`: This location contains files from your host that need to be accessible to the application.

Browse to `http://your-host-ip:5800` to access the dupeGuru GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-dupeguru.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-dupeguru/issues
