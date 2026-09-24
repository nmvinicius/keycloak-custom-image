# Keycloak custom image: tema Keycloakify + keycloak-redis-cache (datastore Redis/Valkey).
#
# O keycloak-redis-cache (alpha, https://github.com/p2-inc/keycloak-redis-cache)
# usa Jedis. O fat jar (Jedis/commons-pool2/redis-authx embutidos via maven-shade)
# é compilado no primeiro estágio a partir do repositório, pinado em REDIS_CACHE_REF,
# e copiado para /opt/keycloak/providers no estágio final.
ARG KEYCLOAK_VERSION=26.7.4
ARG REDIS_CACHE_REF=fe7b735731a188119546cae695efd302fe030c53

# --- estágio 1: build do fat jar da extensão ---
FROM maven:3.9-eclipse-temurin-21 AS redis-cache-build
ARG REDIS_CACHE_REF
RUN apt-get update && apt-get install --yes --no-install-recommends git \
  && git clone https://github.com/p2-inc/keycloak-redis-cache.git /src \
  && git -C /src checkout "$REDIS_CACHE_REF"
WORKDIR /src
RUN mvn -q -DskipTests package

# --- estágio 2: imagem Keycloak ---
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

USER root
COPY --chmod=755 entrypoint.sh /usr/local/bin/keycloak-runtime-entrypoint
COPY --from=redis-cache-build /src/target/keycloak-redis-*-withdeps.jar /opt/keycloak/providers/
COPY theme/dist_keycloak/*.jar /opt/keycloak/providers/
RUN mkdir -p /runtime-extensions && \
	chown -R 1000:0 /opt/keycloak /runtime-extensions
USER 1000