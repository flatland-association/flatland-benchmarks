### frontend

```shell
# push ci build to registry
IMAGE=fab-frontend:latest
docker pull ghcr.io/flatland-association/${IMAGE}
docker tag ghcr.io/flatland-association/${IMAGE} swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}

docker tag ghcr.io/flatland-association/fab:latest swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE} --platform  linux/amd64
```

### backend

```shell
# push ci build to registry
IMAGE=fab-backend:latest
docker pull ghcr.io/flatland-association/${IMAGE}
docker tag ghcr.io/flatland-association/${IMAGE} swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}

docker tag ghcr.io/flatland-association/fab:latest swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE} --platform  linux/amd64
```

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

