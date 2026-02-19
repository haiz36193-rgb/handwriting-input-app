# 需要用户配合完成的配置项

## 重要提示
以下功能已完成代码框架，但需要用户配合提供配置和资源后才能正常运行。请明早配合完成这些配置。

---

## 1. 阿里云OSS配置（优先级：高）

### 需要配置的文件
- `backend/src/main/resources/application.yml`

### 需要提供的信息
```
aliyun:
  oss:
    endpoint: oss-cn-hangzhou.aliyuncs.com  # 请替换为实际的endpoint
    accessKeyId: YOUR_ACCESS_KEY_ID         # 请提供实际的AccessKey ID
    accessKeySecret: YOUR_ACCESS_KEY_SECRET # 请提供实际的AccessKey Secret
    bucketName: handwriting-input-app        # 请创建实际的Bucket
    domain: https://cdn.handwriting-app.com  # 请配置实际的CDN域名
```

### 配置步骤
1. 登录阿里云控制台
2. 创建OSS Bucket
3. 获取AccessKey ID和Secret
4. 配置CORS规则（允许跨域访问）
5. 配置CDN加速（可选）

### 影响的功能
- 笔迹数据文件上传
- 笔迹图片存储
- 字体文件存储
- 预览图片存储

---

## 2. 深度学习模型文件（优先级：高）

### 需要提供的文件
- 笔迹特征识别模型文件（CNN+RNN模型）
- 模型格式建议：H5或PB格式
- 模型版本：v1.0.0

### 存放位置
```
backend/models/feature-model.h5
```

### 需要配置的文件
- `backend/src/main/resources/application.yml`

### 配置项
```yaml
app:
  feature:
    model-path: /models/feature-model.h5  # 模型文件路径
    extraction-timeout: 60
```

### 影响的功能
- 笔迹特征提取
- 特征识别服务

---

## 3. 字体渲染引擎（优先级：高）

### 需要安装的软件
- FontForge 或 freetype
- Python字体处理库（fontTools）

### 安装步骤
```bash
# Ubuntu/Debian
sudo apt-get install fontforge python3-fonttools

# CentOS/RHEL
sudo yum install fontforge python3-fonttools

# macOS
brew install fontforge
```

### Python依赖
```bash
pip install fontforge fonttools bezier
```

### 影响的功能
- 字体生成
- 贝塞尔曲线优化
- 字体格式转换

---

## 4. 图像处理依赖（优先级：中）

### 需要安装的库
- OpenCV
- Pillow
- numpy

### 安装步骤
```bash
pip install opencv-python pillow numpy
```

### 影响的功能
- 扫描文档预处理
- 图像去噪
- 笔迹提取
- 图像分割

---

## 5. 数据库配置（优先级：低）

### 当前配置
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/handwriting_input_app
    username: handwriting
    password: handwriting123
```

### 可选优化
- 配置主从复制（提高可用性）
- 配置读写分离（提高性能）
- 配置连接池参数

---

## 6. Redis配置（优先级：低）

### 当前配置
```yaml
spring:
  redis:
    host: localhost
    port: 6379
```

### 可选优化
- 配置Redis集群（提高可用性）
- 配置持久化策略
- 配置内存淘汰策略

---

## 配置检查清单

完成以上配置后，请检查以下清单：

- [ ] 阿里云OSS AccessKey已配置
- [ ] 阿里云OSS Bucket已创建
- [ ] OSS CORS规则已配置
- [ ] 深度学习模型文件已放置
- [ ] 字体渲染引擎已安装
- [ ] 图像处理库已安装
- [ ] 数据库连接正常
- [ ] Redis连接正常

---

## 快速测试步骤

配置完成后，执行以下步骤测试：

1. 启动后端服务
```bash
cd backend
mvn spring-boot:run
```

2. 测试用户注册
```bash
curl -X POST http://localhost:8080/api/v1/user/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138001","password":"123456","nickname":"测试用户"}'
```

3. 测试笔迹上传
```bash
curl -X POST http://localhost:8080/api/v1/handwriting/upload \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"collectionType":1,"characterCode":"U+4E2D","characterText":"中"}'
```

4. 测试字体生成
```bash
curl -X POST http://localhost:8080/api/v1/font/generate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"featureId":1,"fontName":"我的字体"}'
```

---

## 配置完成后通知

完成以上配置后，请告知我，我会继续完成以下工作：

1. 实现真实的文件上传功能
2. 实现真实的字体生成功能
3. 实现真实的特征提取功能
4. 完善前端页面的文件上传功能
5. 进行前后端联调测试

---

**创建时间**: 2026-01-30 00:30
**状态**: 等待用户配合配置