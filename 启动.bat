@echo off
:menu
cls
echo ========================================
echo   Handwriting Input App - Launcher
echo ========================================
echo.
echo Please select an option:
echo.
echo   1. Check environment
echo   2. Install tools
echo   3. Install Redis (optional)
echo   4. Initialize database
echo   5. Configure OSS
echo   6. Start project (frontend + backend)
echo   7. Start backend only
echo   8. Start frontend only
echo   0. Exit
echo.

set /p choice=Enter option (0-8):

if "%choice%"=="1" call scripts\check-config.bat
if "%choice%"=="2" call scripts\install-tools.bat
if "%choice%"=="3" call scripts\install-redis.bat
if "%choice%"=="4" call scripts\init-database.bat
if "%choice%"=="5" call scripts\config-oss.bat
if "%choice%"=="6" call scripts\start.bat
if "%choice%"=="7" call scripts\start-backend.bat
if "%choice%"=="8" call scripts\start-frontend.bat
if "%choice%"=="0" exit /b 0

echo.
echo Press any key to continue...
pause >nul
goto :menu