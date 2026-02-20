# Oracle Cloud 免费部署指南

## 📋 部署概述

本指南将帮助您将个性化手写输入法APP部署到Oracle Cloud免费层。

**Oracle Cloud Free Tier包含：**
- ✅ 2个AMD Compute实例（各4 OCPU + 24GB内存）
- ✅ 4个ARM Ampere A1实例（各4 OCPU + 24GB内存）
- ✅ 200GB块存储
- ✅ 2个Oracle Autonomous Database（各20GB）
- ✅ 10TB/月出站流量
- ✅ **永久免费**（信用卡验证后）

---

## 🎯 部署架构

```
Oracle Cloud
├── Compute Instance (Always Free)
│   ├── Ubuntu 22.04 LTS (ARM)
│   ├── Docker
│   ├── Docker Compose
│   ├── MySQL 8.0 (容器)
│   ├── Redis 7.0 (容器)
│   └── Spring Boot应用 (容器)
└── Object Storage (免费200GB)
    └── 静态文件存储
```

---

## 📝 前置要求

### 1. Oracle Cloud账户
- 访问：https://www.oracle.com/cloud/free/
- 注册Oracle Cloud账户
- 需要信用卡验证（不会扣费）

### 2. SSH密钥
```bash
# 生成SSH密钥（如果没有）
ssh-keygen -t rsa -b 4096 -C "oracle@handwriting-app.com"

# 保存公钥位置
# Windows: C:\Users\YourName\.ssh\id_rsa.pub
# Linux/Mac: ~/.ssh/id_rsa.pub
```

### 3. 本地工具
- SSH客户端（PuTTY或OpenSSH）
- SCP/SFTP客户端
- 浏览器

---

## 🚀 部署步骤

### 步骤1: 创建Oracle Cloud账户

1. 访问 https://www.oracle.com/cloud/free/
2. 点击"Try Free"
3. 填写账户信息
4. 添加信用卡验证（仅验证，不扣费）
5. 完成邮箱验证

### 步骤2: 创建SSH密钥

```bash
# 在本地终端执行
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 查看公钥
cat ~/.ssh/id_rsa.pub  # Linux/Mac
type %USERPROFILE%\.ssh\id_rsa.pub  # Windows
```

**复制公钥内容，稍后需要使用。**

### 步骤3: 创建Compute实例

1. 登录Oracle Cloud Console
2. 打开菜单 → Compute → Instances
3. 点击"Create Instance"
4. 填写以下信息：

**基本信息：**
- Name: `handwriting-app-server`
- Compartment: 选择您的compartment

**实例类型：**
- Shape: 选择 `VM.Standard.E4.Flex` (Always Free)
  - OCPU数: 4
  - 内存: 24GB

**操作系统：**
- Image: Ubuntu 22.04 Minimal
- Version: 最新版本

**SSH密钥：**
- 选择"Paste SSH Keys"
- 粘贴之前生成的公钥

**网络：**
- VCN: 创建新的VCN
- Subnet: 公有子网
- Public IP: 分配公网IP

5. 点击"Create"
6. 等待实例创建（约5-10分钟）

### 步骤4: 连接到实例

```bash
# Linux/Mac
ssh -i ~/.ssh/id_rsa ubuntu@<public-ip>

# Windows (PowerShell)
ssh -i C:\Users\YourName\.ssh\id_rsa ubuntu@<public-ip>

# Windows (PuTTY)
# 1. 使用PuTTYgen转换私钥
# 2. 连接到 <public-ip>
# 3. 用户名: ubuntu
```

### 步骤5: 安装Docker

```bash
# 连接到实例后执行

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 添加当前用户到docker组
sudo usermod -aG docker ubuntu

# 重新登录使权限生效
exit
# 重新SSH连接

# 验证安装
docker --version
docker-compose --version
```

### 步骤6: 上传项目文件

```bash
# 在本地执行
scp -i ~/.ssh/id_rsa -r C:/Users/Administrator/handwriting-input-app ubuntu@<public-ip>:/home/ubuntu/

# 或使用WinSCP、FileZilla等SFTP工具
```

### 步骤7: 配置项目

```bash
# 连接到实例
cd /home/ubuntu/handwriting-input-app

# 修改环境变量
nano backend/src/main/resources/application-prod.yml
```

**配置内容：**
```yaml
spring:
  datasource:
    url: jdbc:mysql://mysql:3306/handwriting_input_app?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: handwriting
    password: ${MYSQL_ROOT_PASSWORD}
  redis:
    host: redis
    port: 6379

server:
  port: 8080

logging:
  level:
    com.handwriting: INFO
```

### 步骤8: 创建docker-compose.yml

```bash
nano docker-compose.yml
```

**内容：**
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: handwriting-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: handwriting_input_app
      MYSQL_USER: handwriting
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
      - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"
    restart: always

  redis:
    image: redis:7.0
    container_name: handwriting-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: always

  backend:
    build: ./backend
    container_name: handwriting-backend
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    depends_on:
      - mysql
      - redis
    restart: always

volumes:
  mysql-data:
  redis-data:
```

### 步骤9: 创建.env文件

```bash
nano .env
```

**内容：**
```env
MYSQL_ROOT_PASSWORD=YourStrongRootPassword123!
MYSQL_PASSWORD=YourStrongPassword123!
```

### 步骤10: 启动服务

```bash
# 构建后端JAR
cd backend
mvn clean package -DskipTests
cd ..

# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f backend

# 等待服务启动（约2-3分钟）
```

### 步骤11: 初始化数据库

```bash
# 进入MySQL容器
docker exec -it handwriting-mysql mysql -uroot -p

# 输入root密码

# 执行初始化脚本
source /docker-entrypoint-initdb.d/init.sql;

# 退出
exit
```

### 步骤12: 配置安全组

1. 在Oracle Cloud Console
2. 打开 Networking → Virtual Cloud Networks
3. 选择您的VCN
4. 打开Security Lists
5. 添加入站规则：

```
源类型: CIDR
源CIDR: 0.0.0.0/0
IP协议: TCP
目标端口范围: 8080
描述: HTTP API
```

```
源类型: CIDR
源CIDR: 0.0.0.0/0
IP协议: TCP
目标端口范围: 22
描述: SSH
```

### 步骤13: 测试部署

```bash
# 测试健康检查
curl http://<public-ip>:8080/api/v1/health

# 应该返回:
# {"status":"UP","timestamp":"...","service":"handwriting-input-app","version":"1.0.0"}

# 测试用户注册
curl -X POST http://<public-ip>:8080/api/v1/user/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138001","password":"123456","nickname":"测试用户"}'
```

---

## 📱 配置前端

### 修改API地址

```bash
# 在本地
cd C:/Users/Administrator/handwriting-input-app/frontend
nano lib/utils/app_config.dart
```

**修改：**
```dart
static const String baseUrl = 'http://<public-ip>:8080/api/v1';
```

### 重新编译APK

```bash
cd C:/Users/Administrator/handwriting-input-app/frontend
flutter build apk --release
```

### 获取APK文件

位置：`C:\Users\Administrator\handwriting-input-app\frontend\build\app\outputs\flutter-apk\app-release.apk`

---

## 🔧 常用管理命令

### 查看服务状态
```bash
docker-compose ps
```

### 查看日志
```bash
docker-compose logs -f backend
docker-compose logs -f mysql
docker-compose logs -f redis
```

### 重启服务
```bash
docker-compose restart backend
```

### 停止服务
```bash
docker-compose down
```

### 启动服务
```bash
docker-compose up -d
```

### 更新代码
```bash
# 在本地提交更改
cd C:/Users/Administrator/handwriting-input-app
git add .
git commit -m "Update"
git push

# 在服务器上拉取
ssh ubuntu@<public-ip>
cd /home/ubuntu/handwriting-input-app
git pull

# 重新构建
docker-compose down
docker-compose build backend
docker-compose up -d
```

---

## 🔒 安全建议

1. **修改SSH端口**
```bash
sudo nano /etc/ssh/sshd_config
# 修改 Port 22 为其他端口
sudo systemctl restart sshd
```

2. **配置防火墙**
```bash
sudo ufw enable
sudo ufw allow 8080/tcp
sudo ufw allow <your-ssh-port>/tcp
```

3. **定期备份**
```bash
# 备份数据库
docker exec handwriting-mysql mysqldump -uroot -p handwriting_input_app > backup.sql

# 备份到本地
scp ubuntu@<public-ip>:/home/ubuntu/backup.sql .
```

4. **监控资源使用**
```bash
# CPU和内存
htop

# 磁盘使用
df -h

# Docker资源
docker stats
```

---

## 💰 费用监控

### 免费资源限制
- 2个OCPUs (计算实例)
- 24GB内存
- 200GB块存储
- 2个Autonomous Database
- 10TB/月出站流量

### 查看使用情况
1. 登录Oracle Cloud Console
2. 打开 Billing & Cost Management
3. 查看Cost Analysis

### 超出免费额度的费用
- 附加OCPUs: $0.0476/小时
- 附加内存: $0.006/GB/小时
- 附加存储: $0.0255/GB/月
- 出站流量: $0.0085/GB

---

## 📊 性能优化

### 1. MySQL优化
```yaml
# docker-compose.yml中添加
command: --max_connections=200 --innodb_buffer_pool_size=1G
```

### 2. Redis优化
```yaml
# docker-compose.yml中添加
command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
```

### 3. JVM优化
```yaml
# docker-compose.yml中添加
environment:
  - JAVA_OPTS=-Xmx1g -Xms512m
```

---

## 🆘 故障排除

### 问题1: 无法连接到实例
```bash
# 检查安全组规则
# 确认SSH端口已开放
# 检查防火墙状态
```

### 问题2: MySQL连接失败
```bash
# 检查MySQL容器状态
docker-compose logs mysql

# 检查网络连接
docker exec handwriting-backend ping mysql
```

### 问题3: 内存不足
```bash
# 检查内存使用
free -h

# 清理Docker缓存
docker system prune -a
```

### 问题4: 磁盘空间不足
```bash
# 检查磁盘使用
df -h

# 清理旧日志
docker exec handwriting-backend rm -rf /app/logs/*
```

---

## 📚 相关文档

- Oracle Cloud文档: https://docs.oracle.com/en-us/iaas/
- Docker文档: https://docs.docker.com/
- Spring Boot文档: https://spring.io/projects/spring-boot

---

## ✅ 部署检查清单

- [ ] Oracle Cloud账户已创建
- [ ] SSH密钥已生成
- [ ] Compute实例已创建
- [ ] Docker已安装
- [ ] 项目文件已上传
- [ ] docker-compose.yml已配置
- [ ] .env文件已创建
- [ ] 服务已启动
- [ ] 数据库已初始化
- [ ] 安全组已配置
- [ ] 健康检查通过
- [ ] 前端APK已重新编译
- [ ] API地址已更新

---

## 🎉 部署完成

恭喜！您的个性化手写输入法APP已成功部署到Oracle Cloud免费层。

**访问地址：** http://<public-ip>:8080

**管理面板：** https://console.oraclecloud.com

---

**创建时间：** 2026-02-20
**文档版本：** 1.0.0