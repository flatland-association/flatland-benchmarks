# The MinIO images are no longer publicly pullable from quay.io or Docker Hub, see
# https://github.com/shift7-ch/katta-compose/issues/22. alpine/minio republishes the last community
# release; the binaries are no longer available from dl.min.io (410 Gone) either.
FROM alpine/minio:RELEASE.2025-10-15T17-29-55Z@sha256:cf23643a6cf9ce159c57643ceb88279e431262282428c9e0bf3a7ef1a97e84b4 AS minio

FROM ubuntu:24.04
COPY --from=minio /usr/local/bin/minio /minio
RUN apt-get update && apt-get install -y wget curl nginx systemctl gettext-base && \
    systemctl enable nginx.service

ENTRYPOINT ["/minio"]
