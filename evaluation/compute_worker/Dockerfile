FROM python:3.9

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh

# setup user and workdir
RUN addgroup runner && adduser --system --disabled-password --home /app --ingroup runner runner
WORKDIR /app

ADD ./tasks.py ./tasks.py
ADD ./requirements.txt ./requirements.txt

RUN python -m pip install -U -r requirements.txt

ADD ./evaluator_job.yaml ./evaluator_job.yaml
ADD ./submission_job.yaml ./submission_job.yaml

# configure runner
USER runner
