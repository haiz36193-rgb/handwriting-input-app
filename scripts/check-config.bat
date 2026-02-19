@echo off
echo ========================================
echo  Configuration Check
echo ========================================
echo.

set ALL_OK=1

echo [1/6] Checking MySQL...
where mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo MySQL not installed
    set ALL_OK=0
) else (
    echo MySQL installed
    mysql --version
)

echo.
echo [2/6] Checking Redis...
where redis-server >nul 2>&1
if %errorlevel% neq 0 (
    echo Redis not installed (optional)
) else (
    echo Redis installed
)

echo.
echo [3/6] Checking Maven...
where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo Maven not installed
    set ALL_OK=0
) else (
    echo Maven installed
    mvn -version | findstr "Apache Maven"
)

echo.
echo [4/6] Checking Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter not installed
    set ALL_OK=0
) else (
    echo Flutter installed
    flutter --version
)

echo.
echo [5/6] Checking database config...
set CONFIG_FILE=%~dp0..\backend\src\main\resources\application.yml
if exist "%CONFIG_FILE%" (
    findstr /C:"handwriting_input_app" "%CONFIG_FILE%" >nul
    if %errorlevel% equ 0 (
        echo Database config OK
    ) else (
        echo Database config incomplete
    )
) else (
    echo Config file not found
    set ALL_OK=0
)

echo.
echo [6/6] Checking OSS config...
if exist "%CONFIG_FILE%" (
    findstr /C:"your-access-key-id" "%CONFIG_FILE%" >nul
    if %errorlevel% equ 0 (
        echo OSS config incomplete
    ) else (
        echo OSS config OK
    )
) else (
    echo Config file not found
    set ALL_OK=0
)

echo.
echo ========================================
if %ALL_OK% equ 1 (
    echo All required configs are ready
) else (
    echo Some configs are incomplete
)
echo ========================================
echo.

if %ALL_OK% equ 1 (
    echo You can start the project now
) else (
    echo Please complete the installation first
)

echo.
pause