@echo off
echo ========================================
echo  Starting Frontend Application
echo ========================================
echo.

cd /d %~dp0..\frontend

echo Starting Flutter application...
echo Please select device or emulator
echo.

flutter run