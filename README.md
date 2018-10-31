# Introduction

DeepSea-libs provides scripts to build the external libraries dependencies for compiling [DeepSea](https://github.com/akb825/DeepSea). Pre-compiled releases are provided for the following platforms:

* Linux for x86-64 (glibc 2.19 or later)
* macOS (10.11 or later)
* Windows for x86 and x86-64
* Android for x86, x86-64, ARM-7a, and ARM-8.

This builds the following libraries:

* [HarfBuzz](http://harfbuzz.org/) (not built for Linux)
* [FreeType](https://www.freetype.org/) (not built for Linux)
* [SDL](http://libsdl.org/)
* [Google Test](https://github.com/google/googletest)
* [ragel](http://www.colm.net/open-source/ragel/) for platforms that build HarfBuzz.

# Dependencies

The following software is required to build DeepSea-libs:

* [cmake](https://cmake.org/) 3.1 or later. This must be in your `PATH`.
* [7zip](https://www.7-zip.org/) is required on Windows.
* Powershell is required on Windows.
* [curl](https://curl.haxx.se/) is required on Linux and macOS.

# Compiling

Scripts are provided to perform the compilation on various platforms.

## Linux and macOS

Make sure the development tools and dependencies are installed.

For example, on Ubuntu the following packages should be installed:

* cmake
* build-essential

For macOS using [Homebrew](https://brew.sh/), the following packages should be installed:

* cmake
* ragel

To perform the build, simply run the `build.sh` script. Additional CMake options can be passed in as command line options, such as for cross-compiling for other systems. Once finished, the `DeepSea-libs.tar.gz` package will contain the tools.

> **Note:** If you want to keep a script around for custom arguments without checking it into source control, create a script named `build-custom.sh`. This is in `.gitignore` so it won't show as a locally modified file.

## Windows

The default setup for Windows is to build with Visual Studio 2017 using the v140 toolset. (i.e. Visual Studio 2015 toolset, but from the Visual Studio 2017 installer)

[Ragel](http://www.colm.net/open-source/ragel/) must be built first in order to build HarfBuzz. This must be done using [MinGW](https://sourceforge.net/projects/mingw/). Be sure to install the `developer-tools`, `base`, and `gcc-g++` packages, then run `C:\MinGW\msys\1.0\msys.bat` for the console to perform the build. (use `/c/` prefix for paths to the C: drive) Also add `C:\MinGW\bin` to `PATH` to make sure `ragel` can be run oustide of a MinGW console.

Once `ragel` is built and on the `PATH` environment variable, you can run `build.bat` to perform the build for the DeepSea dependencies.

# Example custom build scripts

Custom build scripts can be used to control the version of the compiler used. For example, to use a newer compiler or support older systems.

## Android

Building for Android requires passing in the SDK location. A `build-custom-android.sh` script like this can be used to avoid passing in the path each time, and also build for each available ABI.

	#!/usr/bin/env bash
	set -e
	SDK_DIR=/mnt/Scratch/Android
	ABIS=(x86 x86_64 armeabi-v7a arm64-v8a)
	for ABI in "${ABIS[@]}"
	do
		./build.sh -p android --android-sdk "$SDK_DIR" --android-abi $ABI \
			-o DeepSea-libs-android-$ABI.tar.gz
	done

## macOS

In order to support earlier than the current version of macOS (such as back in the ye olde days when it was still called Mac OS X), you need to download an older version of XCode. You can download rather old versions of XCode from Apple's developer website, though it's quite limited how far back will actually run on a modern system. When running macOS 10.14, the furthest back I could go is XCode 7.3.1. This would allow building against the Mac OS X 10.11 SDK.

In order to use an older version of XCode, download it, rename `XCode.app` to a different name (e.g. `XCode-7.3.1.app`), and move it to `/Applicatons`. You should also run it in order to make sure the command line tools are installed.

Once an older version is installed, a `build-custom.sh` such as the following can be used:

	#!/bin/sh
	set -e
	export DEVELOPER_DIR=/Applications/Xcode-7.3.1.app/Contents/Developer
	./build.sh -DCMAKE_OSX_SYSROOT=$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk -o DeepSea-libs-mac.tar.gz
	
## Windows

Windows is configured to build for 32-bit by default. You can also build for 64-bit by specifying the "win64" platform. The following is an example `build-custom.batch` script that can be used:

	@echo off
	.\build.bat -p win64 -o DeepSea-libs-win64.zip
