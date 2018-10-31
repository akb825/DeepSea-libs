@echo off
setlocal enabledelayedexpansion
set PREV_DIR=%cd%
set DIR=%~dp0
cd "%DIR%"

rmdir install /S /Q > nul 2>&1
mkdir install

rmdir build /S /Q > nul 2>&1
mkdir build

set INSTALL_DIR="%DIR%install"
set BUILD_DIR="%DIR%build"
set PLATFORM=native
set OUTPUT="%DIR%DeepSea-libs.zip"
set CMAKE_ARGS=
set CMAKE_PLATFORM_ARGS="-DCMAKE_GENERATOR_PLATFORM=Win32"
set TOOLSET=v140

:parseArgs
if not "%1"=="" (
	set MATCH=
	if "%1"=="-h" set MATCH=1
	if "%1"=="--help" set MATCH=1
	if "%1"=="/?" set MATCH=1
	if defined MATCH (
		goto :printHelp
	) else (
		if "%1"=="-p" set MATCH=1
		if "%1"=="--platform" set MATCH=1
		if defined MATCH (
			if "%2"=="win32" (
				set CMAKE_PLATFORM_ARGS="-DCMAKE_GENERATOR_PLATFORM=Win32"
			) else (
				if "%2"=="win64" (
					set CMAKE_PLATFORM_ARGS="-DCMAKE_GENERATOR_PLATFORM=x64"
				) else (
					echo Unknown platform "%2"
					set ERRORLEVEL=1
					goto :printHelp
				)
			)
			shift /1
		) else (
			if "%1"=="-o" set MATCH=1
			if "%1"=="--output" set MATCH=1
			if defined MATCH (
				set OUTPUT=%2
				shift /1
				if not "!OUTPUT:~2,1!"==":" set OUTPUT="%PREV_DIR%\!OUTPUT!"
			) else set CMAKE_ARGS=!CMAKE_ARGS! "%1"
		)
	)
	shift /1
	goto :parseArgs
)

set LIBS=freetype harfbuzz sdl gtest
cd build
for %%L in (%LIBS%) do (
	echo Building %%L...
	set DIR=%~dp0
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
	call "!DIR!scripts\%%L-build.bat" -T!TOOLSET! !CMAKE_PLATFORM_ARGS! !CMAKE_ARGS!
	if !ERRORLEVEL! neq 0 (
		cd %PREV_DIR%
		exit /B !ERRORLEVEL!
	)
)

REM Variables are shared between scripts, so need to get DIR agian.
set DIR=%~dp0
cd "%DIR%"

echo Creating package !OUTPUT!...
del !OUTPUT! >nul 2>&1

cd install
7z a -tzip !OUTPUT! *
cd "%DIR%"

echo Cleaning up...

rmdir install /S /Q > nul 2>&1
rmdir build /S /Q > nul 2>&1

echo Done

cd %PREV_DIR%
exit /B !ERRORLEVEL!

:printHelp
	echo Usage: %~n0` [options] [CMake args...]
	echo.
	echo Options:
	echo -p, --platform ^<platform^>    The platform to build for. Valid platforms are:
	echo                              - win32 (default)
	echo                              - win64
	echo -o, --output ^<file^>          The file to output the archive. Note that the
	echo                              archive format will always be .tar.gz regardless of
	echo                              the extension.
	exit /B !ERRORLEVEL!
