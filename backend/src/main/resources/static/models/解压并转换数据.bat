@echo off
chcp 65001 >nul
title 解压并转换MNIST数据
echo ========================================
echo   解压并转换MNIST数据
echo ========================================
echo.

echo [1/3] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [X] Python未安装
    echo [INFO] 请先运行: 桌面\安装Python深度学习环境.bat
    pause
    exit /b 1
)
python --version
echo [OK] Python环境正常
echo.

echo [2/3] 检查MNIST数据文件...
if not exist "mnist_data\train-images-idx3-ubyte.gz" (
    echo [X] 未找到MNIST数据文件
    echo [INFO] 请先运行: download_mnist.bat
    pause
    exit /b 1
)
echo [OK] MNIST数据文件已就绪
echo.

echo [3/3] 解压并转换数据...
echo.
echo 提取10000张手写数字图像...
echo 图像大小: 128x128像素
echo 输出目录: training_data\
echo.
pause

python extract_mnist.py --num_samples 10000

if errorlevel 1 (
    echo.
    echo [X] 数据转换失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo   数据准备完成！
echo ========================================
echo.
echo 生成的文件:
if exist "training_data\labels.json" echo   [OK] training_data\labels.json (标签文件)
echo   [OK] training_data\mnist_*.png (图像文件)
echo.
echo 图像数量:
dir /b "training_data\mnist_*.png" 2>nul | find /c /v "" >nul
if errorlevel 1 (
    echo   [X] 未找到图像文件
) else (
    for /f %%a in ('dir /b "training_data\mnist_*.png" 2^>nul ^| find /c /v ""') do echo   [OK] %%a 张图像
)
echo.
echo 下一步:
echo   运行训练: train.bat
echo.
pause