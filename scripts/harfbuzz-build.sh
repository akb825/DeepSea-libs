#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/harfbuzz.version" )"
FLAGS="$( cat "$DIR/harfbuzz.flags" )"
NAME="harfbuzz-$VERSION"

curl "https://www.freedesktop.org/software/harfbuzz/release/$NAME.tar.bz2" --output "$NAME.tar.bz2"
tar xjf "$NAME.tar.bz2"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-build.sh" $FLAGS $@
popd > /dev/null
