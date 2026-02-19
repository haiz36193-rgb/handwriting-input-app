@echo off
REM 字体渲染引擎和图像处理依赖安装脚本
REM 需要：Python 3.8+

echo ========================================
echo 字体工具和图像处理依赖安装
echo ========================================

REM 检查Python是否安装
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Python未安装！
    echo 请先安装Python 3.8或更高版本
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/4] Python已安装
python --version

echo.
echo [2/4] 升级pip...
python -m pip install --upgrade pip

echo.
echo [3/4] 安装字体处理库...
pip install fontTools bezier

echo.
echo [4/4] 安装图像处理库...
pip install opencv-python pillow numpy

echo.
echo ========================================
echo 安装完成！
echo ========================================
echo.
echo 已安装的库：
echo - fontTools（字体处理）
echo - bezier（贝塞尔曲线）
echo - opencv-python（图像处理）
echo - pillow（图像处理）
echo - numpy（数值计算）
echo.
pause