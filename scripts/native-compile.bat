@echo off
set REPO_DIR=%cd%

rmdir build /S /Q > nul 2>&1
mkdir build
cd build

cmake .. -DCMAKE_FIND_ROOT_PATH="%INSTALL_DIR%" ^
	-DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -DCMAKE_CXX_FLAGS=/MP -DCMAKE_C_FLAGS=/MP %*
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%
cmake --build . --config Release --target install
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cd %REPO_DIR%
