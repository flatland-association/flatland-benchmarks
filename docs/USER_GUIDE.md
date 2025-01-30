# Flatland Benchmarks User's Guide

> [!NOTE]  
> User documentation for benchmark participants and benchmark administrators.

## General Information

### Benchmark Participants' User Guide

* You must specify the URL to a publicly available Docker image.

### Benchmark Administrators' User Guide

## Flatland Benchmark Specific

Our compute worker is responsible for handling submissions.

### Flatland 3 Benchmark Participants' User Guide

* Your submission Docker image must ship with an entrypoint, so we can run the container without an entrypoint/command. See submission template [Dockerfile](../evaluation/submission_template/Dockerfile) for an example.
* We set two environment variables:
  * `AICROWD_TESTS_FOLDER` (see https://github.com/flatland-association/flatland-rl/blob/03234e2805d3ed3b8e8343d3e861fd3637e6470d/flatland/evaluators/client.py#L91)
  * `redis_ip` (see https://github.com/flatland-association/flatland-rl/blob/03234e2805d3ed3b8e8343d3e861fd3637e6470d/flatland/evaluators/client.py#L57)
* Environments are mounted at `/tmp/debug-environments/` (hard-coded location)

### FAB Benchmark Administrators' User Guide

This describes the default `evaluation/compute_worker` used with a different evaluator:

* Your evaluator Docker image must ship with an entrypoint, so we can run the container without an entrypoint/command.
* We set one environment variables:
  * `redis_ip` (see https://github.com/flatland-association/flatland-rl/blob/03234e2805d3ed3b8e8343d3e861fd3637e6470d/flatland/evaluators/client.py#L57)
* Environments are mounted at `/tmp/debug-environments/` (hard-coded location)
