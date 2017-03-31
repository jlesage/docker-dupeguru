# This software is licensed under the "BSD" License as described in the "LICENSE" file, 
# which should be included with this package. The terms are also available at 
# http://www.hardcoded.net/licenses/bsd_license

# This is an adaptation of plat_other.py for Docker environments.  The main
# difference is that the trash folder is static and is not required to be on the
# same volume as the file being removed.  Thus, deleted files are moved instead
# of being renamed.
#
# This is adaptation follow most of freedesktop.org trash specification:
#   [1] http://www.freedesktop.org/wiki/Specifications/trash-spec
#   [2] http://www.ramendik.ru/docs/trashspec.html
# See also:
#   [3] http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html

from __future__ import unicode_literals

import sys
import os
import os.path as op
import shutil
from datetime import datetime
try:
    from urllib.parse import quote
except ImportError:
    # Python 2
    from urllib import quote

FILES_DIR = 'files'
INFO_DIR = 'info'
INFO_SUFFIX = '.trashinfo'

# Default of ~/.local/share [3]
XDG_DATA_HOME = op.expanduser(os.environ.get('XDG_DATA_HOME', '~/.local/share'))
XDG_DATA_HOME_TRASH = op.join(XDG_DATA_HOME, 'Trash')
# Docker adaptation: trash folder can be located anywhere.
TRASH_DIR = os.environ.get('TRASH_DIR', XDG_DATA_HOME_TRASH)

def is_parent(parent, path):
    path = op.realpath(path) # In case it's a symlink
    parent = op.realpath(parent)
    return path.startswith(parent)

def format_date(date):
    return date.strftime("%Y-%m-%dT%H:%M:%S")

def info_for(src, topdir):
    # ...it MUST not include a ".."" directory, and for files not "under" that
    # directory, absolute pathnames must be used. [2]
    if topdir is None or not is_parent(topdir, src):
        src = op.abspath(src)
    else:
        src = op.relpath(src, topdir)

    info  = "[Trash Info]\n"
    info += "Path=" + quote(src) + "\n"
    info += "DeletionDate=" + format_date(datetime.now()) + "\n"
    return info

def check_create(dir):
    # use 0700 for paths [3]
    if not op.exists(dir):
        os.makedirs(dir, 0o700)

def trash_move(src, dst, topdir=None):
    filename = op.basename(src)
    filespath = op.join(dst, FILES_DIR)
    infopath = op.join(dst, INFO_DIR)

    counter = 0
    destname = filename
    while op.exists(op.join(filespath, destname)) or op.exists(op.join(infopath, destname + INFO_SUFFIX)):
        counter += 1
        destname = '%s.%s' % (filename, counter)
    
    check_create(filespath)
    check_create(infopath)
    
    # Docker adaptation: Move instead of rename. 
    shutil.move(src, op.join(filespath, destname))
    f = open(op.join(infopath, destname + INFO_SUFFIX), 'w')
    f.write(info_for(src, topdir))
    f.close()

def send2trash(path):
    if not isinstance(path, str):
        path = str(path, sys.getfilesystemencoding())
    if not op.exists(path):
        raise OSError("File not found: %s" % path)
    # ...should check whether the user has the necessary permissions to delete
    # it, before starting the trashing operation itself. [2]
    if not os.access(path, os.W_OK):
        raise OSError("Permission denied: %s" % path)

    topdir = XDG_DATA_HOME
    dest_trash = TRASH_DIR

    # Docker adaptation: Don't verify that the trash folder is on the same
    # volume as the file being removed.  Just do some sanity checks on the
    # trash folder.
    if op.lexists(dest_trash):
        real_trash = op.realpath(dest_trash)
        if op.exists(real_trash) and not op.isdir(real_trash):
            raise OSError("Trash not a folder: %s" % real_trash)
        check_create(real_trash)
    else:
        check_create(dest_trash)
    if not os.access(op.realpath(dest_trash), os.W_OK):
        raise OSError("Permission denied on trash folder: %s" % dest_trash)

    trash_move(path, dest_trash, topdir)
