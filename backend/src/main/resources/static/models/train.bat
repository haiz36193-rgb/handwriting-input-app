@echo off
chcp 65001 >nul
title 笔迹特征提取模型训练
echo ========================================
echo   笔迹特征提取模型训练
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
echo [2/4] 检查训练脚本...
if not exist "model_architecture.py" (
    echo [X] 缺少模型架构文件
    pause
    exit /b 1
)
if not exist "train_model.py" (
    echo [X] 缺少训练脚本
    pause
    exit /b 1
)
echo [OK] 训练脚本已就绪
echo.
echo [3/4] 准备训练数据...
if not exist "training_data" (
    echo [INFO] 创建训练数据...
    python data_processor.py
    if errorlevel 1 (
        echo [X] 数据创建失败
        pause
        exit /b 1
    )
) else (
    echo [OK] 训练数据已存在
)
echo.
echo [4/4] 开始训练...
echo.
echo 注意事项:
echo   - 训练可能需要较长时间（取决于CPU/GPU）
echo   - 训练过程中会显示进度条
echo   - 训练完成后会生成 feature-model.h5 文件
echo   - 按 Ctrl+C 可以中断训练
echo.
pause

python train_model.py

if errorlevel 1 (
    echo.
    echo [X] 训练失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo   训练完成！
echo ========================================
echo.
echo 生成的文件:
if exist "feature-model.h5" echo   [OK] feature-model.h5 (模型文件)
if exist "training_history.png" echo   [OK] training_history.png (训练曲线)
if exist "best_model.h5" echo   [OK] best_model.h5 (最佳模型)
echo.
echo 下一步:
echo   1. 将 feature-model.h5 复制到: backend\models\
echo   2. 重启后端服务
echo.
pause