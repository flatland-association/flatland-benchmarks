### Local multi-platform build/run

```shell
# local multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -f deployment/frontend/Dockerfile -t benchmarking-frontend .

# local run
docker run --rm -p 80:80 benchmarking-frontend
```

```shell
# local build
docker buildx build -f deployment/backend/Dockerfile -t benchmarking-backend .

# start services container
docker compose -f evaluation/docker-compose-isolated-services.yml up -d

# start backend container 
# - use config designated for isolated services scenario
# - mount data migration from ts/backend/src
# - use same network as isolated services
docker run --rm -p 8000:8000 --name fab-backend --mount type=bind,src=$PWD/evaluation/config-isolated-services.jsonc,dst=/usr/src/app/dist/backend/config/config.jsonc --mount type=bind,src=$PWD/ts/backend/src/migration/data,dst=/flyway/sql/data --network evaluation_flatland-benchmarks -e POSTGRES_DB='benchmarks' -e POSTGRES_USER='benchmarks' -e POSTGRES_PASSWORD='benchmarks' benchmarking-backend
```

https://docs.docker.com/build/building/multi-platform/

