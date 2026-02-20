@echo off
REM Oracle Cloud 部署脚本 (Windows)
REM 用于自动化部署手写输入法APP到Oracle Cloud

setlocal enabledelayedexpansion

echo =============================================
echo Oracle Cloud 部署脚本
echo =============================================
echo.

REM 检查环境变量文件
if not exist .env (
    echo [错误] .env 文件不存在
    echo [信息] 正在创建 .env 文件...
    copy .env.example .env
    echo [信息] 请编辑 .env 文件，设置正确的密码和配置
    echo [信息] 编辑完成后重新运行此脚本
    pause
    exit /b 1
)

echo [信息] 检查Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker 未安装
    pause
    exit /b 1
)

echo [信息] 检查Docker Compose...
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo [错误] Docker Compose 未安装
    pause
    exit /b 1
)

echo [成功] 依赖检查通过
echo.

REM 构建后端
echo [信息] 构建后端服务...
cd backend
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [错误] 后端构建失败
    cd ..
    pause
    exit /b 1
)
cd ..
echo [成功] 后端构建成功
echo.

REM 启动服务
echo [信息] 启动Docker服务...
docker-compose -f docker-compose.oracle.yml up -d
if errorlevel 1 (
    echo [错误] 服务启动失败
    pause
    exit /b 1
)
echo [成功] 服务启动成功
echo.

REM 等待服务就绪
echo [信息] 等待服务启动...
timeout /t 30 /nobreak >nul

REM 检查健康状态
echo [信息] 检查服务健康状态...
curl -f http://localhost:8080/api/v1/health >nul 2>&1
if errorlevel 1 (
    echo [错误] 后端服务启动失败
    echo [信息] 查看日志:
    docker-compose -f docker-compose.oracle.yml logs backend
    pause
    exit /b 1
)
echo [成功] 后端服务已就绪
echo.

REM 显示服务状态
echo [信息] 服务状态:
docker-compose -f docker-compose.oracle.yml ps
echo.

REM 显示访问地址
echo [信息] 访问地址:
echo   后端API: http://localhost:8080
echo   健康检查: http://localhost:8080/api/v1/health
echo.

REM 显示管理命令
echo [信息] 管理命令:
echo   查看日志: docker-compose -f docker-compose.oracle.yml logs -f
echo   停止服务: docker-compose -f docker-compose.oracle.yml down
echo   重启服务: docker-compose -f docker-compose.oracle.yml restart
echo.

echo [成功] 部署完成！
echo.
pause