FROM fredhutch/ls2_r:3.4.3_bare

# Remember the default use is LS2_USERNAME, not root

# DEPLOY_PREFIX comes from ls2_lmod container, two containers up!

# supply EB_NAME as easyconfig name minus '.eb.' and any 'fh' suffix
# ex: R-3.4.3-foss-2016b-fh2.eb EB_NAME=R-3.4.3-foss-2016b and FH_SUFFIX=fh2

# easyconfig to build - leave '.eb' off and leave 'fh' suffix off
#ENV EB_NAME=""
#ARG EB_NAME
#ENV EB_NAME=${EB_NAME}

# which "fh" suffix should be used? - must be set as build-arg
ARG FH_SUFFIX
ENV FH_SUFFIX=${FH_SUFFIX}

# switch to full build
ENV EB_NAME=${BARE_EB_NAME}-${FH_SUFFIX}

# additional OS packages to install in the container
ENV INSTALL_OS_PKGS "pkg-config build-essential libssl-dev libmysqlclient-dev python-requests"

# os pkg list to be removed after the build - in EasyBuild, the 'dummy' toolchain requires build-essential
# also, the current toolchain we are using (foss-2016b) does not actually include 'make'
# removing build-essential will mean the resulting container cannot build additional software
ENV UNINSTALL_OS_PKGS "pkg-config build-essential libssl-dev libmysqlclient-dev python-requests"

# copy in possibly newer full R easyconfig
COPY easyconfigs/${EB_NAME}.eb /app/fh_easyconfigs/

# install and uninstall build-essential in one step to reduce layer size
# while installing Lmod, again must be root
USER root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y \
    && apt-get install -y ${INSTALL_OS_PKGS} \
    && /bin/bash /ls2/easy_update.sh ${EB_NAME} \
    && su -c "/bin/bash /ls2/install_eb.sh ${EB_NAME}" ${LS2_USERNAME} \
    && AUTO_ADDED_PKGS=$(apt-mark showauto) apt-get remove -y --purge ${UNINSTALL_OS_PKGS} ${AUTO_ADDED_PKGS} \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && hostname && date

# gather installed pkgs list
RUN dpkg -l > /ls2/installed_pkgs.${EB_NAME}

# copy in wrapper
COPY R /home/neo/

# switch to LS2 user for future actions
USER ${LS2_USERNAME}
WORKDIR /home/${LS2_USERNAME}
SHELL ["/bin/bash", "-c"]
