#!/bin/bash

set -x
set -e

# variables used: EB_NAME, DEPLOY_PREFIX

# try to preserve group write here
umask 002

# load modules
source ${DEPLOY_PREFIX}/lmod/lmod/init/bash
module use ${DEPLOY_PREFIX}/modules/all

# load Easybuild
module load EasyBuild

# run easy_update
RUN cd /app/fh_easyconfigs \
    && python /ls2/easy_update.py ${EB_NAME}.eb \
    && mv ${EB_NAME}.update ${EB_NAME}.eb

# build the easyconfig file
eb -l ${EB_NAME}.eb --robot

