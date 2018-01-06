# ls2_R
Our build of R, including many packages our users have requested over the years
.

This is an EasyBuild-based build, and pulls the R easyconfig from our easybuild-life-sciences repo on GitHub (is a submodule here).

R package requests should be made in issues on that repo, rather than this one. Issue on this repo should be related to the Dockerfile only.

# TODO
[] - add awscli
[] - add 'fetch-and-run' for AWS Batch use
[] - add Bioconductor packages
[] - add unixodbc

# Using
The container has a user named `neo` with UID 500 and home directory /home/neo. All software is installed as that user in `~/.local` as EasyBuild does not run as root.

There is no process to run by default, so you will need to run a shell, use the `fetch-and-run` functionality once added, or extend this container into a new one with your code.

With a shell or script, you will need to activate Lmod and load the R environment module like this:

```
source /home/neo/.local/lmod/lmod/init/bash
module use /home/neo/.local/easybuild/modules/all
module load R/3.4.3-foss-2016b-fh2
```



# Build Notes
OS Dependencies:

* unixodbc is still an OS dependency

Version suffix `-fh*n*` is how we build multiple versions of the same version of software, and should be going away soon.

The build takes a long time.
