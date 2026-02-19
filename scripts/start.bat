@echo off
echo ========================================
echo  Starting Project
echo ========================================
echo.

cd /d %~dp0..

echo Starting backend service...
start "Handwriting Backend" cmd /k "cd /d %~dp0backend && mvn spring-boot:run"

echo Waiting for backend to start...
timeout /t 10 /nobreak >nul

echo.
echo Starting frontend application...
start "Handwriting Frontend" cmd /k "cd /d %~dp0frontend && flutter run"

echo.
echo ========================================
echo  Services Starting...
echo ========================================
echo.
echo Backend: http://localhost:8080
echo Frontend: Started in new window
echo.
echo Please wait for services to fully start
echo.

echo Press any key to close this window...
pause >nul