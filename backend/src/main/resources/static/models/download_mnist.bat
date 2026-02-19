@echo off
chcp 65001 >nul
title 下载MNIST手写数据集
echo ========================================
echo   下载MNIST手写数据集
echo ========================================
echo.
echo MNIST数据集包含70,000张手写数字图像
echo   - 训练集: 60,000张
echo   - 测试集: 10,000张
echo   - 图像大小: 28x28像素
echo   - 类别: 0-9共10个数字
echo.

set DOWNLOAD_DIR=mnist_data
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

cd /d "%DOWNLOAD_DIR%"

echo [1/4] 下载训练图像 (约50MB)...
curl -L -o train-images-idx3-ubyte.gz http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz
if errorlevel 1 (
    echo [X] 下载失败
    echo [INFO] 尝试备用下载源...
    curl -L -o train-images-idx3-ubyte.gz https://github.com/cazala/mnist/raw/master/train-images-idx3-ubyte.gz
    if errorlevel 1 (
        echo [X] 备用源也失败
        pause
        exit /b 1
    )
)
echo [OK] 训练图像下载完成

echo.
echo [2/4] 下载训练标签 (约30KB)...
curl -L -o train-labels-idx1-ubyte.gz http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz
if errorlevel 1 (
    echo [X] 下载失败
    echo [INFO] 尝试备用下载源...
    curl -L -o train-labels-idx1-ubyte.gz https://github.com/cazala/mnist/raw/master/train-labels-idx1-ubyte.gz
)
echo [OK] 训练标签下载完成

echo.
echo [3/4] 下载测试图像 (约8MB)...
curl -L -o t10k-images-idx3-ubyte.gz http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz
if errorlevel 1 (
    echo [X] 下载失败
    echo [INFO] 尝试备用下载源...
    curl -L -o t10k-images-idx3-ubyte.gz https://github.com/cazala/mnist/raw/master/t10k-images-idx3-ubyte.gz
)
echo [OK] 测试图像下载完成

echo.
echo [4/4] 下载测试标签 (约5KB)...
curl -L -o t10k-labels-idx1-ubyte.gz http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz
if errorlevel 1 (
    echo [X] 下载失败
    echo [INFO] 尝试备用下载源...
    curl -L -o t10k-labels-idx1-ubyte.gz https://github.com/cazala/mnist/raw/master/t10k-labels-idx1-ubyte.gz
)
echo [OK] 测试标签下载完成

cd ..

echo.
echo ========================================
echo   下载完成！
echo ========================================
echo.
echo 下载的文件:
dir /b "%DOWNLOAD_DIR%"

echo.
echo 总大小:
for %%F in (%DOWNLOAD_DIR%\*.gz) do (
    echo   %%~nxF: %%~zF 字节
)

echo.
echo 下一步:
echo   运行: 解压并转换数据.bat
echo.
pause