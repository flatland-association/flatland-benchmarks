### Local multi-platform build/run

```shell
# local multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -f deployment/frontend/Dockerfile -t benchmarking-frontend .

# local run
docker run --rm -p 80:80 benchmarking-frontend
```

```shell
# local build
docker build -f deployment/backend/Dockerfile -t benchmarking-backend .

# local run
docker run -p 8000:8000 -v $PWD/ts/backend/src/config/config.json:/usr/src/app/dist/backend/config/config.json benchmarking-backend
```

https://docs.docker.com/build/building/multi-platform/

