FROM python:3.12

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh

# setup user and workdir
RUN addgroup runner && adduser --system --disabled-password --home /app --ingroup runner runner
WORKDIR /app

ADD ./orchestrator.py ./orchestrator.py
ADD ./orchestrator_common.py ./orchestrator_common.py
ADD ./requirements.txt ./requirements.txt
ADD ./s3_utils.py ./s3_utils.py

RUN python -m pip install -U -r requirements.txt

ADD ./submission_job.yaml ./submission_job.yaml

# configure runner
USER runner
