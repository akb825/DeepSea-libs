#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"
ANDROID_TOOLCHAIN="$ANDROID_SDK/ndk-bundle/build/cmake/android.toolchain.cmake"

rm -rf build
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_TOOLCHAIN" \
	-DANDROID_PLATFORM=$ANDROID_VERSION -DANDROID_ABI=$ANDROID_ABI \
	-DCMAKE_FIND_ROOT_PATH="$INSTALL_DIR" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" $@
make -j$PROCESSORS
make install
