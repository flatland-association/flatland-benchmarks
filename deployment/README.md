### frontend

```shell
# local multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -f deployment/frontend/Dockerfile -t benchmarking-frontend .

# local run
docker run --rm -p 4200:4200 benchmarking-frontend

# push ci build to registry
IMAGE=benchmarking-frontend:latest
ocker tag ghcr.io/flatland-association/fab:latest swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE} --platform  linux/amd64
  
# push local build to registry
IMAGE=benchmarking-frontend:latest
docker tag docker.io/library/${IMAGE} swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE} --platform  linux/amd64


```

### backend

```shell
# local build
docker build -f deployment/backend/Dockerfile -t benchmarking-backend .

# local run
docker run -p 8000:8000 benchmarking-backend
```

TODO mount config.json

### References

https://docs.docker.com/build/building/multi-platform/

IMAGE=node:alpine
docker tag ${IMAGE} ghcr.io/flatland-association/${IMAGE}
docker push ghcr.io/flatland-association/${IMAGE}

https://stackoverflow.com/questions/77419401/403-forbidden-when-pushing-docker-image-to-github-registry-ghcr-io

docker pull ghcr.io/flatland-association/fab:latest
IMAGE=fab:latest
docker tag ghcr.io/flatland-association/${IMAGE} swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}

IMAGE=node:slim
docker tag ${IMAGE} swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}
docker push swr.eu-ch2.sc.otc.t-systems.com/flatland-association/${IMAGE}


