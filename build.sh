#!/bin/bash
set -euxo pipefail

build_packages=(
	curl
	git
	build-base
	libffi-dev
	libxml2-dev
	libxslt-dev
	openssl-dev
)

dep_packages=(
	libffi
	libxml2
	libxslt
	openssl
)

apk --no-cache add "${build_packages[@]}" "${dep_packages[@]}"

curl -sSfLo /usr/local/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64"
chmod +x /usr/local/bin/dumb-init

mkdir -p "$(dirname "${INSTALL_DIR}")"
git clone "https://github.com/asciimoo/searx.git" "${INSTALL_DIR}"

pushd "${INSTALL_DIR}"

git reset --hard "${VERSION}"
git clean -fdx
sh manage.sh update_packages

sed -i 's/bind_address : "127.0.0.1"/bind_address : "0.0.0.0"/' searx/settings.yml

popd

apk --no-cache del "${build_packages[@]}"
