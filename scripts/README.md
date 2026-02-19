# 快速启动指南

## 🚀 三步启动项目

### 第一步：检查环境

双击运行：
```
scripts\check-config.bat
```

这会检查您的环境是否满足要求。

### 第二步：初始化数据库

双击运行：
```
scripts\init-database.bat
```

按照提示输入MySQL root密码，脚本会自动：
- 创建数据库
- 创建用户
- 导入初始化数据

### 第三步：配置OSS（可选）

如果需要使用文件上传功能，双击运行：
```
scripts\config-oss.bat
```

按照提示输入您的阿里云OSS信息。

## 📝 启动项目

### 方式一：同时启动前后端

双击运行：
```
scripts\start.bat
```

### 方式二：分别启动

启动后端：
```
scripts\start-backend.bat
```

启动前端：
```
scripts\start-frontend.bat
```

## 🔧 脚本说明

| 脚本 | 说明 |
|------|------|
| `check-config.bat` | 检查环境配置 |
| `init-database.bat` | 初始化数据库 |
| `config-oss.bat` | 配置阿里云OSS |
| `start.bat` | 同时启动前后端 |
| `start-backend.bat` | 只启动后端 |
| `start-frontend.bat` | 只启动前端 |

## ⚠️ 常见问题

### 问题1：MySQL连接失败

**解决方法**：
- 检查MySQL服务是否启动
- 检查root密码是否正确
- 确认MySQL端口是否为3306

### 问题2：Maven命令不存在

**解决方法**：
- 下载Maven：https://maven.apache.org/download.cgi
- 解压到本地目录
- 配置环境变量：`MAVEN_HOME` 和 `PATH`

### 问题3：Flutter命令不存在

**解决方法**：
- 下载Flutter SDK：https://flutter.dev/docs/get-started/install/windows
- 解压到本地目录
- 配置环境变量
- 运行 `flutter doctor` 检查环境

### 问题4：OSS配置后文件上传失败

**解决方法**：
- 确认AccessKey是否正确
- 确认Bucket是否创建成功
- **重要**：检查CORS规则是否配置
  - 进入Bucket管理 → 权限管理 → 跨域设置
  - 创建规则：
    - 来源：`*`
    - 允许Methods：`GET, POST, PUT, DELETE, HEAD`
    - 允许Headers：`*`
    - 暴露Headers：`ETag, x-oss-request-id`
    - 缓存时间：`600`

## 📊 默认配置

### 数据库
- 数据库名：`handwriting_input_app`
- 用户名：`handwriting`
- 密码：`handwriting123`

### 后端服务
- 地址：`http://localhost:8080`
- API文档：`http://localhost:8080/swagger-ui.html`

### 前端应用
- 在Flutter应用中自动连接后端

## 🎯 测试账号

首次启动后，您需要注册新账号：
- 手机号：任意11位数字
- 密码：至少6位

## 💡 提示

1. 首次启动Maven会下载依赖，可能需要几分钟
2. 建议先启动后端，等待完全启动后再启动前端
3. 如果端口被占用，可以在 `application.yml` 中修改端口
4. 查看日志了解详细运行信息

## 📞 获取帮助

如果遇到问题：
1. 查看 `QUICK_CONFIG_GUIDE.md`
2. 查看 `docs/TODO_NEED_USER_COLLABORATION.md`
3. 查看后端日志：`backend/logs/handwriting-input-app.log`

---

**开始使用**：双击 `scripts\check-config.bat` 开始检查环境！