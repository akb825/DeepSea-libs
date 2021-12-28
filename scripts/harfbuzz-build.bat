@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\harfbuzz.version"
set /P FLAGS=<"%DIR%\harfbuzz.flags"
set NAME=harfbuzz-%VERSION%

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/harfbuzz/harfbuzz/archive/%VERSION%.zip', '%NAME%.zip')"
7z x "%NAME%.zip"
cd "%NAME%"
if "%PLATFORM%"=="native" (
	call "%DIR%\%PLATFORM%-compile-debug.bat" -DCMAKE_DEBUG_POSTFIX=d %FLAGS% %*
	if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
	cd "%BUILD_DIR%\%NAME%"
)
call "%DIR%\%PLATFORM%-compile.bat" %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
