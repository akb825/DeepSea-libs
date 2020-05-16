@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\freetype.version"
set /P FLAGS=<"%DIR%\freetype.flags"
set NAME=freetype-%VERSION%

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.savannah.gnu.org/releases/freetype/%NAME%.tar.xz', '%NAME%.tar.xz')"
7z e "%NAME%.tar.xz"
7z x "%NAME%.tar"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
