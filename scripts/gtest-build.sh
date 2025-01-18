#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/gtest.version" )"
FLAGS="$( cat "$DIR/gtest.flags" )"
NAME="googletest-$VERSION"

curl -L "https://github.com/google/googletest/archive/v$VERSION.tar.gz" \
	--output "$NAME.tar.gz" 
tar xzf "$NAME.tar.gz"

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
