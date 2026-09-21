#!/usr/bin/env bash
set -euo pipefail

extension_dir=/runtime-extensions

if compgen -G "$extension_dir/*" >/dev/null 2>&1; then
  cp "$extension_dir"/* /opt/keycloak/providers/
fi

/opt/keycloak/bin/kc.sh build
exec /opt/keycloak/bin/kc.sh "$@"