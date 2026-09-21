# Theme Keycloakify

Este diretório deve conter um projeto gerado pelo Keycloakify. O build precisa
produzir um JAR em `dist_keycloak/`, que será incluído na imagem customizada.

Para criar o projeto inicial:

```bash
cd keycloak/image/theme
npm create keycloakify@latest
```

Depois, construa o theme:

```bash
npm install
npm run build
```

O JAR final ficará em `dist_keycloak/`.