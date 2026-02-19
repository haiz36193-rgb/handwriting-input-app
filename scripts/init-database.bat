@echo off
echo ========================================
echo  Database Initialization
echo ========================================
echo.

set /p DB_ROOT_PASSWORD=Enter MySQL root password: 

echo.
echo Connecting to MySQL...
mysql -u root -p%DB_ROOT_PASSWORD% -e "SELECT VERSION();" 2>nul
if %errorlevel% neq 0 (
    echo Connection failed. Please check your password.
    pause
    exit /b 1
)

echo MySQL connection successful
echo.

echo Creating database and user...
mysql -u root -p%DB_ROOT_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS handwriting_input_app DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
mysql -u root -p%DB_ROOT_PASSWORD% -e "CREATE USER IF NOT EXISTS 'handwriting'@'localhost' IDENTIFIED BY 'handwriting123';" 2>nul
mysql -u root -p%DB_ROOT_PASSWORD% -e "GRANT ALL PRIVILEGES ON handwriting_input_app.* TO 'handwriting'@'localhost';" 2>nul
mysql -u root -p%DB_ROOT_PASSWORD% -e "FLUSH PRIVILEGES;" 2>nul

if %errorlevel% neq 0 (
    echo Failed to create database
    pause
    exit /b 1
)

echo Database and user created successfully
echo.

echo Importing initialization script...
mysql -u handwriting -phandwriting123 handwriting_input_app < "%~dp0init.sql" 2>nul

if %errorlevel% neq 0 (
    echo Failed to import initialization script
    pause
    exit /b 1
)

echo Database initialization completed
echo.
echo ========================================
echo  Database Configuration Info
echo ========================================
echo Database: handwriting_input_app
echo Username: handwriting
echo Password: handwriting123
echo.
pause