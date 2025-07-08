FROM python:3.13

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh


# setup user and workdir
RUN addgroup runner && adduser --system --disabled-password --home /app --ingroup runner runner
WORKDIR /app

RUN apt-get update \
 && apt-get install -y sudo

RUN usermod -a -G sudo runner

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# configure runner
USER runner

RUN sudo ls /tmp

# configure runner
USER runner

RUN mkdir ai4realnet_orchestrators
ADD ./evaluation/ai4realnet_orchestrators ./ai4realnet_orchestrators/

RUN find .

RUN python -m pip install -U -r ai4realnet_orchestrators/requirements.txt -r ai4realnet_orchestrators/domain_orchestrators/railway/requirements.txt

# required because of permissions in volume mounts
RUN mkdir data/
