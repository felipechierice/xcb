#!/bin/sh

REPO=https://github.com/felipechierice/xcb.git
DESTINATION=${1:-$HOME/.local/bin}

git clone $REPO tmp

mkdir -p $DESTINATION
cp tmp/xcb.sh $DESTINATION/xcb
chmod +x $DESTINATION/xcb

rm -rf tmp

printf "\nSuccessfully installed xcb at $DESTINATION"

