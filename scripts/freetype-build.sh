#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/freetype.version" )"
FLAGS="$( cat "$DIR/freetype.flags" )"
NAME="freetype-$VERSION"

curl -L "https://download.savannah.gnu.org/releases/freetype/$NAME.tar.xz" \
	--output "$NAME.tar.xz"
tar xJf "$NAME.tar.xz"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
