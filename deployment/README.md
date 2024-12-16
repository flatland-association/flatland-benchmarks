### frontend

```shell
docker build -f deployment/frontend/Dockerfile -t benchmarking-fronentend .
docker run -p 4200:4200 benchmarking-frontend
```

### backend

```shell
docker build -f deployment/backend/Dockerfile -t benchmarking-backend .
docker run -p 8000:8000 benchmarking-backend
```

TODO mount config.json
