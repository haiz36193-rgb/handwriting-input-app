# API接口设计文档

## 1. 接口概述

### 1.1 基础信息
- **基础URL**: `https://api.handwriting-app.com/api/v1`
- **协议**: HTTPS
- **数据格式**: JSON
- **字符编码**: UTF-8

### 1.2 通用响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1640784000000
}
```

### 1.3 状态码说明
| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 400 | 请求参数错误 |
| 401 | 未授权/Token失效 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

### 1.4 认证方式
- **方式**: JWT Token
- **请求头**: `Authorization: Bearer {token}`
- **Token有效期**: 7天

## 2. 用户服务接口

### 2.1 用户注册
**接口地址**: `POST /user/register`

**请求参数**:
```json
{
  "phone": "13800138000",
  "password": "123456",
  "nickname": "张三",
  "wechatOpenid": "wx_openid_123"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "userId": 1001,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "nickname": "张三"
  },
  "timestamp": 1640784000000
}
```

### 2.2 用户登录
**接口地址**: `POST /user/login`

**请求参数**:
```json
{
  "phone": "13800138000",
  "password": "123456"
}
```

或微信登录：
```json
{
  "wechatOpenid": "wx_openid_123"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "userId": 1001,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "nickname": "张三",
    "avatarUrl": "https://oss.example.com/avatar/1001.jpg"
  },
  "timestamp": 1640784000000
}
```

### 2.3 获取用户信息
**接口地址**: `GET /user/info`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "userId": 1001,
    "phone": "13800138000",
    "nickname": "张三",
    "avatarUrl": "https://oss.example.com/avatar/1001.jpg",
    "age": 30,
    "gender": 1,
    "occupation": "教师",
    "status": 1
  },
  "timestamp": 1640784000000
}
```

### 2.4 更新用户信息
**接口地址**: `PUT /user/info`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
  "nickname": "李四",
  "age": 31,
  "gender": 1,
  "occupation": "设计师"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "更新成功",
  "data": null,
  "timestamp": 1640784000000
}
```

## 3. 笔迹采集接口

### 3.1 上传手写笔迹数据
**接口地址**: `POST /handwriting/upload`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
  "collectionType": 1,
  "characterCode": "U+4E2D",
  "characterText": "中",
  "strokeSequence": [[1,2,3,4], [5,6,7,8]],
  "startPressure": 120.5,
  "endPressure": 98.3,
  "strokeArc": 45.2,
  "characterSpacing": 12.5,
  "writingSpeed": 15.8,
  "collectionDevice": "iPhone 14 Pro"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "handwritingId": 5001,
    "originalDataUrl": "https://oss.example.com/handwriting/1001/5001.dat",
    "imageUrl": "https://oss.example.com/handwriting/1001/5001.png",
    "qualityScore": 0.92
  },
  "timestamp": 1640784000000
}
```

### 3.2 上传扫描文档
**接口地址**: `POST /handwriting/scan-upload`

**请求头**: `Authorization: Bearer {token}`

**请求参数**: multipart/form-data
- `file`: 图片文件（支持JPG/PNG）
- `collectionDevice`: 采集设备

**响应示例**:
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "handwritingId": 5002,
    "originalDataUrl": "https://oss.example.com/handwriting/1001/5002.jpg",
    "extractedCharacters": [
      {
        "characterCode": "U+4E2D",
        "characterText": "中",
        "imageUrl": "https://oss.example.com/handwriting/1001/5002_1.png"
      }
    ]
  },
  "timestamp": 1640784000000
}
```

### 3.3 获取笔迹列表
**接口地址**: `GET /handwriting/list`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
- `page`: 页码（默认1）
- `pageSize`: 每页数量（默认20）
- `collectionType`: 采集类型（可选）

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 100,
    "page": 1,
    "pageSize": 20,
    "list": [
      {
        "handwritingId": 5001,
        "characterText": "中",
        "collectionType": 1,
        "imageUrl": "https://oss.example.com/handwriting/1001/5001.png",
        "qualityScore": 0.92,
        "createTime": "2026-01-29 10:00:00"
      }
    ]
  },
  "timestamp": 1640784000000
}
```

## 4. 笔迹特征识别接口

### 4.1 提取笔迹特征
**接口地址**: `POST /feature/extract`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
  "handwritingIds": [5001, 5002, 5003]
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "特征提取成功",
  "data": {
    "featureId": 6001,
    "modelVersion": "v1.0.0",
    "extractionTime": "2026-01-29 10:05:00",
    "featureData": {
      "strokePatterns": [...],
      "pressureDistribution": [...],
      "rhythmCharacteristics": [...]
    }
  },
  "timestamp": 1640784000000
}
```

### 4.2 获取用户笔迹特征
**接口地址**: `GET /feature/user`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "featureId": 6001,
    "modelVersion": "v1.0.0",
    "extractionTime": "2026-01-29 10:05:00",
    "featureData": {...}
  },
  "timestamp": 1640784000000
}
```

## 5. 字体生成接口

### 5.1 生成字体
**接口地址**: `POST /font/generate`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
  "featureId": 6001,
  "fontName": "我的手写字体",
  "fontType": "ttf",
  "beautifyMode": 1,
  "fontSizeRange": "12-72"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "字体生成任务已提交",
  "data": {
    "fontId": 7001,
    "generateStatus": 0,
    "estimatedTime": 180
  },
  "timestamp": 1640784000000
}
```

### 5.2 查询字体生成状态
**接口地址**: `GET /font/status/{fontId}`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "fontId": 7001,
    "fontName": "我的手写字体",
    "generateStatus": 1,
    "progress": 100,
    "fontUrl": "https://oss.example.com/font/1001/7001.ttf",
    "previewImageUrl": "https://oss.example.com/font/1001/7001_preview.png",
    "similarityScore": 0.95
  },
  "timestamp": 1640784000000
}
```

### 5.3 获取用户字体列表
**接口地址**: `GET /font/list`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 5,
    "list": [
      {
        "fontId": 7001,
        "fontName": "我的手写字体",
        "fontType": "ttf",
        "previewImageUrl": "https://oss.example.com/font/1001/7001_preview.png",
        "similarityScore": 0.95,
        "isDefault": 1,
        "generateStatus": 1,
        "createTime": "2026-01-29 10:00:00"
      }
    ]
  },
  "timestamp": 1640784000000
}
```

### 5.4 设置默认字体
**接口地址**: `PUT /font/default/{fontId}`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "设置成功",
  "data": null,
  "timestamp": 1640784000000
}
```

### 5.5 下载字体
**接口地址**: `GET /font/download/{fontId}`

**请求头**: `Authorization: Bearer {token}`

**响应**: 文件流（application/octet-stream）

## 6. 字体分享接口

### 6.1 创建分享链接
**接口地址**: `POST /share/create`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:
```json
{
  "fontId": 7001,
  "shareType": 1,
  "expireTime": "2026-02-29 23:59:59"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "shareId": 8001,
    "shareCode": "SHARE_ABC123",
    "shareUrl": "https://app.handwriting-app.com/share/SHARE_ABC123"
  },
  "timestamp": 1640784000000
}
```

### 6.2 获取分享信息
**接口地址**: `GET /share/info/{shareCode}`

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "shareId": 8001,
    "shareCode": "SHARE_ABC123",
    "fontName": "我的手写字体",
    "previewImageUrl": "https://oss.example.com/font/1001/7001_preview.png",
    "authorNickname": "张三",
    "viewCount": 100,
    "downloadCount": 50
  },
  "timestamp": 1640784000000
}
```

## 7. 系统配置接口

### 7.1 获取系统配置
**接口地址**: `GET /config`

**请求参数**:
- `keys`: 配置键列表（多个用逗号分隔）

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "maxHandwritingCount": 2000,
    "fontGenerateTimeout": 300,
    "supportedFontTypes": ["ttf", "otf"]
  },
  "timestamp": 1640784000000
}
```

## 8. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 1001 | 用户已存在 |
| 1002 | 用户不存在 |
| 1003 | 密码错误 |
| 1004 | Token已过期 |
| 2001 | 笔迹数据格式错误 |
| 2002 | 笔迹质量不达标 |
| 2003 | 笔迹数据不存在 |
| 3001 | 特征提取失败 |
| 3002 | 特征数据不存在 |
| 4001 | 字体生成失败 |
| 4002 | 字体不存在 |
| 4003 | 字体生成中 |
| 5001 | 分享链接不存在 |
| 5002 | 分享链接已过期 |

---

**文档版本**: v1.0
**创建日期**: 2026-01-29
**最后更新**: 2026-01-29
**维护人员**: 开发团队