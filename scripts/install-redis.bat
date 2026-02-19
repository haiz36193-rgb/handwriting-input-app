@echo off
cls
echo ========================================
echo  Redis Installation
echo ========================================
echo.
echo Redis is optional, used for caching
echo.
echo Press any key to download Redis, or Ctrl+C to skip...
pause >nul

echo.
echo Downloading Redis...
set REDIS_URL=https://github.com/microsoftarchive/redis/releases/download/win-3.2.100/Redis-x64-3.2.100.zip
set REDIS_FILE=%TEMP%\Redis-x64-3.2.100.zip

powershell -Command "Invoke-WebRequest -Uri '%REDIS_URL%' -OutFile '%REDIS_FILE%'"

if %errorlevel% neq 0 (
    echo Download failed. Please download manually:
    echo %REDIS_URL%
    pause
    exit /b 1
)

echo Download complete
echo.

set INSTALL_DIR=C:\Redis
echo Installing to %INSTALL_DIR%...

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
powershell -Command "Expand-Archive -Path '%REDIS_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"

if %errorlevel% neq 0 (
    echo Installation failed
    pause
    exit /b 1
)

echo Installation complete
echo.

setx PATH "%PATH%;%INSTALL_DIR%" /M >nul
echo Added to system PATH
echo.

cd /d %INSTALL_DIR%
echo Installing as Windows service...
redis-server --service-install
redis-server --service-start

echo Redis installed and started
echo.
echo Redis configuration:
echo   Directory: %INSTALL_DIR%
echo   Service: Redis
echo   Port: 6379
echo.
echo Press any key to continue...
pause >nul

del "%REDIS_FILE%" >nul 2>&1

echo.
echo Redis installation complete!
echo.
pause