
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

# DEPENDENCY SWITCH
# TODO use released version
RUN python -m pip install git+https://github.com/flatland-association/flatland-rl.git@main
