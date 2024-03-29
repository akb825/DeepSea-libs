@echo off

set DIR=%~dp0
set BUILD_DIR=%cd%
set /P VERSION=<"%DIR%\gtest.version"
set /P FLAGS=<"%DIR%\gtest.flags"
set NAME=gtest-%VERSION%

powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('https://github.com/google/googletest/archive/v%VERSION%.zip', '%NAME%.zip')"
7z x "%NAME%.zip"
cd "googletest-%VERSION%"
if "%PLATFORM%"=="native" (
	call "%DIR%\%PLATFORM%-compile-debug.bat" -Dgtest_force_shared_crt=ON %FLAGS% %*
	if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
	cd "%BUILD_DIR%\googletest-%VERSION%"
)
call "%DIR%\%PLATFORM%-compile.bat" -Dgtest_force_shared_crt=ON %FLAGS% %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %BUILD_DIR%
