#!/usr/bin/python

import sys
import os
import re
import fnmatch

excluded = ['.git/*', 'thinkpadl430/*', '*.md', os.path.basename(__file__)]
target_dir = os.path.expanduser("~")

# transform globs into regex
excluded = r'|'.join([fnmatch.translate(x) for x in excluded])


def included(filepath):
    return not re.match(excluded, filepath)

for dirpath, subdirnames, filenames in os.walk(os.path.dirname(__file__)):
    for dotfile in filter(included, [os.path.normpath(os.path.join(dirpath, f)) for f in filenames]):
        dotfile_target = os.path.abspath(os.path.join(target_dir, dotfile))
        dotfile = os.path.abspath(dotfile)
        try:
            os.makedirs(os.path.dirname(dotfile_target))
        except FileExistsError:  # directory already exists
            pass
        # create symlinks
        try:
            os.symlink(dotfile, dotfile_target)
            # print("created link '{0} -> {1}'".format(dotfile_target, dotfile))
        except FileExistsError:
            print("WARNING: '{0}' already exists".format(dotfile_target))

print("done creating symlinks")
