@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ========================================
echo 最大性能训练方案
echo ========================================
echo.
echo 训练配置:
echo   - 总字符数: 13,065 (全部)
echo   - 总样本数: 261,300 (全部)
echo   - 批次大小: 512 (超大)
echo   - 混合精度训练: 已启用
echo   - XLA优化: 已启用
echo   - 多进程加载: 已启用
echo   - 训练轮数: 20轮
echo   - 预计时间: 1-2小时
echo.
echo 开始训练...
echo.
python train_max_performance.py
echo.
echo ========================================
echo 训练完成
echo ========================================
pause