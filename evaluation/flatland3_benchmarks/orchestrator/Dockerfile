# checks.yml's build-images job builds only the deps target (pushed as a ci-deps-<hash> tag for CI test
# reuse); fab-flatland-docker.yml/release-please.yml build the full target (no --target, last stage wins) for
# real publishing. Both use the same GHA buildx cache scope (fab-flatland3-benchmarks-orchestrator) so the
# full build can cache-hit the deps stage's pip install layer instead of rebuilding it from scratch.
FROM python:3.12 AS deps

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED=1

# Install Docker
RUN apt-get update && curl -fsSL https://get.docker.com | sh

# setup user and workdir
RUN addgroup runner && adduser --system --disabled-password --home /app --ingroup runner runner
WORKDIR /app

ADD ./requirements.txt ./requirements.txt

RUN python -m pip install -U -r requirements.txt



FROM deps AS full

ADD ./orchestrator.py ./orchestrator.py
ADD ./orchestrator_common.py ./orchestrator_common.py
ADD ./s3_utils.py ./s3_utils.py
ADD ./submission_job.yaml ./submission_job.yaml
ADD ./orchestration_job.py ./orchestration_job.py
ADD ./orchestration_job.yaml ./orchestration_job.yaml
ADD ./queue_consumer.py ./queue_consumer.py

# configure runner
USER runner
