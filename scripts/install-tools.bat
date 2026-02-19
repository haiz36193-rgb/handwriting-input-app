@echo off
cls
echo ========================================
echo  Environment Setup Guide
echo ========================================
echo.
echo This guide will help you install required tools
echo.
echo Required tools:
echo   1. MySQL 8.0 (database)
echo   2. Maven 3.6+ (Java build tool)
echo   3. Flutter 3.x (frontend framework)
echo.
echo Press any key to start...
pause >nul

echo.
echo ========================================
echo  Step 1: Install MySQL
echo ========================================
echo.
echo Download MySQL 8.0 from:
echo https://dev.mysql.com/downloads/mysql/
echo.
echo After download:
echo   1. Run the installer
echo   2. Set root password (remember it!)
echo   3. Add MySQL to system PATH
echo   4. Reopen this script after installation
echo.
echo Press any key to continue...
pause >nul

echo.
echo ========================================
echo  Step 2: Install Maven
echo ========================================
echo.
echo Download Maven from:
echo https://maven.apache.org/download.cgi
echo.
echo After download:
echo   1. Extract to C:\Program Files\Maven\
echo   2. Add environment variables:
echo      - MAVEN_HOME = C:\Program Files\Maven
echo      - PATH add = %%MAVEN_HOME%%\bin
echo   3. Reopen this script after installation
echo.
echo Press any key to continue...
pause >nul

echo.
echo ========================================
echo  Step 3: Install Flutter
echo ========================================
echo.
echo Download Flutter from:
echo https://flutter.dev/docs/get-started/install/windows
echo.
echo After download:
echo   1. Extract to C:\src\flutter\
echo   2. Add to PATH:
echo      - PATH add = C:\src\flutter\bin
echo   3. Run flutter doctor
echo   4. Reopen this script after installation
echo.
echo Press any key to continue...
pause >nul

echo.
echo ========================================
echo  Installation Complete
echo ========================================
echo.
echo After installing all tools:
echo   1. Run Launcher.bat option 1 to check environment
echo   2. Run Launcher.bat option 4 to initialize database
echo   3. Run Launcher.bat option 6 to start project
echo.
echo Press any key to exit...
pause >nul