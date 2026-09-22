# Keycloak custom image

Imagem para o Keycloak Operator. O JAR gerado pelo Keycloakify é construído e
embutido em `/opt/keycloak/providers`. No pod, um `initContainer` ainda pode
copiar JARs pequenos fornecidos por ConfigMap/Secret para extensões adicionais;
`entrypoint.sh` executa `kc.sh build` antes de iniciar o servidor.

## Build local

```bash
./build-image.sh ghcr.io/SEU_USUARIO/keycloak-custom-image:dev
```

## Publicação

O workflow `build.yml` publica no GHCR quando há push em `main` e assina a
imagem com Cosign usando a identidade OIDC do GitHub Actions. Não há chave
privada para guardar: a assinatura keyless fica registrada no Fulcio/Rekor.

Para verificar uma imagem publicada:

```bash
cosign verify ghcr.io/SEU_USUARIO/keycloak-custom-image:latest \
  --certificate-identity-regexp 'https://github.com/nmvinicius/keycloak-custom-image/.github/workflows/build.yml@refs/heads/main' \
  --certificate-oidc-issuer 'https://token.actions.githubusercontent.com'
```

## Atualizações do Keycloak

`check-upstream.yml` consulta diariamente as tags estáveis `26.x` do
`quay.io/keycloak/keycloak`. Quando encontra uma versão mais nova, abre um PR
alterando `KEYCLOAK_VERSION` no Dockerfile. O workflow de build roda nesse PR;
após a revisão e o merge, a nova imagem é publicada e assinada.

Atualizações de major ficam bloqueadas de propósito. Para migrar de 26 para
27, altere `KEYCLOAK_MAJOR` no workflow e revise as notas de migração antes de
aceitar o PR.