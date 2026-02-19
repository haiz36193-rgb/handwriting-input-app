@echo off
chcp 65001 >nul
title 中文手写字符模型训练
echo ========================================
echo   中文手写字符模型训练
echo ========================================
echo.
echo [1/5] 检查Python环境...
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
echo [2/5] 检查训练脚本...
if not exist "model_architecture.py" (
    echo [X] 缺少模型架构文件
    pause
    exit /b 1
)
if not exist "train_chinese_model.py" (
    echo [X] 缺少训练脚本
    pause
    exit /b 1
)
echo [OK] 训练脚本已就绪
echo.
echo [3/5] 检查训练数据...
if not exist "training_data\labels.json" (
    echo [X] 未找到训练数据
    echo [INFO] 请先运行: 准备中文数据.bat
    pause
    exit /b 1
)
echo [OK] 训练数据已存在
echo.
echo [4/5] 显示训练配置...
echo.
echo 训练参数:
type config_chinese.json
echo.
echo 注意事项:
echo   - 中文字符识别需要更多训练轮数
echo   - 训练时间可能较长（取决于CPU/GPU）
echo   - 建议使用GPU加速
echo   - 训练过程中会显示进度条
echo   - 按 Ctrl+C 可以中断训练
echo.
pause
echo [5/5] 开始训练...
echo.
python train_chinese_model.py
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
if exist "chinese_model.h5" echo   [OK] chinese_model.h5 (模型文件)
if exist "best_chinese_model.h5" echo   [OK] best_chinese_model.h5 (最佳模型)
if exist "training_history_chinese.png" echo   [OK] training_history_chinese.png (训练曲线)
if exist "label_mapping.json" echo   [OK] label_mapping.json (标签映射)
echo.
echo 下一步:
echo   1. 将 chinese_model.h5 复制到: backend\models\
echo   2. 将 label_mapping.json 复制到: backend\models\
echo   3. 重启后端服务
echo.
pause