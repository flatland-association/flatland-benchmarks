FROM ghcr.io/flatland-association/fab-flatland-compute-worker:latest

# switch to root again
USER root

RUN apt-get update \
 && apt-get install -y sudo

RUN usermod -a -G sudo runner

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# configure runner
USER runner

RUN sudo ls /tmp
