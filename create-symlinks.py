#!/usr/bin/python

import fnmatch
import os
import subprocess
import re

excluded = [ '.git/*', '*.md', os.path.basename(__file__) ]
target_dir = os.path.join(os.path.expanduser("~"), "test/")

# transform globs into regex
excluded = r'|'.join([fnmatch.translate(x) for x in excluded]) # transform glob patterns to regex

def included(filepath):  
    return not re.match(excluded, filepath)

for dirpath, subdirnames, filenames in os.walk(os.path.dirname(__file__)):
    
    for dotfile in filter(included, [os.path.normpath(os.path.join(dirpath, f)) for f in filenames]):
        dotfile_target = os.path.join(target_dir, dotfile)
        try:
            os.makedirs(os.path.dirname(dotfile_target))
        except FileExistsError: # directory already exists
            pass
        print(dotfile, dotfile_target)
        # create symlinks
        # os.symlink(dotfile, dotfile_target)

        
