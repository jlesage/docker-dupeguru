# Docker container for dupeGuru
[![](https://images.microbadger.com/badges/image/jlesage/dupeguru.svg)](http://microbadger.com/#/images/jlesage/dupeguru "Get your own image badge on microbadger.com")

This is a Docker container for dupeGuru.  The GUI of the application is
accessed through a modern web browser (no installation or configuration needed
on client side) or via any VNC client.

---

[![dupeGuru logo](https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/dupeguru-icon.png)](https://www.hardcoded.net/dupeguru/)
[![dupeGuru](https://dummyimage.com/400x110/ffffff/575757&text=dupeGuru)](https://www.hardcoded.net/dupeguru/)

dupeGuru is a tool to find duplicate files on your computer. It can scan either
filenames or contents. The filename scan features a fuzzy matching algorithm
that can find duplicate filenames even when they are not exactly the same.

---

## Quick Start
First create the configuration directory for dupeGuru.  In this example,
`/docker/appdata/dupeguru` is used.  To find duplicated files under your home
directory, launch the dupeGuru docker container with the following command:
```
docker run -d \
    -p 5800:5800 \
    -p 5900:5900 \
    -v /var/docker/dupeguru:/config \
    -v $HOME:/storage \
    jlesage/dupeguru
```

Browse to `http://your-host-ip:5800` to access the dupeGuru GUI.  Your home
directories and files appear under the `/storage` folder in the container.

## Usage
```
docker run [-d|--rm] \
    --name=dupeguru \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-v <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    jlesage/dupeguru
```
| Parameter | Description |
|-----------|-------------|
| -d        | Run the container in background.  If not set, the container runs in foreground. |
| --rm      | Automatically remove the container when it exits. |
| -e        | Pass an environment variable to the container.  See the [Environment Variables](#environment-variables) section for more details. |
| -v        | Set a volume mapping (allows to share a folder/file between the host and the container).  See the [Data Volumes](#data-volumes) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host).  See the [Ports](#ports) section for more details. |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`USER_ID`       | ID of the user dupeGuru run as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | 1000    |
|`GROUP_ID`      | ID of the group the dupeGuru run as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | 1000    |
|`TZ`            | [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | Etc/UTC |
|`DISPLAY_WIDTH` | Width (in pixels) of the display.             | 1280    |
|`DISPLAY_HEIGHT`| Height (in pixels) of the display.            | 768     |
|`VNC_PASSWORD`  | Password needed to connect to the dupeGuru GUI.  See the [VNC Pasword](#vnc-password) section for more details. | (unset) |

[TimeZone]: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones

### Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified in the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/config`        | rw          | This is where dupeGuru stores its configuration, log and any files needing persistency. |
|`/storage`       | rw          | This is where your files and folders on your host are made available for dupeGuru. |
|`/trash`         | rw          | This is where dupeGuru moves files when they are sent to trash. |

### Ports

Here are the list of internal container ports.  They can be mapped to the host
via the `-p <HOST_PORT>:<CONTAINER_PORT>` parameter.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 5800 | Mandatory  | Port used to access to the dupeGuru GUI via the web interface. |
| 5900 | Mandatory  | Port used to access to the dupeGuru GUI via the VNC protocol.  |

## User/Group IDs

When using data volumes (`-v` flags), permissions issues can occur between the
host and the container.  For example, the user within the container may not
exists on the host.  This could prevent the host from properly accessing files
and folders on the shared volume.

To avoid any problem, you can specify the user the application should run as.

This is done by passing the user ID and group ID to the container via the
`USER_ID` and `GROUP_ID` environment variables.

To find the right IDs to use, issue the following command on the host, with the
user owning the data volume on the host:

    id <username>

Which gives an output like this one:
```
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),4(adm),24(cdrom),27(sudo),46(plugdev),113(lpadmin)
```

The value of `uid` (user ID) and `gid` (group ID) are the ones that you should
be given the container.

## Accessing the GUI

The graphical interface of the application can be accessed via:
  * A web browser:
```
http://<HOST IP ADDR>:5800
```

  * Any VNC client:
```
<HOST IP ADDR>:5900
```

## VNC Password
To restrict access to your application, a password can be specified.  This can
be done via two methods:
  * By using the `VNC_PASSWORD` environment variable.
  * By creating a `.vncpass_clear` file at the root of the `/config` volume.
  This file should contains the password (in clear).  During the container
  startup, content of the file is obfuscated and moved to `.vncpass`.

**NOTE**: This is a very basic way to restrict access to the application and it
should not be considered as secure in any way.

## dupeGuru Deletion Options
When deleting duplicated files, *dupeGuru* offer two choices:
  * Send files to trash
  * Delete files directly

The first option moves files to the `/trash` directory inside the container.
This operation can be slow for large files since it may imply a copy of the
data before the actual deletion.

There is also an option to link deleted files.  It is not recommended to enable
this option, since there is a good chance that created links won't make sense
outside the container.