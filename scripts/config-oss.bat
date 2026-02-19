@echo off
echo ========================================
echo  Aliyun OSS Configuration
echo ========================================
echo.
echo Please configure Aliyun OSS:
echo 1. Visit: https://oss.console.aliyun.com/
echo 2. Create Bucket: handwriting-input-app
echo 3. Get AccessKey: https://ram.console.aliyun.com/manage/ak
echo 4. Configure CORS (important!)
echo.
echo Press any key to continue...
pause >nul
echo.
set /p OSS_ACCESS_KEY_ID=Enter AccessKey ID: 
set /p OSS_ACCESS_KEY_SECRET=Enter AccessKey Secret: 
set /p OSS_BUCKET_NAME=Enter Bucket name (default: handwriting-input-app): 
if "%OSS_BUCKET_NAME%"=="" set OSS_BUCKET_NAME=handwriting-input-app
echo.
echo Updating configuration file...
set CONFIG_FILE=%~dp0..\backend\src\main\resources\application.yml
copy "%CONFIG_FILE%" "%CONFIG_FILE%.backup" >nul 2>&1
powershell -Command "(Get-Content '%CONFIG_FILE%') -replace 'accessKeyId: .*', 'accessKeyId: %OSS_ACCESS_KEY_ID%' -replace 'accessKeySecret: .*', 'accessKeySecret: %OSS_ACCESS_KEY_SECRET%' -replace 'bucketName: .*', 'bucketName: %OSS_BUCKET_NAME%' -replace 'domain: .*', 'domain: https://%OSS_BUCKET_NAME%.oss-cn-hangzhou.aliyuncs.com' | Set-Content '%CONFIG_FILE%'"
echo OSS configuration updated
echo.
echo ========================================
echo  OSS Configuration Info
echo ========================================
echo Endpoint: oss-cn-hangzhou.aliyuncs.com
echo AccessKey ID: %OSS_ACCESS_KEY_ID%
echo Bucket: %OSS_BUCKET_NAME%
echo.
echo Please make sure CORS is configured
echo.
pause