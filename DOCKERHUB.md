# Docker container for dupeGuru
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/dupeguru/latest)](https://hub.docker.com/r/jlesage/dupeguru/tags) [![Build Status](https://github.com/jlesage/docker-dupeguru/actions/workflows/build-image.yml/badge.svg?branch=master)](https://github.com/jlesage/docker-dupeguru/actions/workflows/build-image.yml) [![GitHub Release](https://img.shields.io/github/release/jlesage/docker-dupeguru.svg)](https://github.com/jlesage/docker-dupeguru/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/JocelynLeSage)

This is a Docker container for [dupeGuru](https://www.hardcoded.net/dupeguru/).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![dupeGuru logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/dupeguru-icon.png&w=200)](https://www.hardcoded.net/dupeguru/)[![dupeGuru](https://images.placeholders.dev/?width=256&height=110&fontFamily=Georgia,sans-serif&fontWeight=400&fontSize=52&text=dupeGuru&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.hardcoded.net/dupeguru/)

dupeGuru is a tool to find duplicate files on your computer. It can scan either
filenames or contents. The filename scan features a fuzzy matching algorithm
that can find duplicate filenames even when they are not exactly the same.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the dupeGuru docker container with the following command:
```shell
docker run -d \
    --name=dupeguru \
    -p 5800:5800 \
    -v /docker/appdata/dupeguru:/config:rw \
    -v $HOME:/storage:rw \
    jlesage/dupeguru
```

Where:
  - `/docker/appdata/dupeguru`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `$HOME`: This location contains files from your host that need to be accessible to the application.

Browse to `http://your-host-ip:5800` to access the dupeGuru GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-dupeguru.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-dupeguru/issues
