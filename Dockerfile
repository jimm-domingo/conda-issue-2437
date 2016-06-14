FROM ubuntu:trusty

ADD Miniconda3-4.0.5-Linux-x86_64.sh /opt/Miniconda3-4.0.5-Linux-x86_64.sh
RUN chmod +rx /opt/Miniconda3-4.0.5-Linux-x86_64.sh

RUN addgroup devteam

RUN mkdir /opt/devteam
RUN chgrp devteam /opt/devteam
RUN chmod -R g+rwx /opt/devteam

RUN adduser --disabled-password --gecos 'Developer 1' --ingroup devteam dev1
RUN adduser --disabled-password --gecos 'Developer 2' --ingroup devteam dev2

# Developer 1 sets up a shared Miniconda installation for the dev team
USER dev1
RUN umask 002 && /opt/Miniconda3-4.0.5-Linux-x86_64.sh -b -p /opt/devteam/miniconda3
