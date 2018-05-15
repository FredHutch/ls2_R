#!/bin/bash

# required env vars: OUT_UID, OUT_GID, DEPLOY_PREFIX

set -x
set -e

groupadd -g $OUT_GID outside_group
useradd -u $OUT_UID -g outside_group outside_user 

DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y ${INSTALL_OS_PKGS}

su -c "/bin/bash /ls2/install_eb.sh ${EB_NAME}.eb" outside_user

su -c "source ${DEPLOY_PREFIX}/lmod/lmod/init/bash \
       && ${DEPLOY_PREFIX}/lmod/lmod/libexec/update_lmod_system_cache_files ${DEPLOY_PREFIX}/modules/all" outside_user

DEBIAN_FRONTEND=noninteractive AUTO_ADDED_PKGS=$(apt-mark showauto) apt-get remove -y --purge ${UNINSTALL_OS_PKGS} ${AUTO_ADDED_PKGS}
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
