#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/sdl.version" )"
FLAGS="$( cat "$DIR/sdl.flags" )"
NAME="SDL2-$VERSION"

curl "http://libsdl.org/release/$NAME.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

if [ $PLATFORM = android ]; then
	patch -p1 -d "$NAME" -i "$DIR/sdl-no-gl-default.patch"
	FLAGS="$FLAGS -DSDL_STATIC=OFF"
else
	if [[ ( $PLATFORM = native && "$(uname)" = "Darwin" ) || $PLATFORM = ios ]]; then
		patch -p1 -d "$NAME" -i "$DIR/sdl-mac-packaging.patch"
		patch -p1 -d "$NAME" -i "$DIR/sdl-no-gl-default.patch"
	fi
	FLAGS="$FLAGS -DSDL_SHARED=OFF"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
