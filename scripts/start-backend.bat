@echo off
echo ========================================
echo  Starting Backend Service
echo ========================================
echo.

cd /d %~dp0..\backend

echo Starting Spring Boot service...
echo URL: http://localhost:8080
echo API Docs: http://localhost:8080/swagger-ui.html
echo.
echo Press Ctrl+C to stop service
echo.

mvn spring-boot:run