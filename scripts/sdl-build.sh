#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/sdl.version" )"
FLAGS="$( cat "$DIR/sdl.flags" )"
NAME="SDL3-$VERSION"

curl "https://libsdl.org/release/$NAME.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

# Disable OpenGL on Apple platforms.
if [[ $PLATFORM = ios || ($PLATFORM = native && $(uname -s) = Darwin) ]]; then
	FLAGS="$FLAGS -DSDL_OPENGL=OFF -DSDL_OPENGLES=OFF"
fi

# Need shared library for Android, use static for other platforms.
if [ $PLATFORM = android ]; then
	FLAGS="$FLAGS -DBUILD_SHARED_LIBS=ON"
else
	FLAGS="$FLAGS -DBUILD_SHARED_LIBS=OFF"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
