# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FAB (Flatland Benchmarks) is a web platform for running ML benchmarks and competitions. It supports closed-loop, interactive, and offline evaluation. The stack is:

- **Backend:** Node.js + Express (TypeScript/ESM), PostgreSQL, Keycloak (OIDC), RabbitMQ + Celery (evaluation workers), MinIO (S3 storage), Flyway (migrations)
- **Frontend:** Angular 21, TailwindCSS, Cypress (E2E)
- **Layout:** `ts/backend`, `ts/frontend`, `ts/common` are separate npm packages under `ts/` (not npm workspaces — `ts/common` is shared purely via TypeScript path aliases, `@common/*` → `../common/*`, configured per-project in each `tsconfig*.json`). `ts/backend/package.json` and `ts/frontend/package.json` declare no `dependencies`/`devDependencies` of their own — every actual npm package (Angular, Express, everything) is declared once in the root `package.json`, and both subprojects are script-only wrappers that resolve it via Node's upward `node_modules` lookup to the repo root. `npm ci`/`npm install` is therefore only ever run at the repo root, never inside `ts/backend` or `ts/frontend`.

Deeper docs live in `docs/`: [ARCHITECTURE.md](docs/ARCHITECTURE.md) (design decisions, ER/data model diagrams), [DEVELOPMENT.md](docs/DEVELOPMENT.md) (API conventions `dev.001`–`dev.005`, referenced directly from code comments), [USER_GUIDE.md](docs/USER_GUIDE.md), [ADMINISTRATION.md](docs/ADMINISTRATION.md), [CONTRIBUTING.md](docs/CONTRIBUTING.md).

## First-time setup

```bash
npm ci   # from repo root
# clone the orchestrator repo needed to run evaluation integration tests:
git clone https://github.com/flatland-association/ai4realnet-orchestrators.git evaluation/ai4realnet_orchestrators
```

`evaluation/ai4realnet_orchestrators` is gitignored — it's an external repo, not part of this codebase. Domain orchestrators (`railway`, `atm`, `power_grid`, `energy`) live inside it, imported by `evaluation/flatland3_benchmarks` tests.

Pre-commit hooks (Husky + lint-staged) run `eslint --fix` on staged `*.ts`/`*.mts`/`*.html` files. If lint-staged fails, it can discard your working changes — run `git stash pop` to recover them, or run `ts/backend`'s / `ts/frontend`'s `check` script (or use the VSCode ESLint+Prettier extensions) beforehand to avoid surprises.

`.npmrc` sets `legacy-peer-deps=true` — `@flatland-association/flatland-ui@2.3.0` declares peer deps for Angular 20 but is actually used with Angular 21; remove this once that library ships an Angular 21-compatible release.

No `.nvmrc`/`engines` field pins a Node version for local dev; CI (`.github/workflows/checks.yml`) runs on Node 22.x while the production Docker images (`deployment/*/Dockerfile`) build with Node 23.5.0.

## Commands

All commands run from their respective subdirectory unless noted.

### Full stack (root)

```bash
# Quickstart — bring up all services end-to-end:
cd evaluation && docker compose -f docker-compose.yml --profile full up --wait

npm run docker:up            # Start dev services (tsdev profile)
npm run docker:down          # Stop all services (tsdev profile)
npm run docker:uptest        # Start services with test environment variables (.env + .env.test)
npm run docker:up:cvolumes   # Start dev services with custom volume mounts (.env.cvolumes + .env)
```

`docker-compose.yml` profiles: `tsdev` (Postgres, Keycloak, RabbitMQ, MinIO, Flyway — enough to run the backend/frontend locally via `npm run start.*`), `tsdevwithorchestrators` (adds real Celery orchestrator workers for the `railway` and `flatland3_benchmarks` domains, for exercising the evaluation flow end-to-end without Kubernetes), `full` (adds the containerized `fab-backend`/`fab-frontend` images, used by CI/integration tests), `debug` (adds a `minio_trace` sidecar for S3 request tracing). The `fab-backend`/`fab-frontend`/orchestrator images are built from the Dockerfiles under `deployment/` (`deployment/backend`, `deployment/frontend`, `deployment/flatland3_benchmarks/{orchestrator,evaluator}`).

Local dev loop (two terminals):

```bash
npm run docker:up
cd ts/frontend && npm run start
```

```bash
CUSTOMIZATION=fab  # or ai4realnet, realworldbaselines
cd ts/backend && npm run start.${CUSTOMIZATION}
```

### Backend (`ts/backend/`)

```bash
npm run check          # Regenerate swagger + TypeScript type-check + ESLint
npm run build          # Compile to dist/backend/
npm run start.fab      # Dev server with hot-reload (FAB customization)
npm run start.ai4realnet       # Dev server (AI4REALNET customization)
npm run start.realworldbaselines  # Dev server (RealWorldBaselines customization)

# Tests
npm run test-unit      # Unit tests only (Vitest)
npm run test           # Unit + integration tests with coverage
# Run a single test file:
npx vitest run src/app/features/services/auth-service.spec.ts
# Run integration tests without Docker setup (assumes services are already running):
npm run test-integration-no-setup
```

Backend configuration lives in `ts/backend/src/config/config.jsonc`; logging verbosity is controlled via CLI arguments. Swagger docs are generated from JSDoc comments via `swagger-jsdoc` during `check`/`start.*`/`private:serve` — a JSDoc error fails the swagger generation step (non-zero exit from `swaggererrors.txt` line count).

### Frontend (`ts/frontend/`)

```bash
npm run check          # ESLint (ng lint)
npm run build          # Angular production build
npm run start          # Dev server + unit test watch
npm run test           # Karma/Jasmine headless Chrome
npm run cypress:open   # Interactive E2E tests (requires local Docker services + Keycloak)
npm run cypress:run    # Headless Cypress run (single pass, no orchestration)
# Run full Cypress CI suite (builds, starts services/backend, runs, tears down):
node --experimental-strip-types ts/frontend/cypress/run-ci-press.mts
```

Generate Angular scaffolding with the CLI (`ng generate component`, `service`, `guard`, `pipe`, etc.).

### Evaluation integration tests (`evaluation/flatland3_benchmarks/`)

```bash
cd evaluation/flatland3_benchmarks
pytest -s test_containers_flatland_benchmarks.py
```

Each `test_containers_*.py` module shares a single `test_containers_fixture` (module-scoped). The fixture logic itself lives once in `test_common/docker_compose_fixture.py` (a repo-root module, not part of either project's own package) via `make_test_containers_fixture(context)`; each project's `conftest.py` (here and in `fab-clientlib/`, see below) is a thin wrapper that imports it and supplies its own docker-compose `context` path. It builds and brings up the full `docker-compose.yml` stack (`--profile full`), yields a `submission_id`, then dumps compose logs and tears down. A test module opts into a specific `.env.*` override file by declaring a module-level `ENV_FILE` constant (e.g. `ENV_FILE = ".env.test.percentagecomplete"`); the fixture reads it via `getattr(request.module, "ENV_FILE", None)`. Set `ATTENDED=True` to skip the docker-compose lifecycle entirely and reuse an already-running stack.

`test_common/` is resolved via `PYTHONPATH`, not a relative/package import, since `conftest.py` does a plain `from docker_compose_fixture import ...`. `.github/workflows/checks.yml` sets `PYTHONPATH` to include `test_common/` for every job step that loads either project's `conftest.py` — including plain unit-test steps that never touch docker-compose, since pytest loads the rootdir-level `conftest.py` regardless of what it's collecting. Running either project's tests locally needs the same: `PYTHONPATH=$(git rev-parse --show-toplevel)/test_common:$PYTHONPATH pytest ...`.

### CI image reuse and caching (`checks.yml`)

The docker-compose-based integration test jobs (`test-flatland3-benchmarks`, `test-clientlib`, `test-ai4realnet-orchestrator-railway`) each end up running `docker compose --profile full up --build` via a fixture that isn't ours to control on every path (either our own `test_common/docker_compose_fixture.py`, or one vendored into the external `ai4realnet-orchestrators` repo). To avoid rebuilding `fab-backend`/`fab-frontend`/the orchestrator's deps layer from scratch on every run:

- A `build-images` job builds each image once per unique relevant-source-content and pushes it as `ghcr.io/flatland-association/<image>:ci-<hash>`, where `<hash>` is `git ls-files -s -- <paths> | git hash-object --stdin` over that image's actual build inputs — recomputed identically in every consuming job, so no cross-job output-passing is needed. It's skipped on `schedule` runs (forces a real `--no-cache` rebuild instead, to catch base-image/dependency drift) and on fork PRs (no `packages: write`).
- Consuming jobs recompute the same hash, `docker pull` the tag if it exists, and drive `docker-compose.yml`'s env-var `image:`/`pull_policy:` switches (`FAB_BACKEND_IMAGE`, `FAB_BACKEND_PULL_POLICY`, etc.) so Compose reuses the pulled image instead of rebuilding; unset, these default to today's local-build behavior.
- `docker-compose.ci-cache.yml` is an additive Compose override, opted into only via the `COMPOSE_FILE` env var on specific CI steps, adding GHA buildx `cache_from`/`cache_to` for services that still build locally on the fallback path — including inside `test-ai4realnet-orchestrator-railway`'s externally-vendored fixture, which calls `DockerCompose()` with no explicit `-f` and so picks up `COMPOSE_FILE` transparently. Never applied to local dev: the `type=gha` cache backend needs `ACTIONS_CACHE_URL`/`ACTIONS_RUNTIME_TOKEN`, only present inside GH Actions runners.
- The `ai4realnet-orchestrators` repo (external, cloned per the `ai4realnet-orchestrators-ref` env var) maintains an independent, parallel copy of this same mechanism in its own `checks.yaml`, since its integration test job also builds via *our* `docker-compose.yml` (checked out as a nested `flatland-benchmarks/` dir there) — the two repos' workflow files must be kept in sync by hand.
- Python installs pinned to a floating `@main` git ref (`flatland-rl`, `fab-clientlib` in `evaluation/flatland3_benchmarks/orchestrator/requirements.txt` and the external repo's `railway/requirements.txt`) are cached as a full venv via `actions/cache`, keyed by a daily-rotating bucket (`date -u +%F`) so those refs never go stale for more than ~24h; the install step is skipped outright on an exact cache hit. `actions/setup-python`'s `cache: pip` is kept alongside as a lower-level complement, speeding up whatever `pip install` does run on a cache-miss day.
- The pinned `openapi-generator-cli==7.15.0` install (needed across `checks.yml`/`release-please.yml`/`publish-test.yml`) is deduplicated into the `.github/actions/install-openapi-generator-cli` composite action.

## Architecture

### Type-safe API contract (`ts/common/`)

`api-endpoints.ts` is the single source of truth for all HTTP endpoints. It defines every route's request body, query params, and response type. Both the backend controllers and frontend API service derive their types from this registry via the `@common/*` path alias — if the contract changes, TypeScript errors propagate to both sides.

### API conventions and frontend resource caching

Backend REST endpoints follow conventions documented as `dev.001`–`dev.005` in `docs/DEVELOPMENT.md` (referenced directly in code comments, e.g. `field.controller.mts`):

- List endpoints return only previews (URI + selected fields); full resources are fetched in follow-up requests (dev.001).
- Any endpoint returning a resource always returns an **array** in the response body, whether the request was for one ID or many (dev.002) — keeps the response shape uniform.
- `id`/`ids` path params are comma-separated and interchangeable everywhere (dev.005), backed by `WHERE id=ANY(...)` in SQL (dev.003) — a single-ID lookup costs the same as a multi-ID one.

`ts/frontend/src/app/features/resource/resource.service.ts`'s `ResourceService` is a generic client built on these conventions: `ResourceGetEndpoints` type-filters `ApiGetEndpoints` down to the array-returning (dev.002) ones, and the `resourceMeta` map configures, per endpoint, a cache TTL and which route param to treat as a comma-separated ID list to "spread" — transparently coalescing many logical resource loads (by individual ID) into few actual HTTP requests, each resolved and cached independently.

### Backend: Controller → Service pattern

**Controllers** (`ts/backend/src/app/features/controller/`) extend the base `Controller` class and register typed handlers in their constructor using `attachGet/Post/Patch(endpoint, handler, options?)`. The base class handles:

- JWT authentication (always called for every request)
- Role-based authorization (when `options.authorizedRoles` is set — enforced before the handler runs)
- Error handling (including `ControllerError` for client errors, `postgres.PostgresError` for DB constraint violations)

Handlers receive `(req, res, next, auth: JwtPayload | null)` as the fourth argument. For protected routes, `auth` is guaranteed non-null before the handler is called.

**Services** (`ts/backend/src/app/features/services/`) extend the base `Service` class and use a static singleton pattern: `AuthService.create(config)` at startup, `AuthService.getInstance()` everywhere else.

Key services:

- `SqlService` — postgres tagged-template queries
- `AuthService` — Keycloak JWT verification + `resource_access[audience].roles` authorization
- `CeleryService` — sends evaluation tasks to Python workers via RabbitMQ
- `AggregatorService` — leaderboard score calculation

### Authorization model

Roles live in the Keycloak JWT at `resource_access[audience].roles` (client-scoped, not realm-level). `AuthService.authorization(req, auth, roles)` checks this claim. The `audience` value comes from `config.keycloak.audience`. Admin users carry both `['User', 'Admin']` roles. At the API level, roles are `--` (view results), `User` (submit and upload results), `Admin` (define benchmarks — no write API for this yet; definitions are authored via CSV + Flyway migrations, see below). Posting submission results has no ownership check against the submitter (any `User` can post for any submission); posting submission status does enforce ownership, bypassable only by `Admin`.

### Domain data model

Core entities and their relationships (see `docs/ARCHITECTURE.md` for the full ER diagram):

- `suites` (validation campaigns) → `benchmarks` → `tests` → `scenarios`, each level optionally carrying its own `fields` (scoring field definitions with an `agg_func`: `SUM`/`NANSUM`/`MEAN`/`NANMEAN`/`MEDIAN`/`NANMEDIAN`).
- `submissions` reference a `benchmark` and a set of `tests`; `results` reference a `scenario`, `test`, and `submission`, keyed by a scoring `field`.
- `tests.loop` is one of `CLOSED` / `INTERACTIVE` / `OFFLINE`, matching the three evaluation loop types described below.
- `submissions.status` (in the separate `submission_statuses` log table, not a column on `submissions`) progresses `SUBMITTED` → `STARTED` → `SUCCESS`/`FAILURE`.
- The same schema serves three "setups" (`suite_setup`: `DEFAULT`/`COMPETITION`/`CAMPAIGN`) that reinterpret the nomenclature (e.g. a `benchmark` is a "Round" in `COMPETITION` setup, an "Evaluation Objective" in `CAMPAIGN` setup) — see the Nomenclature table in the root `README.md`.

### Database migrations

Flyway SQL files in `ts/backend/src/migration/schema/` (schema) and `ts/backend/src/migration/data/` (seed data, one file per customization, e.g. `V6.1__fab_example.sql`). Naming: `V{major}.{minor}__{description}.sql`. Run automatically by the `flyway` Docker service on startup.

### Benchmark/competition definitions (`definitions/`)

Per-customization benchmark definitions (suites/benchmarks/tests/scenarios/fields) are authored as CSV (e.g. `definitions/ai4realnet/KPIs_database_cards.csv`) and generated into `*_definitions.json` + `*_definitions.sql`/`V{n}.{m}__*.sql` seed-data migrations by `gen_*_benchmarks_sql.py` scripts, sharing common SQL-generation helpers in `definitions/gen_benchmarks_common.py`. One subdirectory per customization/benchmark set (`definitions/ai4realnet/`, `definitions/benchmarks/ecml2026/`, `definitions/benchmarks/flatland3_benchmarks/`). Re-run the relevant `gen_*.py` script after editing a CSV, then copy/commit the regenerated SQL into `ts/backend/src/migration/data/`.

### Customization system

The backend supports multiple deployments via `CUSTOMIZATION` env var (`fab`, `ai4realnet`, `realworldbaselines`). Each has its own config and seed data migrations. Dev servers are started per-customization: `npm run start.fab`, `npm run start.ai4realnet`, etc.

### Testing

- **Unit tests**: co-located with source as `*.spec.ts` files; use `vi.spyOn` to mock dependencies; services are instantiated directly (`new AuthService(config)`) or via `Service.create(config)`.
- **Integration tests**: `ts/backend/test/integration/`; use `ControllerTestAdapter` from `test/controller.test-adapter.mts` which spins up a real Express app with mocked `AuthService.authentication`. Test JWTs are defined there (`testUserJwt`, `testAdminJwt`, etc.).
- **Swagger**: generated from JSDoc comments on controller handlers; regenerated during `private:serve`.

## Evaluation orchestrators (`evaluation/`)

The evaluation layer sits outside the TypeScript stack. The request flow is:

```
Browser → FAB Hub (backend) → RabbitMQ → Orchestrator (Celery) → Test Runners → fab-clientlib (upload results)
```

Three evaluation loop types:

- **Closed-loop** — fully automatic (orchestrator runs submission end-to-end)
- **Interactive-loop** — partial automatic, partial human operator
- **Offline-loop** — manual result upload

Domain queues: **Railway**, **ATM**, **PowerGrid** (each has its own orchestrator in `evaluation/ai4realnet_orchestrators/`). These domain orchestrators are not Kubernetes-based — unlike `evaluation/flatland3_benchmarks/orchestrator/orchestrator.py`'s `K8sFlatlandBenchmarksOrchestrator`, which drives submissions as Kubernetes Jobs/Pods (polling `BatchV1Api`/`CoreV1Api`, subject to `active_deadline_seconds`, `wait_for_pod_to_start_limit`, `wait_for_pod_to_run_limit`), the ai4realnet domain orchestrators don't go through that pod-lifecycle machinery. `orchestrator_docker_compose.py` is a second `FlatlandBenchmarksOrchestrator` implementation for flatland3_benchmarks that drives submissions via `docker compose` instead of Kubernetes (used by the `tsdevwithorchestrators` compose profile for local dev). Celery queue/task naming (`submission.controller.mts`'s `postSubmission`): if the submission's request names exactly one test and that test row has a `queue` override set, that value is used
as the queue name (e.g. a domain name, for `CAMPAIGN`-style single-KPI submissions); otherwise the benchmark ID (UUID) is used. This is a per-test data convention, not a branch on `suite_setup`. The task name always equals the queue name (same variable passed to both `CeleryService.sendTask` parameters).

To implement a new test runner, provide: `load_submission_data`, `load_model`, `load_scenario_data`, and `run_scenario` methods. Results are uploaded via `fab-clientlib`.

> **Note:** The PowerGrid orchestrator must use Celery's solo pool (`-P solo`) due to pypowsybl process conflicts.

### Resource limits (`evaluation/flatland3_benchmarks/orchestrator/`)

`K8sFlatlandBenchmarksOrchestrator` (`orchestrator.py`) and its base class `FlatlandBenchmarksOrchestrator` (`orchestrator_common.py`) enforce several distinct, similarly-named timeouts across a submission's lifecycle — understanding any one of them requires the others for context:

- `wait_for_pod_to_start_limit` — tolerance for the just-created Job not yet being listed via `list_namespaced_job`. Pure K8s API/controller propagation latency, unrelated to image size.
- `wait_for_pod_to_run_limit` — how long the pod may stay `Pending`/`Unknown` before failing; this covers the image pull duration and is where issue #665 ("long-running pull ... start time limit") lives.
- `running_time_limit` / `total_running_time_limit` (`orchestrator_common.py`) — per-scenario and summed-across-all-scenarios caps on actual `Running`-phase time, tracked separately from pull time; exceeding either sets a `termination_cause` (a *soft* stop — results for already-completed scenarios/tests are still uploaded) rather than raising.
- `active_deadline_seconds` — a hard Kubernetes-native ceiling (`activeDeadlineSeconds` on the Pod spec) covering pull + run together, for one scenario's pod. Must stay ≥ `wait_for_pod_to_run_limit` + a full `running_time_limit` window, or a legitimately-slow-but-successful pull can survive `wait_for_pod_to_run_limit` only to have the pod killed mid-run by Kubernetes itself instead (surfacing as a job failure, not a clean `TaskExecutionError`).
- `orchestration_job_active_deadline_seconds` / `orchestration_job_k8s_resource_allocation` (`orchestration_job.py`) — the same *kind* of setting, but for the outer orchestration-job pod that drives *all* tests/scenarios for one submission, not any individual scenario's pod. Easy to conflate with the per-scenario `active_deadline_seconds`/`k8s_resource_allocation` above given the near-identical naming.

All of these are read from env vars in `orchestration_job.py` via `_require_config(...)`; only `active_deadline_seconds`/`k8s_resource_allocation`/`orchestration_job_*` have hardcoded fallback defaults in code — the per-scenario wait/running limits have none, so actual values live in the deployment's own config, not this repo.

## fab-clientlib (`fab-clientlib/`)

Auto-generated Python client library (OpenAPI Generator) for the FAB REST API. Install for local scripting/orchestration:

```bash
pip install git+https://github.com/flatland-association/flatland-benchmarks.git
```

Requires Python 3.9+. Uses OAuth2 (client credentials flow) for authentication.

To regenerate it after a backend API change: copy `ts/backend/src/swagger/swagger.json` (from a built backend) to `openapi.json`, then run

```bash
pip install openapi-generator-cli==7.15.0
openapi-generator-cli generate -i openapi.json -g python --package-name fab_clientlib
```

Its container-based integration test (`test_containers_fab_rest_api.py`) uses the same shared `test_common/docker_compose_fixture.py` fixture as `evaluation/flatland3_benchmarks/` — see that section above for how `conftest.py`/`PYTHONPATH` wiring works.

## Development conventions

- **Trunk-based development** — `main` is the trunk; feature branches are short-lived.
- **Conventional Commits** — release PRs are opened automatically by [release-please](https://github.com/googleapis/release-please) based on commit message format; this also drives version bumps.
