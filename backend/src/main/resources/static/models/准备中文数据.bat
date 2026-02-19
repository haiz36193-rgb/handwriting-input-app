@echo off
chcp 65001 >nul
title 准备中文手写数据集
echo ========================================
echo   准备中文手写数据集
echo ========================================
echo.

echo [1/4] 检查Python环境...
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

echo [2/4] 检查中文数据目录...
if not exist "chinese_data" (
    echo [X] 未找到中文数据目录
    echo.
    echo 请先下载中文手写数据集:
    echo   运行: download_chinese_dataset.bat
    echo   或手动下载数据到 chinese_data 目录
    echo.
    pause
    exit /b 1
)
echo [OK] 中文数据目录存在
echo.

echo [3/4] 检测数据集类型...
if exist "chinese_data\train" (
    echo [INFO] 检测到Kaggle数据集格式
    set DATASET_TYPE=kaggle
) else (
    echo [INFO] 检测到CASIA数据集格式
    set DATASET_TYPE=casia
)
echo.

echo [4/4] 处理数据集...
echo.
echo 转换图像格式: 调整大小到128x128
echo 输出目录: training_data\
echo.
pause

python prepare_chinese_data.py --dataset_type auto

if errorlevel 1 (
    echo.
    echo [X] 数据处理失败
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
echo   [OK] training_data\chinese_*.png (图像文件)
echo.
echo 图像数量:
dir /b "training_data\chinese_*.png" 2>nul | find /c /v "" >nul
if errorlevel 1 (
    echo   [X] 未找到图像文件
) else (
    for /f %%a in ('dir /b "training_data\chinese_*.png" 2^>nul ^| find /c /v ""') do echo   [OK] %%a 张图像
)
echo.
echo 下一步:
echo   运行训练: train.bat
echo.
pause