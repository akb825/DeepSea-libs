#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/freetype.version" )"
FLAGS="$( cat "$DIR/freetype.flags" )"
NAME="freetype-$VERSION"

curl -L "https://download.savannah.gnu.org/releases/freetype/$NAME.tar.bz2" \
	--output "$NAME.tar.bz2"
tar xjf "$NAME.tar.bz2"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
