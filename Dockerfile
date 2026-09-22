ARG KEYCLOAK_VERSION=26.7.4
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

USER root
COPY --chmod=755 entrypoint.sh /usr/local/bin/keycloak-runtime-entrypoint
COPY theme/dist_keycloak/*.jar /opt/keycloak/providers/
RUN mkdir -p /runtime-extensions && \
	chown -R 1000:0 /opt/keycloak /runtime-extensions
USER 1000