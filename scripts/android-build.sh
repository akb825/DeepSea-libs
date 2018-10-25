#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"
ABIS=(x86 x86_64 armeabi-v7a arm64-v8a)
ANDROID_TOOLCHAIN="$ANDROID_SDK/ndk-bundle/build/cmake/android.toolchain.cmake"

rm -rf build
mkdir build
cd build

for ABI in "${ABIS[@]}"
do
	ABI_INSTALL_DIR="$INSTALL_DIR/$ABI"
	mkdir -p "$ABI"
	pushd "$ABI" > /dev/null
	cmake ../.. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE="$ANDROID_TOOLCHAIN" \
		-DANDROID_PLATFORM=$ANDROID_VERSION -DANDROID_ABI=$ABI \
		-DCMAKE_FIND_ROOT_PATH="$ABI_INSTALL_DIR" \
		-DCMAKE_INSTALL_PREFIX="$ABI_INSTALL_DIR" $@
	make -j$PROCESSORS
	make install
	popd > /dev/null
done
