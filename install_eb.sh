#!/bin/bash

set -x
set -e

# try to preserve group write here
umask 002

# load modules
source ${DEPLOY_PREFIX}/lmod/lmod/init/bash
module use ${DEPLOY_PREFIX}/modules/all

# load Easybuild
module load EasyBuild

# build the easyconfig file
eb -l $1.eb --robot

