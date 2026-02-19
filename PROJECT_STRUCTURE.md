# 个性化手写输入法APP - 项目结构

## 项目概述
项目名称：个性化手写输入法APP
开发周期：12周（3-4个月）
技术栈：Java + Spring Boot + Flutter

## 目录结构

```
handwriting-input-app/
├── docs/                    # 项目文档
│   ├── architecture.md      # 技术架构设计文档
│   ├── database.md          # 数据库设计文档
│   ├── api.md               # API接口设计文档
│   └── progress.md          # 开发进度记录
├── backend/                 # 后端服务
│   ├── src/
│   │   └── main/
│   │       ├── java/com/handwriting/
│   │       │   ├── controller/    # 控制器层
│   │       │   ├── service/       # 服务层
│   │       │   ├── model/         # 数据模型
│   │       │   ├── repository/    # 数据访问层
│   │       │   └── config/        # 配置类
│   │       └── resources/
│   │           ├── application.yml
│   │           └── mapper/        # MyBatis映射文件
│   └── pom.xml               # Maven配置文件
├── frontend/                # 前端应用
│   ├── lib/                 # Dart源代码
│   │   ├── main.dart
│   │   ├── pages/           # 页面
│   │   ├── widgets/         # 组件
│   │   ├── services/        # 服务
│   │   └── models/          # 数据模型
│   ├── assets/              # 资源文件
│   └── pubspec.yaml         # Flutter配置文件
├── scripts/                 # 部署脚本
│   ├── deploy.sh            # 部署脚本
│   └── setup.sh             # 环境搭建脚本
└── tests/                   # 测试文件
    ├── backend/             # 后端测试
    └── frontend/            # 前端测试
```

## 开发计划

### 第一阶段：技术准备（第1-2周）
- [x] 创建项目目录结构
- [ ] 编写技术架构设计文档
- [ ] 设计数据库架构文档
- [ ] 编写API接口设计文档

### 第二阶段：后端开发（第3-8周）
- [ ] 用户服务模块
- [ ] 笔迹采集服务
- [ ] 特征识别服务
- [ ] 字体生成服务

### 第三阶段：前端开发（第3-8周，与后端并行）
- [ ] 用户注册登录界面
- [ ] 手写采集界面
- [ ] 字体预览管理界面

### 第四阶段：测试与部署（第9-12周）
- [ ] 编写测试用例
- [ ] 编写部署文档
- [ ] 集成测试

## 进度追踪
最后更新：2026-01-29
当前阶段：技术准备
完成任务：1/13