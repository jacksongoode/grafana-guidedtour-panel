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

cp -r dist nline-guidedtour-panel
zip -r nline-guidedtour-panel.zip nline-guidedtour-panel
mv nline-guidedtour-panel.zip nline-guidedtour-panel-"${tag}".zip
if ! [ -x "$(command -v md5)" ]; then
	md5sum nline-guidedtour-panel-"${tag}".zip >nline-guidedtour-panel-"${tag}".zip.md5
else
	md5 nline-guidedtour-panel-"${tag}".zip >nline-guidedtour-panel-"${tag}".zip.md5
fi
rm -rf nline-guidedtour-panel
