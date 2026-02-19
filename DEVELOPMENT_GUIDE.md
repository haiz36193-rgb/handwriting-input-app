# 开发指南

## 项目简介

个性化手写输入法APP - 一个基于手写笔迹生成个性化字体的移动应用。

## 技术栈

### 后端
- **框架**: Spring Boot 2.7.18
- **数据库**: MySQL 8.0 + MyBatis Plus
- **缓存**: Redis
- **认证**: JWT
- **构建工具**: Maven

### 前端
- **框架**: Flutter 3.x
- **状态管理**: Provider
- **网络请求**: Dio
- **语言**: Dart

## 快速开始

### 环境要求

- **JDK**: 11+
- **Maven**: 3.6+
- **Flutter**: 3.0+
- **MySQL**: 8.0+
- **Redis**: 6.0+

### 后端启动

1. 配置数据库连接（`backend/src/main/resources/application.yml`）

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/handwriting_app?useSSL=false&serverTimezone=UTC
    username: root
    password: your_password
```

2. 初始化数据库

```bash
mysql -u root -p < scripts/init.sql
```

3. 启动后端服务

```bash
cd backend
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动

### 前端启动

1. 安装依赖

```bash
cd frontend
flutter pub get
```

2. 启动应用

```bash
flutter run
```

## 项目结构

### 后端目录结构

```
backend/
├── src/main/java/com/handwriting/
│   ├── controller/        # API控制器
│   ├── service/           # 业务逻辑层
│   ├── repository/        # 数据访问层
│   ├── model/             # 数据模型
│   ├── config/            # 配置类
│   ├── util/              # 工具类
│   └── exception/         # 异常处理
└── src/main/resources/
    ├── application.yml    # 配置文件
    └── mapper/            # MyBatis映射文件
```

### 前端目录结构

```
frontend/
├── lib/
│   ├── pages/             # 页面
│   ├── widgets/           # 组件
│   ├── services/          # 服务层
│   ├── providers/         # 状态管理
│   ├── models/            # 数据模型
│   └── utils/             # 工具类
└── assets/                # 资源文件
```

## 开发规范

### 后端开发规范

1. **RESTful API设计**
   - 使用标准的HTTP方法（GET、POST、PUT、DELETE）
   - 统一的响应格式（Result<T>）
   - 使用HTTP状态码表示请求状态

2. **代码结构**
   - Controller层：处理HTTP请求
   - Service层：业务逻辑
   - Mapper层：数据访问

3. **异常处理**
   - 使用全局异常处理器
   - 返回统一的错误信息

### 前端开发规范

1. **组件设计**
   - 使用有意义的组件名称
   - 组件应该单一职责
   - 使用Provider进行状态管理

2. **代码组织**
   - 页面放在 `pages/` 目录
   - 可复用组件放在 `widgets/` 目录
   - 服务层放在 `services/` 目录

3. **样式规范**
   - 使用Material Design组件
   - 保持一致的配色方案
   - 使用响应式布局

## API文档

### 用户相关

- `POST /api/v1/user/register` - 用户注册
- `POST /api/v1/user/login` - 用户登录
- `GET /api/v1/user/info` - 获取用户信息
- `PUT /api/v1/user/info` - 更新用户信息

### 手写相关

- `POST /api/v1/handwriting/upload` - 上传手写笔迹
- `GET /api/v1/handwriting/list` - 获取笔迹列表
- `DELETE /api/v1/handwriting/{id}` - 删除笔迹

### 字体相关

- `POST /api/v1/font/generate` - 生成字体
- `GET /api/v1/font/status/{id}` - 查询字体状态
- `GET /api/v1/font/list` - 获取字体列表
- `PUT /api/v1/font/default/{id}` - 设置默认字体
- `DELETE /api/v1/font/{id}` - 删除字体

## 测试

### 后端测试

```bash
cd tests/backend
python -m pytest
```

### 前端测试

```bash
cd frontend
flutter test
```

## 部署

### Docker部署

```bash
docker-compose up -d
```

### 手动部署

1. 构建后端

```bash
cd backend
mvn clean package
java -jar target/handwriting-input-app-1.0.0.jar
```

2. 构建前端

```bash
cd frontend
flutter build apk
```

## 常见问题

### 后端启动失败

- 检查MySQL是否启动
- 检查数据库连接配置
- 检查端口是否被占用

### 前端启动失败

- 检查Flutter环境是否正确配置
- 检查依赖是否正确安装
- 检查设备是否正确连接

## 贡献指南

1. Fork项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 许可证

本项目采用MIT许可证。