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

Your submission Docker image must ship with an entrypoint that

* activates the Python env contain that has the Flatland cli commands and your policy and observation builders are on the `PYTHONPATH`
* `POLICY` and `OBS_BUILDER` env vars are set to your policy and matching observation builder implementing the corresponding interfaces (`flatland.envs.RailEnvPolicy.RailEnvPolicy` resp. `flatland.core.env_observation_builder.ObservationBuilder`)

See submission template [FAB Flatland 3 starterkit](https://github.com/flatland-association/flatland-benchmarks-f3-starterkit/) for an example.


