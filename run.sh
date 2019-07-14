#!/usr/local/bin/dumb-init /bin/bash
set -euo pipefail

SECRET_KEY=${SECRET_KEY:-}
[[ -n ${SECRET_KEY} ]] || {
	SECRET_KEY=$(openssl rand -hex 32)
	echo "Attention: Secret key was auto-generated! You should"
	echo "set it via SECRET_KEY env var to keep it persistent"
}

[[ -z ${BASE_URL:-} ]] || {
	sed -i "s@base_url : False@base_url : '${BASE_URL}'@" searx/settings.yml
}

sed -i "s/secret_key : \"ultrasecretkey\"/secret_key : '${SECRET_KEY}'/" searx/settings.yml

exec python searx/webapp.py
