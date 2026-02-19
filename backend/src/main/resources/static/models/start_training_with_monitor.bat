@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 启动训练 + 2小时监控
echo ========================================
echo.

cd /d "C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\static\models"

echo [1/2] 启动2小时进度监控...
start powershell -NoExit -ExecutionPolicy Bypass -File "monitor_training_2hour.ps1"

echo [2/2] 启动模型训练...
python train_optimized.py

echo.
echo ========================================
echo 训练完成或中断
echo ========================================
pause