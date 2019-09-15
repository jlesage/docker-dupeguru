# Docker container for dupeGuru
[![Docker Image Size](https://img.shields.io/microbadger/image-size/jlesage/dupeguru)](http://microbadger.com/#/images/jlesage/dupeguru) [![Build Status](https://travis-ci.org/jlesage/docker-dupeguru.svg?branch=master)](https://travis-ci.org/jlesage/docker-dupeguru) [![GitHub Release](https://img.shields.io/github/release/jlesage/docker-dupeguru.svg)](https://github.com/jlesage/docker-dupeguru/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/JocelynLeSage/0usd)

This is a Docker container for [dupeGuru](https://www.hardcoded.net/dupeguru/).

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

[![dupeGuru logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/dupeguru-icon.png&w=200)](https://www.hardcoded.net/dupeguru/)[![dupeGuru](https://dummyimage.com/400x110/ffffff/575757&text=dupeGuru)](https://www.hardcoded.net/dupeguru/)

dupeGuru is a tool to find duplicate files on your computer. It can scan either
filenames or contents. The filename scan features a fuzzy matching algorithm
that can find duplicate filenames even when they are not exactly the same.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the dupeGuru docker container with the following command:
```
docker run -d \
    --name=dupeguru \
    -p 5800:5800 \
    -v /docker/appdata/dupeguru:/config:rw \
    -v $HOME:/storage:rw \
    jlesage/dupeguru
```

Where:
  - `/docker/appdata/dupeguru`: This is where the application stores its configuration, log and any files needing persistency.
  - `$HOME`: This location contains files from your host that need to be accessible by the application.

Browse to `http://your-host-ip:5800` to access the dupeGuru GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-dupeguru.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-dupeguru/issues
