@echo off
chcp 65001 >nul
:menu
cls
echo ========================================
echo   个性化手写输入法APP - 快速启动
echo ========================================
echo.
echo 请选择操作：
echo.
echo   1. 检查环境配置
echo   2. 安装开发工具
echo   3. 安装Redis（可选）
echo   4. 初始化数据库
echo   5. 配置阿里云OSS
echo   6. 启动项目（前后端）
echo   7. 只启动后端
echo   8. 只启动前端
echo   9. 查看帮助
echo   0. 退出
echo.

set /p choice="请输入选项 (0-9): "

if "%choice%"=="1" (
    call scripts\check-config.bat
) else if "%choice%"=="2" (
    call scripts\install-tools.bat
) else if "%choice%"=="3" (
    call scripts\install-redis.bat
) else if "%choice%"=="4" (
    call scripts\init-database.bat
) else if "%choice%"=="5" (
    call scripts\config-oss.bat
) else if "%choice%"=="6" (
    call scripts\start.bat
) else if "%choice%"=="7" (
    call scripts\start-backend.bat
) else if "%choice%"=="8" (
    call scripts\start-frontend.bat
) else if "%choice%"=="9" (
    type scripts\README.md
    pause
) else if "%choice%"=="0" (
    echo 再见！
    timeout /t 2 >nul
    exit /b 0
) else (
    echo 无效选项，请重新选择
    timeout /t 2 >nul
    goto :menu
)

goto :menu