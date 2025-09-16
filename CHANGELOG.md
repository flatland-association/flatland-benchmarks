# Changelog

All notable changes will be documented in this file, updated by [release-please](https://github.com/googleapis/release-please) based on [Conventional Commit messages](https://www.conventionalcommits.org/en/v1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.12.2](https://github.com/flatland-association/flatland-benchmarks/compare/v0.12.1...v0.12.2) (2025-09-16)


### Features

* Change interface PostTestResultsBody ([#419](https://github.com/flatland-association/flatland-benchmarks/issues/419)) ([952736f](https://github.com/flatland-association/flatland-benchmarks/commit/952736f16db5885fec74471e0c8c58a84c3fbff4))
* Change interface Scorings ([86a6654](https://github.com/flatland-association/flatland-benchmarks/commit/86a66540aa0423226695f92a14531595908062a9))
* Change route visibility ([#415](https://github.com/flatland-association/flatland-benchmarks/issues/415)) ([267088c](https://github.com/flatland-association/flatland-benchmarks/commit/267088c45a4fe275d450a0c6b28a4c35dfb173f5))


### Bug Fixes

* Endpoint plurals ([374e019](https://github.com/flatland-association/flatland-benchmarks/commit/374e019a922efcf9d81ff3037d5ff8c35c64d3eb))


### Miscellaneous Chores

* release 0.12.2 ([3a1faae](https://github.com/flatland-association/flatland-benchmarks/commit/3a1faaefcda7d5ff6b129e61ecdd9096b38f68c4))

## [0.12.1](https://github.com/flatland-association/flatland-benchmarks/compare/v0.12.0...v0.12.1) (2025-09-12)


### Bug Fixes

* **frontend:** Loosen url validity check for submission data ([a4fef7e](https://github.com/flatland-association/flatland-benchmarks/commit/a4fef7eb601ef328b3174a36ba124c2d5bd47540))

## [0.12.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.11.0...v0.12.0) (2025-09-10)


### Features

* add agg at benchmark/test level. ([7fbca10](https://github.com/flatland-association/flatland-benchmarks/commit/7fbca1052df98b5e36c1d77a9e5d27c35ee9808e))
* add gen fields at benchmark/test/scenario level. ([c4c4520](https://github.com/flatland-association/flatland-benchmarks/commit/c4c45202dfa9f784a841abdb8a6b756749380596))
* add info service display FAB_VERSION. ([#391](https://github.com/flatland-association/flatland-benchmarks/issues/391)) ([d5b1237](https://github.com/flatland-association/flatland-benchmarks/commit/d5b12374c1dc49799fa285fec7defbcbb6a20892))
* add queue column to test definition to override taking benchmark_id. ([4bec0ac](https://github.com/flatland-association/flatland-benchmarks/commit/4bec0ac6e1b253552b35cf519d400c62c95a63d7))
* distinguish field name and description at benchmark/test/scenario level. ([0979284](https://github.com/flatland-association/flatland-benchmarks/commit/09792840712c23992915cad0452cd4880132e467))
* fix test ids in cards importer. ([ba0bf80](https://github.com/flatland-association/flatland-benchmarks/commit/ba0bf802829571c2efb43fb85aa0d99ad7e84581))
* **frontend:** Add breadcrumbs name resolver ([#405](https://github.com/flatland-association/flatland-benchmarks/issues/405)) ([2b4efd9](https://github.com/flatland-association/flatland-benchmarks/commit/2b4efd9e1329e336cb7ef58b2687b62b64f7cfd3))
* **frontend:** Unify benchmark group flow ([#400](https://github.com/flatland-association/flatland-benchmarks/issues/400)) ([1560109](https://github.com/flatland-association/flatland-benchmarks/commit/156010950d1798ff9a4571627875d5064e2cd6d7))
* **frontent:** Generalize routing ([#412](https://github.com/flatland-association/flatland-benchmarks/issues/412)) ([8b2a78f](https://github.com/flatland-association/flatland-benchmarks/commit/8b2a78fd4f47a0422683426c6252b60bdca08816))
* gen ai4realnet orchestrator code. ([8111046](https://github.com/flatland-association/flatland-benchmarks/commit/81110463813cfeed83c89f04b03c340118ff4ea1))
* KPI database cards importer. ([c88c708](https://github.com/flatland-association/flatland-benchmarks/commit/c88c708f009103aac76dad2704cf1c2650834960))
* make example sql idempotent (add ON CONFLICT to INSERT). ([fa7fb4e](https://github.com/flatland-association/flatland-benchmarks/commit/fa7fb4e59fc41838ee5e65364727593d7b6eb025))
* use domain as queue for ai4realnet. ([33cef94](https://github.com/flatland-association/flatland-benchmarks/commit/33cef94d0316e0526123ae84c0a5721e48c7104e))
* use domain as queue for ai4realnet. ([72d2d75](https://github.com/flatland-association/flatland-benchmarks/commit/72d2d759830743a332b9d90e13cc8ab4d27a7b58))
* use SUPPORTED_CLIENT_VERSION_RANGE. ([#397](https://github.com/flatland-association/flatland-benchmarks/issues/397)) ([8e61773](https://github.com/flatland-association/flatland-benchmarks/commit/8e61773f24df9d8d9cfecdf825942c10268f0ca8))


### Bug Fixes

* pass `SUPPORTED_CLIENT_VERSION_RANGE` correctly to integration tests. ([3e58b86](https://github.com/flatland-association/flatland-benchmarks/commit/3e58b8642dc24780c45038f8fea53c54b0e3a84c))
* pass SUPPORTED_CLIENT_VERSION_RANGE correctly to integration tests. ([be708d0](https://github.com/flatland-association/flatland-benchmarks/commit/be708d02e621a7cc153b6a4e744b76d7fedb6351))

## [0.11.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.10.0...v0.11.0) (2025-08-25)


### Features

* **backend:** SQL errors are now thrown ([#381](https://github.com/flatland-association/flatland-benchmarks/issues/381)) ([0faf105](https://github.com/flatland-association/flatland-benchmarks/commit/0faf10573ae39d70b4bfb1627e2bd16d434885a4))
* **frontend:** Feedback on http error response ([#376](https://github.com/flatland-association/flatland-benchmarks/issues/376)) ([602fdb8](https://github.com/flatland-association/flatland-benchmarks/commit/602fdb88f43277495188fce616f429fb3758fe6b))
* **frontend:** Show user menu ([#369](https://github.com/flatland-association/flatland-benchmarks/issues/369)) ([871fbb0](https://github.com/flatland-association/flatland-benchmarks/commit/871fbb03140561d936ae2596a69b203a110bcbfc))
* **frontend:** Start login flow on 401 response ([#373](https://github.com/flatland-association/flatland-benchmarks/issues/373)) ([6b44618](https://github.com/flatland-association/flatland-benchmarks/commit/6b446188fa17cc6770522b6f91f92083f1fae1b6))


### Bug Fixes

* **frontend:** Table not showing primary scorings ([#378](https://github.com/flatland-association/flatland-benchmarks/issues/378)) ([55172ed](https://github.com/flatland-association/flatland-benchmarks/commit/55172edcd8887b4c892e8d116638bee92a267de2))

## [0.10.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.9.3...v0.10.0) (2025-08-18)


### Features

* **backend:** Aggregate benchmark score with campaign fields in campaign setting ([#360](https://github.com/flatland-association/flatland-benchmarks/issues/360)) ([52a1b16](https://github.com/flatland-association/flatland-benchmarks/commit/52a1b16a8503ebc1226982618e3afdf29217e380))


### Bug Fixes

* add new supported client version for f3 benchmarks. ([851528f](https://github.com/flatland-association/flatland-benchmarks/commit/851528f94a717a4e0755774aa98b6de38c3e8699))
* add new supported client version for f3 benchmarks. ([1529a12](https://github.com/flatland-association/flatland-benchmarks/commit/1529a120bb06b0ef586df3b9040ad3bab649b605))
* **backend:** Logger: preserve error messages ([#367](https://github.com/flatland-association/flatland-benchmarks/issues/367)) ([09e0568](https://github.com/flatland-association/flatland-benchmarks/commit/09e056892a2cce4a8a8fa23e4af2811969dcf7a1))

## [0.9.3](https://github.com/flatland-association/flatland-benchmarks/compare/v0.9.2...v0.9.3) (2025-07-05)


### Miscellaneous Chores

* release 0.9.3 ([d537d2d](https://github.com/flatland-association/flatland-benchmarks/commit/d537d2dc8a0d162491306bc277a771e31d239308))

## [0.9.2](https://github.com/flatland-association/flatland-benchmarks/compare/v0.9.1...v0.9.2) (2025-07-05)


### Build System

* fix version injection. ([#331](https://github.com/flatland-association/flatland-benchmarks/issues/331)) ([b07d288](https://github.com/flatland-association/flatland-benchmarks/commit/b07d288075f9d1ab76ba1aec24fa2f1956319338))

## [0.9.1](https://github.com/flatland-association/flatland-benchmarks/compare/v0.9.0...v0.9.1) (2025-07-05)


### ops

* allow args in entrypoint for fab backend. ([#329](https://github.com/flatland-association/flatland-benchmarks/issues/329)) ([22f8b50](https://github.com/flatland-association/flatland-benchmarks/commit/22f8b5099ff681c474685b36e28f473cfad115ec))

## [0.9.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.9...v0.9.0) (2025-07-04)


### Features

* **frontend:** Add top-level my-submission view linking to vc submissions ([#325](https://github.com/flatland-association/flatland-benchmarks/issues/325)) ([df0118f](https://github.com/flatland-association/flatland-benchmarks/commit/df0118fb4b799cde592373452b0d8abfe07ddcc4))
* **frontend:** Display submission status ([#322](https://github.com/flatland-association/flatland-benchmarks/issues/322)) ([a0bd50f](https://github.com/flatland-association/flatland-benchmarks/commit/a0bd50f5b8719cc39c2362249786919741525e6b))
* **frontend:** Manual results upload ([#324](https://github.com/flatland-association/flatland-benchmarks/issues/324)) ([eac7078](https://github.com/flatland-association/flatland-benchmarks/commit/eac707893b5b5f49a51d45f3aa404e9d7f216b31))
* Submission details ([#319](https://github.com/flatland-association/flatland-benchmarks/issues/319)) ([a8ae003](https://github.com/flatland-association/flatland-benchmarks/commit/a8ae003e9d733f7506f0608d033ea7910c3c5ba7))

## [0.8.9](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.8...v0.8.9) (2025-07-03)


### Miscellaneous Chores

* release 0.8.9 ([ea08f9a](https://github.com/flatland-association/flatland-benchmarks/commit/ea08f9afdfb48d688a1fc48d70c5e4450ad45a5e))

## [0.8.8](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.7...v0.8.8) (2025-07-03)


### Features

* **backend:** publish submissions endpoint and test. ([8dd8576](https://github.com/flatland-association/flatland-benchmarks/commit/8dd85767082ee0f8569a21981ea3455e7dd02c26))
* Benchmark group (Validation Campaign) ([#310](https://github.com/flatland-association/flatland-benchmarks/issues/310)) ([28c3329](https://github.com/flatland-association/flatland-benchmarks/commit/28c332970136786669b6db44e8908268d8137c99))
* Offline loop submission (UI and backend) ([74589cc](https://github.com/flatland-association/flatland-benchmarks/commit/74589cc756952b5a70b0c1fe3c3383d447fb977e))


### Bug Fixes

* return 201 created upon posting submission. ([c95642d](https://github.com/flatland-association/flatland-benchmarks/commit/c95642d9728b221baf26b97e57ec388a74b85521))


### Miscellaneous Chores

* release 0.8.8 ([b07f7bb](https://github.com/flatland-association/flatland-benchmarks/commit/b07f7bb002a7eb9453a8fd87796ef87bd2ca9f92))

## [0.8.7](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.6...v0.8.7) (2025-06-30)


### Features

* Add AI4REALNET example ([#280](https://github.com/flatland-association/flatland-benchmarks/issues/280)) ([222399f](https://github.com/flatland-association/flatland-benchmarks/commit/222399f922ad6bf678649aed48e0cb94bfa6d7fa))
* **backend:** add configurable logger ([#147](https://github.com/flatland-association/flatland-benchmarks/issues/147)) ([e8a3b64](https://github.com/flatland-association/flatland-benchmarks/commit/e8a3b645b6e0ab52e8c06c83a82e3b62a8b0b420))
* **backend:** Bootstrap results aggregation ([#213](https://github.com/flatland-association/flatland-benchmarks/issues/213)) ([136be30](https://github.com/flatland-association/flatland-benchmarks/commit/136be30a5c8dca2fafadad98ec45734f377d0af0))
* **backend:** Bootstrap Swagger UI ([#212](https://github.com/flatland-association/flatland-benchmarks/issues/212)) ([0e94bdc](https://github.com/flatland-association/flatland-benchmarks/commit/0e94bdc1a08ae6986f73e3b8ffa759dfc4f7d576))
* **backend:** fetch results from s3 ([#199](https://github.com/flatland-association/flatland-benchmarks/issues/199)) ([7839d98](https://github.com/flatland-association/flatland-benchmarks/commit/7839d982f327e0ff3d9d32c5c4a6c8d382daba6c))
* **backend:** Results report aggregated ([#222](https://github.com/flatland-association/flatland-benchmarks/issues/222)) ([e4f4283](https://github.com/flatland-association/flatland-benchmarks/commit/e4f42839758281ffe0c60f85720279f8ce39d4b1))
* **backend:** verify aud in jwt ([b978599](https://github.com/flatland-association/flatland-benchmarks/commit/b9785996bfe502dbba68d69c1393b4a89b661307))
* Branding AI4REALNET ([2c20acd](https://github.com/flatland-association/flatland-benchmarks/commit/2c20acd25f04d680d685a276be9c2a53ade9f072))
* Enable app customization ([#252](https://github.com/flatland-association/flatland-benchmarks/issues/252)) ([e67656b](https://github.com/flatland-association/flatland-benchmarks/commit/e67656b58e4c4f2bcf2618327c2d75715b872edc))
* **frontend:** Tabular display of KPIs ([#262](https://github.com/flatland-association/flatland-benchmarks/issues/262)) ([0a8d554](https://github.com/flatland-association/flatland-benchmarks/commit/0a8d554245dd72e5989822db49ccf00721e289ea))
* logs to s3 instead of redis. ([#183](https://github.com/flatland-association/flatland-benchmarks/issues/183)) ([7c12357](https://github.com/flatland-association/flatland-benchmarks/commit/7c12357926d4f53158c6d009ff2dc21fe94b9566))
* Run submission in orchestrator. ([b700f2d](https://github.com/flatland-association/flatland-benchmarks/commit/b700f2d494d2910dfb89b1e04dc342638901e847))


### Bug Fixes

* environment.yml for flatland-rl==4.0.4. Workaround can be removed with flatland==4.0.5. ([#163](https://github.com/flatland-association/flatland-benchmarks/issues/163)) ([69710a3](https://github.com/flatland-association/flatland-benchmarks/commit/69710a37dfeaa5263b6a2de2eeea9e6e58340b41))
* evaluate default value for Docker image tag when triggered by push on main. ([#146](https://github.com/flatland-association/flatland-benchmarks/issues/146)) ([885a3ee](https://github.com/flatland-association/flatland-benchmarks/commit/885a3eee6f39faf58e27658df3efebf32ec45a31))
* Fix missing descriptions ([94f7116](https://github.com/flatland-association/flatland-benchmarks/commit/94f71163d64fd94b6a0c62ade7ca5b60779a0fb1))
* **frontend:** build fails ([#220](https://github.com/flatland-association/flatland-benchmarks/issues/220)) ([fa7c36d](https://github.com/flatland-association/flatland-benchmarks/commit/fa7c36dbf6df6963e2f6a5d0b2570952034425bf))
* license SPDX Identifier enforced since 7.14.0 of openapi-generator. ([#271](https://github.com/flatland-association/flatland-benchmarks/issues/271)) ([2a7dddf](https://github.com/flatland-association/flatland-benchmarks/commit/2a7dddf80bb110313cfa49e94fd694b32a452279))


### Miscellaneous Chores

* release 0.4.2 ([#151](https://github.com/flatland-association/flatland-benchmarks/issues/151)) ([b8f6ae3](https://github.com/flatland-association/flatland-benchmarks/commit/b8f6ae3ab48ba7b7caaa0413d21f536e62b5b52c))
* release 0.8.1 ([c69d96c](https://github.com/flatland-association/flatland-benchmarks/commit/c69d96ca51a1f2aff2caa867342b601f391ae8a3))
* release 0.8.1 ([cfb6ea0](https://github.com/flatland-association/flatland-benchmarks/commit/cfb6ea0d97e2bfbe0c59b4062d65caeaa83fc1cf))
* release 0.8.2 ([c752f0f](https://github.com/flatland-association/flatland-benchmarks/commit/c752f0f31eaa95ba82e7ad695c9ae9fcd0b3e9b9))
* release 0.8.3 ([96c0518](https://github.com/flatland-association/flatland-benchmarks/commit/96c0518e4cdedb93866ba147a4008ce4ae21b56a))
* release 0.8.4 ([cbdab77](https://github.com/flatland-association/flatland-benchmarks/commit/cbdab778795bb68d1f6fac5a223a3ed9e31d7c6c))
* release 0.8.5 ([d7aad1e](https://github.com/flatland-association/flatland-benchmarks/commit/d7aad1e657ca0d4926da9ca32112aa05f072cd73))
* release 0.8.6 ([46eb35a](https://github.com/flatland-association/flatland-benchmarks/commit/46eb35ac821adea6d56151b181053cd0fbc6b2c5))
* release 0.8.7 ([361ed7a](https://github.com/flatland-association/flatland-benchmarks/commit/361ed7a1619b9895b42eb77dc6fe14c13812d679))


### Continuous Integration

* fix typo int image tag. ([#155](https://github.com/flatland-association/flatland-benchmarks/issues/155)) ([6009201](https://github.com/flatland-association/flatland-benchmarks/commit/600920116b1e5b4b753e372604fb53876e670b89))
* inline image build jobs instead of triggering workflows from release-please workflow. ([#153](https://github.com/flatland-association/flatland-benchmarks/issues/153)) ([4b38913](https://github.com/flatland-association/flatland-benchmarks/commit/4b389137dcd9dc2e539710c23479755ef5bb0d9e))

## [0.8.6](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.5...v0.8.6) (2025-06-30)


### Miscellaneous Chores

* release 0.8.6 ([46eb35a](https://github.com/flatland-association/flatland-benchmarks/commit/46eb35ac821adea6d56151b181053cd0fbc6b2c5))

## [0.8.5](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.4...v0.8.5) (2025-06-30)


### Miscellaneous Chores

* release 0.8.5 ([d7aad1e](https://github.com/flatland-association/flatland-benchmarks/commit/d7aad1e657ca0d4926da9ca32112aa05f072cd73))

## [0.8.4](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.3...v0.8.4) (2025-06-30)


### Features

* Branding AI4REALNET ([2c20acd](https://github.com/flatland-association/flatland-benchmarks/commit/2c20acd25f04d680d685a276be9c2a53ade9f072))


### Miscellaneous Chores

* release 0.8.4 ([cbdab77](https://github.com/flatland-association/flatland-benchmarks/commit/cbdab778795bb68d1f6fac5a223a3ed9e31d7c6c))

## [0.8.3](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.2...v0.8.3) (2025-06-30)


### Miscellaneous Chores

* release 0.8.3 ([96c0518](https://github.com/flatland-association/flatland-benchmarks/commit/96c0518e4cdedb93866ba147a4008ce4ae21b56a))

## [0.8.2](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.1...v0.8.2) (2025-06-27)


### Miscellaneous Chores

* release 0.8.2 ([c752f0f](https://github.com/flatland-association/flatland-benchmarks/commit/c752f0f31eaa95ba82e7ad695c9ae9fcd0b3e9b9))

## [0.8.1](https://github.com/flatland-association/flatland-benchmarks/compare/v0.8.0...v0.8.1) (2025-06-27)


### Miscellaneous Chores

* release 0.8.1 ([c69d96c](https://github.com/flatland-association/flatland-benchmarks/commit/c69d96ca51a1f2aff2caa867342b601f391ae8a3))
* release 0.8.1 ([cfb6ea0](https://github.com/flatland-association/flatland-benchmarks/commit/cfb6ea0d97e2bfbe0c59b4062d65caeaa83fc1cf))

## [0.8.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.7.1...v0.8.0) (2025-06-27)


### Features

* Add AI4REALNET example ([#280](https://github.com/flatland-association/flatland-benchmarks/issues/280)) ([222399f](https://github.com/flatland-association/flatland-benchmarks/commit/222399f922ad6bf678649aed48e0cb94bfa6d7fa))
* Enable app customization ([#252](https://github.com/flatland-association/flatland-benchmarks/issues/252)) ([e67656b](https://github.com/flatland-association/flatland-benchmarks/commit/e67656b58e4c4f2bcf2618327c2d75715b872edc))
* **frontend:** Tabular display of KPIs ([#262](https://github.com/flatland-association/flatland-benchmarks/issues/262)) ([0a8d554](https://github.com/flatland-association/flatland-benchmarks/commit/0a8d554245dd72e5989822db49ccf00721e289ea))
* Run submission in orchestrator. ([b700f2d](https://github.com/flatland-association/flatland-benchmarks/commit/b700f2d494d2910dfb89b1e04dc342638901e847))


### Bug Fixes

* license SPDX Identifier enforced since 7.14.0 of openapi-generator. ([#271](https://github.com/flatland-association/flatland-benchmarks/issues/271)) ([2a7dddf](https://github.com/flatland-association/flatland-benchmarks/commit/2a7dddf80bb110313cfa49e94fd694b32a452279))

## [0.7.1](https://github.com/flatland-association/flatland-benchmarks/compare/v0.7.0...v0.7.1) (2025-06-23)


### Bug Fixes

* Fix missing descriptions ([94f7116](https://github.com/flatland-association/flatland-benchmarks/commit/94f71163d64fd94b6a0c62ade7ca5b60779a0fb1))

## [0.7.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.6.0...v0.7.0) (2025-06-11)


### Features

* **backend:** Bootstrap results aggregation ([#213](https://github.com/flatland-association/flatland-benchmarks/issues/213)) ([136be30](https://github.com/flatland-association/flatland-benchmarks/commit/136be30a5c8dca2fafadad98ec45734f377d0af0))
* **backend:** Bootstrap Swagger UI ([#212](https://github.com/flatland-association/flatland-benchmarks/issues/212)) ([0e94bdc](https://github.com/flatland-association/flatland-benchmarks/commit/0e94bdc1a08ae6986f73e3b8ffa759dfc4f7d576))
* **backend:** fetch results from s3 ([#199](https://github.com/flatland-association/flatland-benchmarks/issues/199)) ([7839d98](https://github.com/flatland-association/flatland-benchmarks/commit/7839d982f327e0ff3d9d32c5c4a6c8d382daba6c))
* **backend:** Results report aggregated ([#222](https://github.com/flatland-association/flatland-benchmarks/issues/222)) ([e4f4283](https://github.com/flatland-association/flatland-benchmarks/commit/e4f42839758281ffe0c60f85720279f8ce39d4b1))


### Bug Fixes

* **frontend:** build fails ([#220](https://github.com/flatland-association/flatland-benchmarks/issues/220)) ([fa7c36d](https://github.com/flatland-association/flatland-benchmarks/commit/fa7c36dbf6df6963e2f6a5d0b2570952034425bf))

## [0.6.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.5.0...v0.6.0) (2025-04-28)


### Features

* **backend:** verify aud in jwt ([b978599](https://github.com/flatland-association/flatland-benchmarks/commit/b9785996bfe502dbba68d69c1393b4a89b661307))
* logs to s3 instead of redis. ([#183](https://github.com/flatland-association/flatland-benchmarks/issues/183)) ([7c12357](https://github.com/flatland-association/flatland-benchmarks/commit/7c12357926d4f53158c6d009ff2dc21fe94b9566))

## [0.5.0](https://github.com/flatland-association/flatland-benchmarks/compare/v0.4.4...v0.5.0) (2025-02-21)


### Features

* **backend:** add configurable logger ([#147](https://github.com/flatland-association/flatland-benchmarks/issues/147)) ([e8a3b64](https://github.com/flatland-association/flatland-benchmarks/commit/e8a3b645b6e0ab52e8c06c83a82e3b62a8b0b420))


### Bug Fixes

* environment.yml for flatland-rl==4.0.4. Workaround can be removed with flatland==4.0.5. ([#163](https://github.com/flatland-association/flatland-benchmarks/issues/163)) ([69710a3](https://github.com/flatland-association/flatland-benchmarks/commit/69710a37dfeaa5263b6a2de2eeea9e6e58340b41))

## [0.4.4](https://github.com/flatland-association/flatland-benchmarks/compare/v0.4.3...v0.4.4) (2025-02-14)


### Continuous Integration

* fix typo int image tag. ([#155](https://github.com/flatland-association/flatland-benchmarks/issues/155)) ([6009201](https://github.com/flatland-association/flatland-benchmarks/commit/600920116b1e5b4b753e372604fb53876e670b89))

## [0.4.3](https://github.com/flatland-association/flatland-benchmarks/compare/v0.4.2...v0.4.3) (2025-02-14)


### Continuous Integration

* inline image build jobs instead of triggering workflows from release-please workflow. ([#153](https://github.com/flatland-association/flatland-benchmarks/issues/153)) ([4b38913](https://github.com/flatland-association/flatland-benchmarks/commit/4b389137dcd9dc2e539710c23479755ef5bb0d9e))

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
* [Added] #65 Pass `output.csv` and `output.json`: `evaluator` -> `orchestrator` -> `redis` (-> `backend`) by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/68
* [Added] #40 k8s compute worker implementation by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/83
* [Changed] Use gh releases for changelog keeping. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/85
* [Changed] #46 Use non-super-user to run compute worker. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/72
* [Added] #6 Keycloak authentication integration frontend by @Holzchopf in https://github.com/flatland-association/flatland-benchmarks/pull/76
* [Fix] Fix broken link to ci badge. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/89
* [Fixed] Fix missing `pandas` dependency in compute worker. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/90
* [Fixed] Fix compute worker: env var mismatch for redis. Fix missing file. Add config options for evaluator. by @chenkins in https://github.com/flatland-association/flatland-benchmarks/pull/91

## New Contributors

* @Holzchopf made their first contribution in https://github.com/flatland-association/flatland-benchmarks/pull/17
