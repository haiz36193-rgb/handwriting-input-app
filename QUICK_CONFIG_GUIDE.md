# 快速配置指南

本文档将帮助您快速配置项目所需的环境和服务。

## 1. 阿里云OSS配置（必需）

### 步骤1：创建阿里云OSS Bucket

1. 登录阿里云控制台：https://oss.console.aliyun.com/
2. 点击"创建Bucket"
3. 填写配置：
   - Bucket名称：`handwriting-input-app`（或您自定义的名称）
   - 地域：选择离您最近的地域（如华东1-杭州）
   - 存储类型：标准存储
   - 读写权限：私有
4. 点击"确定"创建

### 步骤2：获取AccessKey

1. 访问：https://ram.console.aliyun.com/manage/ak
2. 创建AccessKey（如果没有）
3. 记录下 `AccessKey ID` 和 `AccessKey Secret`

### 步骤3：配置CORS规则

1. 在Bucket管理页面，点击"权限管理" → "跨域设置"
2. 点击"创建规则"
3. 填写配置：
   - 来源：`*`（或指定您的域名）
   - 允许Methods：`GET, POST, PUT, DELETE, HEAD`
   - 允许Headers：`*`
   - 暴露Headers：`ETag, x-oss-request-id`
   - 缓存时间：`600`
4. 点击"确定"

### 步骤4：更新配置文件

编辑 `backend/src/main/resources/application.yml`，更新以下配置：

```yaml
aliyun:
  oss:
    endpoint: oss-cn-hangzhou.aliyuncs.com  # 根据您选择的地域修改
    accessKeyId: YOUR_ACCESS_KEY_ID         # 替换为实际的AccessKey ID
    accessKeySecret: YOUR_ACCESS_KEY_SECRET # 替换为实际的AccessKey Secret
    bucketName: handwriting-input-app        # 替换为实际的Bucket名称
    domain: https://cdn.handwriting-app.com  # 如果配置了CDN，替换为CDN域名，否则使用OSS默认域名
```

### 步骤5：验证配置

启动后端服务后，测试文件上传接口：

```bash
curl -X POST http://localhost:8080/api/v1/file/upload/image \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/path/to/your/image.jpg"
```

---

## 2. 数据库配置（必需）

### 步骤1：安装MySQL

**Windows:**
```bash
# 下载并安装 MySQL 8.0
# https://dev.mysql.com/downloads/mysql/
```

**macOS:**
```bash
brew install mysql@8.0
brew services start mysql@8.0
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo systemctl start mysql
```

### 步骤2：创建数据库

```bash
mysql -u root -p
```

在MySQL命令行中执行：

```sql
CREATE DATABASE handwriting_input_app DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'handwriting'@'localhost' IDENTIFIED BY 'handwriting123';
GRANT ALL PRIVILEGES ON handwriting_input_app.* TO 'handwriting'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 步骤3：初始化数据库

```bash
cd C:\Users\Administrator\handwriting-input-app
mysql -u handwriting -p handwriting_input_app < scripts/init.sql
```

### 步骤4：更新配置文件

编辑 `backend/src/main/resources/application.yml`，更新数据库配置：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/handwriting_input_app?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: handwriting
    password: handwriting123
```

---

## 3. Redis配置（必需）

### 步骤1：安装Redis

**Windows:**
```bash
# 下载 Redis for Windows
# https://github.com/microsoftarchive/redis/releases
```

**macOS:**
```bash
brew install redis
brew services start redis
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install redis-server
sudo systemctl start redis
```

### 步骤2：验证Redis运行

```bash
redis-cli ping
# 应该返回 PONG
```

### 步骤3：更新配置文件

编辑 `backend/src/main/resources/application.yml`，更新Redis配置：

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password:  # 如果设置了密码，填写密码
    database: 0
```

---

## 4. 可选配置

### 4.1 深度学习模型（字体生成功能需要）

如果您需要使用真实的字体生成功能，需要：

1. 准备深度学习模型文件
2. 将模型文件放置在 `backend/models/` 目录
3. 更新配置：

```yaml
app:
  feature:
    model-path: /models/feature-model.h5
```

### 4.2 字体渲染引擎（字体生成功能需要）

```bash
# Ubuntu/Debian
sudo apt-get install fontforge python3-fonttools

# macOS
brew install fontforge
```

### 4.3 图像处理库

```bash
pip install opencv-python pillow numpy
```

---

## 5. 启动项目

### 启动后端

```bash
cd C:\Users\Administrator\handwriting-input-app\backend
mvn spring-boot:run
```

### 启动前端

```bash
cd C:\Users\Administrator\handwriting-input-app\frontend
flutter pub get
flutter run
```

---

## 6. 测试API

### 测试用户注册

```bash
curl -X POST http://localhost:8080/api/v1/user/register \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "13800138000",
    "password": "123456",
    "nickname": "测试用户"
  }'
```

### 测试用户登录

```bash
curl -X POST http://localhost:8080/api/v1/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "13800138000",
    "password": "123456"
  }'
```

### 测试文件上传

```bash
# 使用登录返回的token
curl -X POST http://localhost:8080/api/v1/file/upload/handwriting \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/path/to/your/image.jpg"
```

---

## 7. 常见问题

### Q1: 连接数据库失败

**A:** 检查以下几点：
- MySQL服务是否启动
- 数据库用户名和密码是否正确
- 数据库是否已创建
- 防火墙是否阻止了连接

### Q2: 连接Redis失败

**A:** 检查以下几点：
- Redis服务是否启动
- Redis端口是否正确（默认6379）
- 防火墙是否阻止了连接

### Q3: 文件上传失败

**A:** 检查以下几点：
- OSS配置是否正确
- AccessKey是否有效
- Bucket是否已创建
- CORS规则是否已配置

### Q4: 前端无法连接后端

**A:** 检查以下几点：
- 后端服务是否启动
- 后端端口是否正确（默认8080）
- 前端配置的baseUrl是否正确
- 防火墙是否阻止了连接

---

## 8. 配置检查清单

完成配置后，请检查以下清单：

- [ ] 阿里云OSS Bucket已创建
- [ ] OSS AccessKey已配置
- [ ] OSS CORS规则已配置
- [ ] MySQL已安装并启动
- [ ] 数据库已创建
- [ ] 数据库已初始化
- [ ] Redis已安装并启动
- [ ] 后端配置文件已更新
- [ ] 前端配置文件已更新
- [ ] 后端服务可以正常启动
- [ ] 前端应用可以正常启动
- [ ] 用户注册功能正常
- [ ] 用户登录功能正常
- [ ] 文件上传功能正常

---

## 9. 获取帮助

如果遇到问题：

1. 查看项目文档：`docs/` 目录
2. 查看日志文件：`logs/handwriting-input-app.log`
3. 检查配置文件：`backend/src/main/resources/application.yml`
4. 联系开发团队：dev@handwriting-app.com

---

**最后更新**: 2026-01-30
**版本**: 1.0.0