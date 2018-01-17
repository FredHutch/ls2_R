FROM fredhutch/ls2.eb.foss:2016b

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    awscli

USER neo
# copy in AWS Batch's "fetch-and-run" for S3-based scripts
COPY aws-batch-helpers/fetch-and-run/fetch_and_run.sh /home/neo/fetch_and_run.sh

# copy in easyconfigs (so many due to missing dependencies in existing easyconfigs)
COPY easyconfigs/* /home/neo/.local/fh_easyconfigs/

# R sources that cannot be programmatically downloaded
COPY sources/* /home/neo/.local/easybuild/sources/

# put undownloadable software in place
RUN curl -o /home/neo/.local/easybuild/sources/jdk-8u92-linux-x64.tar.gz https://s3-us-west-2.amazonaws.com/ls2-sources/jdk-8u92-linux-x64.tar.gz

#ENV EASYBUILD_PREFIX=/home/neo/.local/easybuild
#ENV EASYBUILD_MODULES_TOOL=Lmod
#ENV EASYBUILD_MODULE_SYNTAX=Lua
#ENV EASYBUILD_ROBOT_PATHS=/home/neo/.local/fh_easyconfigs:

# install build-essential, build R, remove build-essential
# EVERYTHING beyond build-essential needs to be moved into EB!!!
USER root
RUN apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    unzip  && \
    su -c ". .local/lmod/lmod/init/bash && \
           module use /home/neo/.local/easybuild/modules/all && \
           module load EasyBuild && \
           export EASYBUILD_ROBOT_PATHS=/home/neo/.local/fh_easyconfigs:$EASYBUILD_ROBOT_PATHS && \
           eb -l R-3.4.3-foss-2016b-fh2.eb --robot" - neo && \
    apt-get remove -y --purge build-essential && \
    apt-get autoremove -y && \
    apt-get install -y libc6-dev
USER neo
