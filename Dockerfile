FROM fredhutch/ls2_easybuild_foss:2016b

# easyconfig to build - this file must be in the root of your repo
ENV EASYCONFIG_NAME R-3.4.3-foss-2016b-fh2.eb
# pass in required OS packages for the build
ENV INSTALL_OS_PKGS "awscli build-essential pkg-config libssl-dev unzip libc6-dev libmysqlclient-dev"

# pass in os pkg list to be removed after the build
ENV UNINSTALL_OS_PKGS "build-essential"

# switch to our non-root user
USER neo

# copy in AWS Batch's "fetch-and-run" for S3-based scripts
COPY aws-batch-helpers/fetch-and-run/fetch_and_run.sh /home/neo/fetch_and_run.sh

# copy in easyconfigs (so many due to missing dependencies in existing easyconfigs)
COPY easyconfigs/* /app/fh_easyconfigs/

# R sources that cannot be programmatically downloaded
COPY sources/* /app/sources/

# run script to download larger sources
RUN /bin/bash /app/sources/download_sources.sh

# install build-essential, build R, remove build-essential
# EVERYTHING beyond build-essential needs to be moved into EB!!!
USER root
RUN apt-get update -y && apt-get install -y $INSTALL_OS_PKGS && \
    su -c ". /app/lmod/lmod/init/bash && \
           module use /app/modules/all && \
           module load EasyBuild && \
           eb -l $EASYCONFIG_NAME --robot" - neo && \
    apt-get remove -y --purge $UNINSTALL_OS_PKGS && \
    apt-get autoremove -y
USER neo
