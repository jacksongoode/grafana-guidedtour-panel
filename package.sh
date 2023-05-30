#!/bin/bash
# This file is used to package the dist folder for Grafana Cloud
set -e
if [ -z "$1" ]; then
	# Local
	tag=$(git describe --abbrev=0)
	export $(xargs <keys.env)
else
	# When Actions pass in tag
	tag="$1"
fi
echo "Packaging $tag"

rm -rf dist
yarn install && yarn build && npx @grafana/sign-plugin@latest --rootUrls http://localhost:3000

cp -r dist grafana-guidedtour-panel
zip -r grafana-guidedtour-panel.zip grafana-guidedtour-panel
mv grafana-guidedtour-panel.zip grafana-guidedtour-panel-"${tag}".zip
if ! [ -x "$(command -v md5)" ]; then
	md5sum grafana-guidedtour-panel-"${tag}".zip >grafana-guidedtour-panel-"${tag}".zip.md5
else
	md5 grafana-guidedtour-panel-"${tag}".zip >grafana-guidedtour-panel-"${tag}".zip.md5
fi
rm -rf grafana-guidedtour-panel
