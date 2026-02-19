@echo off
chcp 65001 >nul
echo ========================================
echo   个性化手写输入法APP - Railway部署
echo ========================================
echo.

echo [1/6] 检查是否已初始化Git仓库...
if not exist .git (
    echo [√] 初始化Git仓库...
    git init
    git add .
    git commit -m "Initial commit for Railway deployment"
) else (
    echo [√] Git仓库已存在
)

echo.
echo [2/6] 复制Railway配置文件...
copy backend\railway-Dockerfile backend\Dockerfile /Y >nul
copy backend\railway-prod.yml backend\src\main\resources\application-railway.yml /Y >nul
echo [√] 配置文件已复制

echo.
echo [3/6] 复制健康检查控制器...
copy backend\railway-health-controller.java backend\src\main\java\com\handwriting\controller\HealthController.java /Y >nul
echo [√] 健康检查控制器已添加

echo.
echo [4/6] 重新编译后端项目...
cd backend
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo [×] 编译失败！
    pause
    exit /b 1
)
cd ..
echo [√] 编译成功

echo.
echo [5/6] 更新Git仓库...
git add .
git commit -m "Update for Railway deployment"
echo [√] Git仓库已更新

echo.
echo [6/6] 部署说明...
echo.
echo ========================================
echo   下一步操作：
echo ========================================
echo.
echo 1. 在浏览器中打开：https://railway.app/
echo 2. 使用GitHub账号登录
echo 3. 创建新项目
echo 4. 选择 "Deploy from GitHub repo"
echo 5. 选择此项目的仓库
echo 6. 添加MySQL数据库服务
echo 7. 添加Redis缓存服务
echo 8. 添加后端服务
echo 9. 配置环境变量（参考云端部署指南.txt）
echo 10. 点击Deploy开始部署
echo.
echo ========================================
echo   重要环境变量：
echo ========================================
echo.
echo DATABASE_URL=jdbc:mysql://^<mysql-host^>:3306/handwriting_input_app?...
echo DATABASE_USERNAME=^<mysql-username^>
echo DATABASE_PASSWORD=^<mysql-password^>
echo REDIS_HOST=^<redis-host^>
echo REDIS_PORT=6379
echo JWT_SECRET=your-strong-secret-key-here
echo.
echo ========================================
echo   部署完成后：
echo ========================================
echo.
echo 1. Railway会自动分配域名（如：*.railway.app）
echo 2. 记录分配的域名
echo 3. 修改前端配置文件：frontend\lib\utils\app_config.dart
echo 4. 将baseUrl改为：https://^<your-domain^>.railway.app/api/v1
echo 5. 重新编译APK：flutter build apk --release
echo 6. 分发新的APK给测试用户
echo.
pause