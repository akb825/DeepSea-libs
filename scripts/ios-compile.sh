#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"
IOS_TOOLCHAIN="$DIR/../ios.toolchain.cmake"

rm -rf build
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE="$IOS_TOOLCHAIN" \
	-DDEPLOYMENT_TARGET=$IOS_TARGET -DPLATFORM=OS64 \
	-DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" $@
make -j$PROCESSORS
make install
