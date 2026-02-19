@echo off
chcp 65001 >nul
echo ========================================
echo  个性化手写输入法APP - 环境配置向导
echo ========================================
echo.

REM 检查MySQL
echo [1/5] 检查MySQL安装...
where mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到MySQL，请先安装MySQL 8.0
    echo 下载地址: https://dev.mysql.com/downloads/mysql/
    pause
    exit /b 1
) else (
    echo ✅ MySQL已安装
)

REM 检查Redis
echo [2/5] 检查Redis安装...
where redis-server >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  未检测到Redis，请先安装Redis
    echo 下载地址: https://github.com/microsoftarchive/redis/releases
    echo 或者跳过Redis配置（部分功能可能不可用）
    set /p REDIS_SKIP="是否跳过Redis配置？(Y/N): "
    if /i "!REDIS_SKIP!"=="Y" (
        echo ⚠️  已跳过Redis配置
    )
) else (
    echo ✅ Redis已安装
)

REM 检查Maven
echo [3/5] 检查Maven安装...
where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Maven，请先安装Maven
    echo 下载地址: https://maven.apache.org/download.cgi
    pause
    exit /b 1
) else (
    echo ✅ Maven已安装
)

REM 检查Flutter
echo [4/5] 检查Flutter安装...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Flutter，请先安装Flutter
    echo 下载地址: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
) else (
    echo ✅ Flutter已安装
)

echo [5/5] 环境检查完成！
echo.
echo ========================================
echo  下一步：配置数据库和OSS
echo ========================================
echo.
echo 请运行以下命令：
echo   1. 配置数据库: scripts\init-database.bat
echo   2. 配置OSS: scripts\config-oss.bat
echo.
pause