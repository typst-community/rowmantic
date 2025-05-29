#/bin/bash
# bad script for local install

set -ex
PKG_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local
mkdir -p "$PKG_DIR"

V=$1
test -n "$V" || (echo must have a version! && exit 1)

PKG=$(basename $(readlink -f .))

VDIR="$PKG_DIR"/"$PKG"/"$V"
mkdir -p "$VDIR"
cp -vr typst.toml src "$VDIR"/
