# A test for conda [issue 2437][]

[issue 2437]:  https://github.com/conda/conda/issues/2437

This project contains a single system test to replicate the behavior described in conda [issue 2437][].
In a conda installation shared by multiple users, linking errors occur because some package files are not group-writable.

The `Makefile` contains 3 targets:

*  **installer** -- to download the Linux shell script to install Miniconda3 (version 4.0.5).
*  **image** -- to create the Docker image from Ubuntu (Trusty) with a Miniconda installation shared by 2 non-root users.
*  **test** -- to run a `docker run` command where the second user creates a conda environment by cloning the root environment.
   The test passes the `--debug` flag the `conda` command, and then searches for linker errors in the debugging output.
