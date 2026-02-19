@echo off
echo Starting Backend Server...
cd /d %~dp0
java -jar target\handwriting-input-app-1.0.0.jar
pause
