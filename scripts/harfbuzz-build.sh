#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/harfbuzz.version" )"
FLAGS="$( cat "$DIR/harfbuzz.flags" )"
NAME="harfbuzz-$VERSION"

curl -L "https://github.com/harfbuzz/harfbuzz/archive/$VERSION.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
