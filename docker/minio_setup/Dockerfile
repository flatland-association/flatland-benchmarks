# The MinIO images are no longer publicly pullable from quay.io or Docker Hub, see
# https://github.com/shift7-ch/katta-compose/issues/22, and the binaries are no longer available from
# dl.min.io (410 Gone). The release assets of mc on GitHub are still published.
FROM ubuntu:24.04
ARG MC_VERSION=RELEASE.2025-08-13T08-35-41Z
ARG TARGETARCH
# Digests of mc.linux-amd64 and mc.linux-arm64, see
# https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-<arch>.${MC_VERSION}.sha256sum
ARG MC_SHA256_amd64=01f866e9c5f9b87c2b09116fa5d7c06695b106242d829a8bb32990c00312e891
ARG MC_SHA256_arm64=14c8c9616cfce4636add161304353244e8de383b2e2752c0e9dad01d4c27c12c
RUN apt-get update && apt-get install -y wget curl nginx systemctl jq gettext-base && \
    systemctl start nginx
RUN curl -fsSL -o /mc "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-${TARGETARCH}.${MC_VERSION}" && \
    eval "expected=\$MC_SHA256_${TARGETARCH}" && \
    echo "$expected  /mc" | sha256sum -c && \
    chmod +x /mc

ENTRYPOINT ["/mc"]
