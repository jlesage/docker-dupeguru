# Copyright 2013 Hardcoded Software (http://www.hardcoded.net)

# This software is licensed under the "BSD" License as described in the "LICENSE" file, 
# which should be included with this package. The terms are also available at 
# http://www.hardcoded.net/licenses/bsd_license

import sys
import os

def running_in_docker():
    # No need for dynamic check: this file is used only under Docker.
    return True

    path = '/proc/self/cgroup'
    return (
        os.path.exists('/.dockerenv') or
        os.path.isfile(path) and any('docker' in line for line in open(path))
    )

if sys.platform == 'darwin':
    from .plat_osx import send2trash
elif sys.platform == 'win32':
    from .plat_win import send2trash
elif sys.platform == 'linux' and running_in_docker():
    from .plat_docker import send2trash
else:
    try:
        # If we can use gio, let's use it
        from .plat_gio import send2trash
    except ImportError:
        # Oh well, let's fallback to our own Freedesktop trash implementation
        from .plat_other import send2trash
