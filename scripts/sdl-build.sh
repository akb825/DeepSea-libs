#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/sdl.version" )"
FLAGS="$( cat "$DIR/sdl.flags" )"
NAME="SDL2-$VERSION"

curl "http://libsdl.org/release/$NAME.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

patch -p1 -d "$NAME" -i "$DIR/sdl-cmake-flags.patch"

# Shared library doesn't make sense on Android.
if [ $PLATFORM = android ]; then
	FLAGS="$FLAGS -DSDL_STATIC=OFF"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
