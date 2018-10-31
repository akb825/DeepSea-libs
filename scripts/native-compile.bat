@echo off
set REPO_DIR=%cd%

rmdir build /S /Q > nul 2>&1
mkdir build
cd build

cmake .. -G "Visual Studio 15 2017" -DCMAKE_FIND_ROOT_PATH="%INSTALL_DIR%"^
	-DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release --target install
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %REPO_DIR%
