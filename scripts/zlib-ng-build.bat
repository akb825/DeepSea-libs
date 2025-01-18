@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\zlib-ng.version"
set /P FLAGS=<"%DIR%\zlib-ng.flags"
set NAME=zlib-ng-%VERSION%

powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('https://github.com/zlib-ng/zlib-ng/archive/%VERSION%.zip', '%NAME%.zip')"
7z x "%NAME%.zip"
cd "%NAME%"
call "%DIR%\%PLATFORM%-compile.bat" %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
