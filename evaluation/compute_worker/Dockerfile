FROM python:3.9

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

# setup user and workdir
RUN addgroup runner && adduser --system --disabled-password --home /app --ingroup runner runner
WORKDIR /app

# https://stackoverflow.com/questions/74247999/github-actions-self-hosted-runner-sibling-container-permission-denied-docker
# Docker in Docker https://github.com/CloudSnorkel/cdk-github-runners/blob/b45d173c166d1f7e3cf5b8bc4524a179f0e99005/src/providers/docker-images/codebuild/linux-x64/Dockerfile#L48-L61
ARG DOCKER_CHANNEL="stable"
ARG DIND_COMMIT="42b1175eda071c0e9121e1d64345928384a93df1"
ARG DOCKER_VERSION="20.10.18"
ARG DOCKER_COMPOSE_VERSION="2.11.0"
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
    tar --strip-components 1 -C /usr/local/bin/ -xzf docker.tgz && \
    rm docker.tgz && \
    # set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
    addgroup dockremap && \
    useradd -g dockremap dockremap && \
    echo 'dockremap:165536:65536' >> /etc/subuid && \
    echo 'dockremap:165536:65536' >> /etc/subgid && \
    curl -fsSL "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -o /usr/local/bin/dind && \
    curl -fsSL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
    mkdir -p /app/.docker/cli-plugins && ln -s /usr/local/bin/docker-compose /app/.docker/cli-plugins/docker-compose && \
    chown -R runner /app/.docker && \
    chmod +x /usr/local/bin/dind /usr/local/bin/docker-compose && \
    addgroup docker && usermod -aG docker runner


ADD ./tasks.py ./tasks.py
ADD ./requirements.txt ./requirements.txt

RUN python -m pip install -U -r requirements.txt

ADD ./evaluator_job.yaml ./evaluator_job.yaml
ADD ./submission_job.yaml ./submission_job.yaml

VOLUME /var/lib/docker

# configure runner
USER runner
