#!/usr/bin/env bash
set -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD="$( pwd )"
cd "$DIR"

INSTALL_DIR="$DIR/install"
BUILD_DIR="$DIR/build"
PLATFORM=native
OUTPUT="$DIR/DeepSea-libs.tar.gz"
CMAKE_ARGS=
ANDROID_NDK=
ANDROID_ABI=
ANDROID_VERSION=android-18
IOS_TARGET=10.0

function printHelp {
	echo "Usage: `basename "$0"` [options] [CMake args...]"
	echo
	echo "Options:"
	echo "-p, --platform <platform>    The platform to build for. Valid platforms are:"
	echo "                             - native (default)"
	echo "                             - android"
	echo "                             - ios"
	echo "-o, --output <file>          The file to output the archive. Note that the"
	echo "                             archive format will always be .tar.gz regardless of"
	echo "                             the extension."
	echo "--android-ndk <dir>          Directory of the Android NDK root. Must be set"
	echo "                             when platform is set to 'android'."
	echo "--android-abi <abi>          The Android ABI to build for. Must be set when"
	echo "                             platform is set to 'android'. Must be one of:"
	echo "                             - x86"
	echo "                             - x86_64"
	echo "                             - armeabi-v7a"
	echo "                             - arm64-v8a"
	echo "--android-version <version>  Version to use when building for Android. Defaults"
	echo "                             to $ANDROID_VERSION"
	echo "--ios-target <version>       Version to use when building for iOS. Defaults to"
	echo "                             $IOS_TARGET"
}

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help)
			printHelp
			exit 0
			;;
		-p|--platform)
			shift
			case "$1" in
				native|android|ios)
					PLATFORM=$1
					;;
				*)
					echo "Unknown platform: $1"
					echo
					printHelp
					exit 1
				;;
			esac
			;;
		-o|--output)
			shift
			OUTPUT="$1"
			if [ "${OUTPUT:0:1}" != "/" ]; then
				OUTPUT="$CWD/$OUTPUT"
			fi
			;;
		--android-ndk)
			shift
			ANDROID_NDK="$1"
			;;
		--android-abi)
			shift
			case "$1" in
				x86|x86_64|armeabi-v7a|arm64-v8a)
					ANDROID_ABI=$1
					;;
				*)
					echo "Unknown Android ABI: $1"
					echo
					printHelp
					exit 1
				;;
			esac
			;;
		--android-version)
			shift
			ANDROID_VERSION="$1"
			;;
		--ios-target)
			shift
			IOS_TARGET="$1"
			;;
		*)
			CMAKE_ARGS="$CMAKE_ARGS $1"
			;;
	esac
	shift
done

if [ $PLATFORM = native -a "$(uname)" = "Linux" ]; then
	LIBRARIES=(sdl gtest)
else
	LIBRARIES=(freetype harfbuzz sdl gtest)
fi

if [ $PLATFORM = android ]; then
	if [ -z "$ANDROID_NDK" ]; then
		echo "The --android-ndk option must be given when building for Android."
		echo
		printHelp
		exit 1
	elif [ -z "$ANDROID_ABI" ]; then
		echo "The --android-abi option must be given when building for Android."
		echo
		printHelp
		exit 1
	elif [ ! -d "$ANDROID_NDK" ]; then
		echo "Android NDK locaton '$ANDROID_NDK' doesn't exist."
		exit 1
	fi

	export ANDROID_NDK
	export ANDROID_ABI
	export ANDROID_VERSION
elif [ $PLATFORM = ios ]; then
	export IOS_TARGET
fi

export PLATFORM
export INSTALL_DIR

rm -rf build
mkdir build

rm -rf install
mkdir install

cd "$BUILD_DIR" 
for LIB in "${LIBRARIES[@]}"
do
	echo "Building $LIB..."
	"$DIR/scripts/$LIB-build.sh" $CMAKE_ARGS
done

echo "Creating package \"$OUTPUT\"..."
pushd "$INSTALL_DIR" > /dev/null

tar czf "$OUTPUT" *

popd > /dev/null

echo "Cleaning up..."
rm -rf "$BUILD_DIR" 
rm -rf "$INSTALL_DIR"

echo "Done"
