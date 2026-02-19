@echo off
chcp 65001 >nul
title 下载中文手写字迹数据集
echo ========================================
echo   下载中文手写字迹数据集
echo ========================================
echo.
echo 可选数据集:
echo   [1] CASIA-HWDB（中科院，最权威）
echo   [2] Kaggle中文手写字符数据集
echo   [3] HIT-SYC（哈工大）
echo   [4] SCUT-COUCH（华南理工）
echo.
set /p choice="请选择数据集 (1-4): "

if "%choice%"=="1" goto casia
if "%choice%"=="2" goto kaggle
if "%choice%"=="3" goto hit
if "%choice%"=="4" goto scut
echo 无效选择！
pause
exit /b 1

:casia
echo.
echo ========================================
echo   CASIA-HWDB 中文手写数据集
echo ========================================
echo.
echo 数据集信息:
echo   - 来源: 中科院自动化实验室 (NLPR)
echo   - 字符数: 3755个一级汉字
echo   - 样本数: 约100万+ 手写样本
echo   - 类型: 离线手写 (图像格式)
echo.
echo 下载地址: https://nlpr.ia.ac.cn/databases/handwriting/Download.html
echo.
echo 注意事项:
echo   - 需要注册账号才能下载
echo   - 下载需要接受使用协议
echo   - 数据集较大（约1-2GB）
echo.
echo 下载步骤:
echo   1. 访问上述网址
echo   2. 注册账号并登录
echo   3. 选择 HWDB1.0-1.2 离线字符数据集
echo   4. 下载数据文件
echo   5. 解压到 chinese_data 目录
echo.
pause
exit /b 0

:kaggle
echo.
echo ========================================
echo   Kaggle中文手写字符数据集
echo ========================================
echo.
echo 数据集信息:
echo   - 来源: Kaggle社区
echo   - 基于CASIA-HWDB数据集
echo   - 字符数: 3755个一级汉字
echo   - 样本数: 约50万+ 手写样本
echo.
echo 下载地址:
echo   https://www.kaggle.com/datasets/pascalbliem/handwritten-chinese-character-hanzi-datasets
echo.
echo 下载方法:
echo   1. 访问上述网址
echo   2. 登录Kaggle账号
echo   3. 点击"Download"按钮
echo   4. 解压到 chinese_data 目录
echo.
echo 或使用Kaggle命令行工具:
echo   pip install kaggle
echo   kaggle datasets download -d pascalbliem/handwritten-chinese-character-hanzi-datasets
echo.
pause
exit /b 0

:hit
echo.
echo ========================================
echo   HIT-SYC 中文手写数据集
echo ========================================
echo.
echo 数据集信息:
echo   - 来源: 哈尔滨工业大学
echo   - 字符数: 常用汉字
echo   - 样本数: 约10万+ 手写样本
echo   - 类型: 在线手写（笔画轨迹）
echo.
echo 下载地址:
echo   需要联系哈工大实验室获取
echo   http://www.hit.edu.cn/
echo.
pause
exit /b 0

:scut
echo.
echo ========================================
echo   SCUT-COUCH 中文手写数据集
echo ========================================
echo.
echo 数据集信息:
echo   - 来源: 华南理工大学
echo   - 字符数: 3740个汉字
echo   - 样本数: 约40万+ 手写样本
echo   - 类型: 在线+离线混合
echo.
echo 下载地址:
echo   https://github.com/HCIILAB/SCUT-COUCH
echo.
pause
exit /b 0