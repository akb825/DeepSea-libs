#!/usr/bin/env bash
set -e

# Perform build in this directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD="$( pwd )"
cd "$DIR"

rm -rf build
mkdir build

rm -rf install
mkdir install

INSTALL_DIR="$DIR/install"
BUILD_DIR="$DIR/build"
PLATFORM=native
OUTPUT="$DIR/DeepSea-libs.tar.gz"
CMAKE_ARGS=
ANDROID_SDK=
ANDROID_VERSION=android-18

function printHelp {
	echo "Usage: `basename "$0"` [options] [CMake args...]"
	echo
	echo "Options:"
	echo "-p, --platform <platform>    The platform to build for. Valid platforms are:"
	echo "                             - native (default)"
	echo "                             - android"
	echo "-o, --output <file>          The file to output the archive. Note that the"
	echo "                             archive format will always be .tar.gz regardless of"
	echo "                             the extension."
	echo "--android-sdk <dir>          Directory of the Android SDK root. Must be set"
	echo "                             when platform is set to 'android'."
	echo "--android-version <version>  Version to use when building for Android. Defaults"
	echo "                             to $ANDROID_VERSION"
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
				native|android)
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
		--android-sdk)
			shift
			ANDROID_SDK="$1"
			;;
		--android-version)
			shift
			ANDROID_VERSION="$1"
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
	if [ -z "$ANDROID_SDK" ]; then
		echo "The --android-sdk must be given when building for Android."
		echo
		printHelp
		exit 1
	elif [ ! -d "$ANDROID_SDK" ]; then
		echo "Android SDK locaton '$ANDROID_SDK' doesn't exist."
		exit 1
	fi

	export ANDROID_SDK
	export ANDROID_VERSION
fi

export PLATFORM
export INSTALL_DIR

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
