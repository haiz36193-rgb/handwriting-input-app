@echo off
chcp 65001 >nul
title 全数据集GPU训练

echo ========================================
echo   全数据集GPU训练启动脚本
echo ========================================
echo.

echo [1/4] 检查Conda环境...
if not exist "C:\miniconda3\Scripts\conda.exe" (
    echo [X] 未找到Conda，请先安装Miniconda到C:\miniconda3
    pause
    exit /b 1
)
echo [OK] Conda已找到

echo.
echo [2/4] 检查Python环境...
C:\miniconda3\Scripts\conda.exe run -n pytorch-gpu python -c "import torch" 2>nul
if errorlevel 1 (
    echo [X] pytorch-gpu环境不存在，请先创建环境
    echo     运行命令: C:\miniconda3\Scripts\conda.exe create -n pytorch-gpu python=3.11 -y
    echo     安装PyTorch: C:\miniconda3\Scripts\conda.exe install -n pytorch-gpu pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia -y
    pause
    exit /b 1
)
echo [OK] pytorch-gpu环境已存在

echo.
echo [3/4] 检查GPU可用性...
C:\miniconda3\Scripts\conda.exe run -n pytorch-gpu python -c "import torch; print('CUDA可用:', torch.cuda.is_available()); print('GPU名称:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else '无GPU')"
if errorlevel 1 (
    echo [X] GPU检查失败
    pause
    exit /b 1
)

echo.
echo [4/4] 启动训练...
echo 训练配置:
echo   - 总样本数: 738,937
echo   - 训练样本: 585,607
echo   - 验证样本: 153,330
echo   - 字符类别: 18,941
echo   - 训练轮数: 20
echo   - 批次大小: 16
echo   - 学习率: 0.0005
echo   - 图像大小: 128x128
echo   - Checkpoint间隔: 1000步
echo.
echo 训练将开始，请耐心等待...
echo 按 Ctrl+C 可以中断训练
echo.

cd /d "%~dp0"
C:\miniconda3\Scripts\conda.exe run -n pytorch-gpu python train_gpu_full_dataset.py

echo.
echo ========================================
echo 训练结束
echo ========================================
echo.
pause