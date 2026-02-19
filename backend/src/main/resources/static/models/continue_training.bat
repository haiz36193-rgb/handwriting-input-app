@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 继续模型训练 - 从Step 23000开始
echo ========================================
echo.

cd /d "C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\static\models"

echo 当前目录: %CD%
echo.

echo 启动训练脚本...
python train_optimized.py

echo.
echo ========================================
echo 训练完成或中断
echo ========================================
pause