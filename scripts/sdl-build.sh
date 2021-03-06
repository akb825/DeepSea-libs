#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/sdl.version" )"
FLAGS="$( cat "$DIR/sdl.flags" )"
NAME="SDL2-$VERSION"

curl "http://libsdl.org/release/$NAME.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

if [ $PLATFORM = android ]; then
	FLAGS="$FLAGS -DSDL_STATIC=OFF"
else
	if [ $PLATFORM = ios ]; then
		patch -p1 -d "$NAME" -i "$DIR/sdl-ios-fix.patch"
		# No OpenGL for iOS
		FLAGS="$FLAGS -DVIDEO_OPENGL=OFF -DVIDEO_OPENGLES=OFF"
	fi
	FLAGS="$FLAGS -DSDL_SHARED=OFF"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
