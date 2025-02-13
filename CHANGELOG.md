# Changelog

All notable changes will be documented in this file, updated by [release-please](https://github.com/googleapis/release-please) based on [Conventional Commit messages](https://www.conventionalcommits.org/en/v1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.4.2](https://github.com/flatland-association/flatland-benchmarks/compare/v0.4.1...v0.4.2) (2025-02-13)


### Miscellaneous Chores

* release 0.4.2 ([#151](https://github.com/flatland-association/flatland-benchmarks/issues/151)) ([b8f6ae3](https://github.com/flatland-association/flatland-benchmarks/commit/b8f6ae3ab48ba7b7caaa0413d21f536e62b5b52c))

## [0.4.1](https://github.com/flatland-association/flatland-benchmarks/compare/v0.4.0...v0.4.1) (2025-02-13)


### Bug Fixes

* evaluate default value for Docker image tag when triggered by push on main. ([#146](https://github.com/flatland-association/flatland-benchmarks/issues/146)) ([885a3ee](https://github.com/flatland-association/flatland-benchmarks/commit/885a3eee6f39faf58e27658df3efebf32ec45a31))

## [0.4.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.3.0...v0.4.0) (2025-02-11)

* [Fixed] Fix passing through S3_UPLOAD_PATH_TEMPLATE and S3_UPLOAD_PATH_TEMPLATE_USE_SUBMISSION_ID from compute worker to evaluator. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/95
* [Changed] Run checks upon push to main and daily on default branch. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/96
* [Added] Display and store evaluation result by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/101
* [Security] Update npm packages by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/102
* [Changed] #31 Publish result when eula accepted by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/106
* [Changed] #103 Use same theme as flatland.cloud by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/107
* [Added] #30 Public leaderboard by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/109
* [Changed] #98 Use python 3.13 for compute worker. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/100
* [Changed] #81 Get rid of pvc and ad-hoc pod in favor of s3. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/112
* [Added] #69 Add timeout for k8s jobs. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/110
* [Changed] #94 UUID for submissions and results by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/113
* [Added] #75 Make supported client versions configurable. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/115
* [Changed] #9 Remove submission template in favor of external starterkit. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/111
* [Changed] Reduce Rabbit healthcheck interval. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/118
* [Changed] Cleanup pr template. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/121
* [Added] #78 Evaluate only selected tests by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/117
* [Changed] #105 Submission flow by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/116
* [Changed] #10 Download environments from S3 in k8s initContainers. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/126
* [Added] #99 Fail fast if either submission or evaluation fails. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/119
* [Changed] #104 #120 Improve submission UX and leaderboard by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/129
* [Changed] #93 #33 #130 UI updates by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/131
* [Security] #108 #88 Backend auth guard by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/134
* [Added] #10 Env generation for Flatland 3. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/128

## [0.3.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.0.0...v0.3.0) (2025-02-05)

* [Added] #1 Repo Initialization. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/13
* [Added] Add CHANGELOG.md, CONTRIBUTING.MD and pr template. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/18
* [Added] #3 Data Model Frontend/Backend by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/17
* [Added] #2 High-Level Architecture description. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/14
* [Added] #4 story frontend template by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/19
* [Changed] Update `pull_request_template.md` by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/24
* [Added] #8 Cloud Deployment Bootstrapping. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/23
* [Changed] #4 Minor template cleanup by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/22
* [Added] #6 `@flatland-association/flatland-ui` library for UI components.. by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/25
* [Fixed] Fix backend entrypoint. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/28
* [Changed] Cleanup repo/app name: flatland-benchmarks/Flatland Benchmarks/FAB/fab-. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/29
* [Added] #4 Bootstrapping Evaluation by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/20
* [Fixed] #35 Fix RabbitMQ High CPU Usage. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/37
* [Changed] Cleanup after repo renaming. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/44
* [Changed] Simplify story issue template to general task. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/61
* [Added] #27 Cloud Deployment. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/38
* [Added] #7 #26 refine submission flow by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/51
* [Added] #56 Bootstrap Unit Test Coverage for fab-flatland3-compute-worker by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/58
* [Added] #57 Bootstrap Integration Test Coverage for fab-flatland-compute-worker and fab-flatland3-evaluator by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/67
* [Fixed] #49 Fix nginx config supporting paths. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/77
* [Fixed] Fix invalid checks.yaml. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/79
* [Fixed] #49 Fix path, failing in gh by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/80
* [Added] 59 Update interface documentation by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/84
* [Added] #65 Pass `output.csv` and `output.json`: `evaluator` -> `compute_worker` -> `redis` (-> `backend`) by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/68
* [Added] #40 k8s compute worker implementation by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/83
* [Changed] Use gh releases for changelog keeping. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/85
* [Changed] #46 Use non-super-user to run compute worker. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/72
* [Added] #6 Keycloak authentication integration frontend by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/76
* [Fix] Fix broken link to ci badge. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/89
* [Fixed] Fix missing `pandas` dependency in compute worker. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/90
* [Fixed] Fix compute worker: env var mismatch for redis. Fix missing file. Add config options for evaluator. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/91

## New Contributors

* @Holzchopf made their first contribution in https://github.com/flatland-association/flatland-benchmarks/pull/17
