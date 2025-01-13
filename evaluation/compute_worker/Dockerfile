FROM --platform=linux/amd64 python:3.9

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED 1

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh


RUN curl -sSL https://install.python-poetry.org | python3 - --version 1.8.3
# Poetry location so future commands (below) work
ENV PATH $PATH:/root/.local/bin

ADD . .

RUN python -m pip install -U "celery[redis]"

CMD celery -A compute_worker worker \
    -l info \
    -Q compute-worker \
    -n compute-worker@%n \
    --concurrency=1
