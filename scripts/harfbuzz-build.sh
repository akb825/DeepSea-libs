#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/harfbuzz.version" )"
FLAGS="$( cat "$DIR/harfbuzz.flags" )"
NAME="harfbuzz-$VERSION"

curl "https://www.freedesktop.org/software/harfbuzz/release/$NAME.tar.xz" --output "$NAME.tar.xz"
tar xzf "$NAME.tar.xz"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
