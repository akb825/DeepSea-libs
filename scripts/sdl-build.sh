#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/sdl.version" )"
FLAGS="$( cat "$DIR/sdl.flags" )"
NAME="SDL2-$VERSION"

curl "http://libsdl.org/release/$NAME.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

pushd "$NAME" > /dev/null
patch -p1 -i "$DIR/sdl-android-support.patch"
"$DIR/$PLATFORM-build.sh" $FLAGS $@
popd > /dev/null
