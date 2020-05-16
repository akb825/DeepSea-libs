#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
VERSION="$( cat "$DIR/gtest.version" )"
FLAGS="$( cat "$DIR/gtest.flags" )"
NAME="googletest-release-$VERSION"

curl -L "https://github.com/google/googletest/archive/release-$VERSION.tar.gz" \
	--output "$NAME.tar.gz" 
tar xzf "$NAME.tar.gz"

if [ $PLATFORM = android ]; then
	patch -p1 -d "$NAME" -i "$DIR/gtest-android-capture.patch"
fi

pushd "$NAME" > /dev/null
"$DIR/$PLATFORM-compile.sh" $FLAGS $@
popd > /dev/null
