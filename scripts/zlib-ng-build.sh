#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/zlib-ng.version" )"
FLAGS="$( cat "$DIR/zlib-ng.flags" )"
NAME="zlib-ng-$VERSION"

curl -L "https://github.com/zlib-ng/zlib-ng/archive/$VERSION.tar.gz" --output "$NAME.tar.gz"
tar xzf "$NAME.tar.gz"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
