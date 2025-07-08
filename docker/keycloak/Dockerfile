# this block is required because curl isn't in the keycloak image anymore, but is needed for the Docker Compose health check.
FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs curl --releasever 9 --setopt install_weak_deps=false --nodocs -y; dnf --installroot /mnt/rootfs clean all


FROM quay.io/keycloak/keycloak:26.2.2
COPY --from=ubi-micro-build /mnt/rootfs /

WORKDIR /opt/keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
