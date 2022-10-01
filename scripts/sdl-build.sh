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
	# Disable OpenGL on Apple platforms.
	if [[ $PLATFORM = ios || ($PLATFORM = native && $(uname -s) = Darwin) ]]; then
		FLAGS="$FLAGS -DSDL_OPENGL=OFF -DSDL_OPENGLES=OFF"
		patch -p1 -d "$NAME" -i "$DIR/sdl-mac-fix.patch"
	fi
	FLAGS="$FLAGS -DSDL_SHARED=OFF"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
