FROM fredhutch/ls2:EB-3.4.1_foss-2016b_20171030

# clean-up - move this upstream!
USER root
RUN apt-get remove --purge -y \
    zlib1g-dev \
    manpages-dev \
    libssl-dev \
    dpkg-dev
RUN apt-get autoremove -y

USER neo
WORKDIR /home/neo
SHELL ["/bin/bash", "-c"]

# copy our easyconfig in
COPY easybuild-life-sciences/fh_easyconfigs/R-3.4.3-foss-2016b-fh2.eb /home/neo/.local/fh_easyconfigs/
# copy our easyconfigs for dependencies in place
#libreadline', '6.3
#ncurses', '6.0
#bzip2', '1.0.6
#XZ', '5.2.2
#zlib', '1.2.8
COPY easybuild-life-sciences/fh_easyconfigs/SQLite-3.13.0-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
#PCRE', '8.38
#libpng', '1.6.24
#libjpeg-turbo', '1.5.0
#libpthread-stubs', '0.3
#LibTIFF', '4.0.6
#Java', '1.8.0_92
# toolchain change
COPY easybuild-life-sciences/fh_easyconfigs/Tcl-8.6.7-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/Tk-8.6.7-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# Tk with X11 in Python
COPY easybuild-life-sciences/fh_easyconfigs/Python-2.7.12-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# Move OpenSSL into eb
COPY easybuild-life-sciences/fh_easyconfigs/cURL-7.49.1-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
#libxml2', '2.9.4
#X11', '20160819
#freeglut', '3.0.0
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/GDAL-2.1.1-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
#GSL', '2.3
#PROJ', '4.9.2
#GMP', '6.1.1
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/JAGS-4.2.0-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
#libGLU', '9.0.0
COPY easybuild-life-sciences/fh_easyconfigs/Mesa-12.0.2-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/LLVM-3.9.1-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
#cairo', '1.14.6
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/unixODBC-2.3.4-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/PostgreSQL-9.6.1-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/netCDF-4.5.0-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/Doxygen-1.8.13-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/GLPK-4.61-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/ZeroMQ-4.1.4-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# needed for ZeroMQ - old version no longer downloadable
COPY easybuild-life-sciences/fh_easyconfigs/libsodium-1.0.13-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/HDF5-1.8.18-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/OpenSSL-1.1.0f-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# needed for R pkg
COPY easybuild-life-sciences/fh_easyconfigs/UDUNITS-2.1.24-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# needed for R mongolite pkg
COPY easybuild-life-sciences/fh_easyconfigs/cyrus-sasl-2.1.26-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/cyrus-sasl-2.1.26-types.patch /home/neo/.local/fh_easyconfigs/
# needed for Rmysql pkg
COPY easybuild-life-sciences/fh_easyconfigs/MariaDB-10.2.11-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/jemalloc-5.0.1-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
COPY easybuild-life-sciences/fh_easyconfigs/jemalloc-5.0.1-skip-install-doc.patch /home/neo/.local/fh_easyconfigs/

# R sources that cannot be programmatically downloaded
COPY sources/ASCAT_2.4.3.tar.gz /home/neo/.local/easybuild/sources/
COPY sources/v0.1.0.tar.gz /home/neo/.local/easybuild/sources/

# put easyconfigs for robot dependencies in place - fix these!
# nettle actually depends on M4, but easyconfig doesn't include it
COPY easybuild-life-sciences/fh_easyconfigs/nettle-3.2-foss-2016b.eb /home/neo/.local/fh_easyconfigs/
# Perl doesn't build man pages if you don't have man installed EB sanity reqs.
COPY easybuild-life-sciences/fh_easyconfigs/Perl-5.24.0-foss-2016b.eb /home/neo/.local/fh_easyconfigs/

# put undownloadable software in place
RUN curl -o /home/neo/.local/easybuild/sources/jdk-8u92-linux-x64.tar.gz https://s3-us-west-2.amazonaws.com/ls2-sources/jdk-8u92-linux-x64.tar.gz

# set up easybuild
ENV EASYBUILD_PREFIX=/home/neo/.local/easybuild
ENV EASYBUILD_MODULES_TOOL=Lmod
ENV EASYBUILD_MODULE_SYNTAX=Lua
ENV EASYBUILD_ROBOT_PATHS=/home/neo/.local/fh_easyconfigs:

# build R
#RUN ml EasyBuild && eb R-3.4.3-foss-2016b-fh1.eb --robot
