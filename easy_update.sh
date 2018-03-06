#!/bin/bash

set -x
set -e

# variables used: $1 for easyconfig name
env

# try to preserve group write here
umask 002

# run easy_update
cd /app/fh_easyconfigs \
&& python /ls2/easy_update.py $1.eb \
&& mv $1.update $1.eb

