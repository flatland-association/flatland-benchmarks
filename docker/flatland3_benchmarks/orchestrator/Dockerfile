FROM ghcr.io/flatland-association/fab-flatland3-benchmarks-orchestrator:latest

# switch to root again
USER root

RUN apt-get update \
 && apt-get install -y sudo

RUN usermod -a -G sudo runner

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# configure runner
USER runner

RUN sudo ls /tmp

# TODO temporary workaround until part of fab-flatland3-benchmarks-orchestrator:latest
RUN python -m pip install -U fab-clientlib
