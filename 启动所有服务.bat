@echo off
echo ========================================
echo  启动个性化手writing输入法APP
echo ========================================
echo.

echo [1/2] 启动后端服务...
start /min cmd /k cd C:\Users\Administrator\handwriting-input-app\backend && start.bat

echo [2/2] 后端服务启动中...
echo.
echo ========================================
echo  后端服务已启动！
echo ========================================
echo.
echo 后端地址: http://localhost:8080/api/v1
echo.
echo 按任意键关闭此窗口...
pause >nul
