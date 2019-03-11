#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROCESSORS="$( "$DIR/processors.sh" )"
ANDROID_TOOLCHAIN="$DIR/../android/android.toolchain.cmake"

rm -rf build
mkdir build
cd build

if [[ ( $ANDROID_ABI == x86_64 || $ANDROID_ABI == arm64-v8a ) && \
	${ANDROID_VERSION:8} -lt 21 ]]; then
	ANDROID_VERSION=android-21
fi

case $ANDROID_ABI in
	x86)
		ARCH_DIR=arch-x86
		;;
	x86_64)
		ARCH_DIR=arch-x86_64
		;;
	armeabi-v7a)
		ARCH_DIR=arch-arm
		;;
	arm64-v8a)
		ARCH_DIR=arch-arm64
		;;
esac

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_TOOLCHAIN" \
	-DANDROID_PLATFORM=$ANDROID_VERSION -DANDROID_ABI=$ANDROID_ABI \
	-DCMAKE_FIND_ROOT_PATH="$INSTALL_DIR;$ANDROID_NDK/platforms/$ANDROID_VERSION/$ARCH_DIR/usr" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" $@
make -j$PROCESSORS
make install
