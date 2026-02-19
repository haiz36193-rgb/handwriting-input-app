# 数据库设计文档

## 1. 数据库概述

### 1.1 数据库选型
- **类型**: MySQL 8.0
- **架构**: 主从复制（Master-Slave）
- **字符集**: utf8mb4
- **存储引擎**: InnoDB

### 1.2 命名规范
- 表名：小写字母+下划线，如 `user_info`
- 字段名：小写字母+下划线，如 `user_id`
- 主键：统一使用 `id`
- 时间戳：`create_time`, `update_time`
- 逻辑删除：`is_deleted`（0=未删除，1=已删除）

## 2. 数据库表设计

### 2.1 用户表 (user_info)
存储用户基本信息

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| phone | VARCHAR | 20 | YES | NULL | 手机号 |
| wechat_openid | VARCHAR | 100 | YES | NULL | 微信OpenID |
| nickname | VARCHAR | 50 | YES | NULL | 昵称 |
| avatar_url | VARCHAR | 255 | YES | NULL | 头像URL |
| password | VARCHAR | 255 | YES | NULL | 密码（BCrypt加密） |
| salt | VARCHAR | 50 | YES | NULL | 密码盐值 |
| age | INT | 11 | YES | NULL | 年龄 |
| gender | TINYINT | 4 | YES | 0 | 性别（0=未知，1=男，2=女） |
| occupation | VARCHAR | 50 | YES | NULL | 职业 |
| status | TINYINT | 4 | NO | 1 | 状态（0=禁用，1=正常） |
| last_login_time | DATETIME | - | YES | NULL | 最后登录时间 |
| last_login_ip | VARCHAR | 50 | YES | NULL | 最后登录IP |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| is_deleted | TINYINT | 4 | NO | 0 | 是否删除 |

**索引**:
- PRIMARY KEY (`id`)
- UNIQUE KEY `uk_phone` (`phone`)
- UNIQUE KEY `uk_wechat_openid` (`wechat_openid`)
- KEY `idx_status` (`status`)
- KEY `idx_create_time` (`create_time`)

### 2.2 笔迹数据表 (handwriting_data)
存储用户手写笔迹原始数据

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | 20 | NO | - | 用户ID |
| collection_type | TINYINT | 4 | NO | 1 | 采集类型（1=直接手写，2=扫描文档） |
| character_code | VARCHAR | 10 | NO | - | 汉字编码 |
| character_text | VARCHAR | 10 | NO | - | 汉字内容 |
| stroke_sequence | JSON | - | YES | NULL | 笔画顺序 |
| start_pressure | DECIMAL | 5,2 | YES | NULL | 起笔力度（0-255） |
| end_pressure | DECIMAL | 5,2 | YES | NULL | 收笔力度（0-255） |
| stroke_arc | DECIMAL | 5,2 | YES | NULL | 连笔弧度（度） |
| character_spacing | DECIMAL | 5,2 | YES | NULL | 字间距 |
| writing_speed | DECIMAL | 5,2 | YES | NULL | 书写速度 |
| original_data_url | VARCHAR | 255 | YES | NULL | 原始数据URL |
| image_url | VARCHAR | 255 | YES | NULL | 笔迹图片URL |
| quality_score | DECIMAL | 3,2 | YES | NULL | 质量评分（0-1） |
| collection_device | VARCHAR | 100 | YES | NULL | 采集设备 |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| is_deleted | TINYINT | 4 | NO | 0 | 是否删除 |

**索引**:
- PRIMARY KEY (`id`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_character_code` (`character_code`)
- KEY `idx_collection_type` (`collection_type`)
- KEY `idx_create_time` (`create_time`)

### 2.3 笔迹特征表 (handwriting_feature)
存储提取的笔迹特征数据

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | 20 | NO | - | 用户ID |
| feature_data | JSON | - | YES | NULL | 特征数据（JSON格式） |
| model_version | VARCHAR | 50 | YES | NULL | 模型版本 |
| extraction_time | DATETIME | - | YES | NULL | 特征提取时间 |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| is_deleted | TINYINT | 4 | NO | 0 | 是否删除 |

**索引**:
- PRIMARY KEY (`id`)
- UNIQUE KEY `uk_user_id` (`user_id`)
- KEY `idx_model_version` (`model_version`)

### 2.4 字体表 (user_font)
存储用户生成的字体信息

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | 20 | NO | - | 用户ID |
| font_name | VARCHAR | 50 | NO | - | 字体名称 |
| font_type | VARCHAR | 20 | NO | 'ttf' | 字体类型（ttf/otf） |
| font_url | VARCHAR | 255 | NO | - | 字体文件URL |
| preview_image_url | VARCHAR | 255 | YES | NULL | 预览图片URL |
| similarity_score | DECIMAL | 3,2 | YES | NULL | 相似度评分（0-1） |
| font_size_range | VARCHAR | 20 | YES | '12-72' | 字号范围 |
| beautify_mode | TINYINT | 4 | NO | 1 | 美化模式（1=自然还原，2=清晰优化，3=艺术加工） |
| is_default | TINYINT | 4 | NO | 0 | 是否默认字体 |
| generate_status | TINYINT | 4 | NO | 0 | 生成状态（0=生成中，1=已完成，2=失败） |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| is_deleted | TINYINT | 4 | NO | 0 | 是否删除 |

**索引**:
- PRIMARY KEY (`id`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_is_default` (`is_default`)
- KEY `idx_generate_status` (`generate_status`)

### 2.5 字体使用记录表 (font_usage_log)
记录字体使用情况

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | 20 | NO | - | 用户ID |
| font_id | BIGINT | 20 | NO | - | 字体ID |
| usage_scene | VARCHAR | 50 | YES | NULL | 使用场景（聊天/文档/笔记） |
| character_count | INT | 11 | YES | NULL | 输入字符数 |
| device_info | VARCHAR | 255 | YES | NULL | 设备信息 |
| ip_address | VARCHAR | 50 | YES | NULL | IP地址 |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |

**索引**:
- PRIMARY KEY (`id`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_font_id` (`font_id`)
- KEY `idx_create_time` (`create_time`)

### 2.6 字体分享表 (font_share)
记录字体分享信息

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | 20 | NO | - | 用户ID |
| font_id | BIGINT | 20 | NO | - | 字体ID |
| share_code | VARCHAR | 50 | NO | - | 分享码 |
| share_type | TINYINT | 4 | NO | 1 | 分享类型（1=公开，2=私密） |
| view_count | INT | 11 | NO | 0 | 浏览次数 |
| download_count | INT | 11 | NO | 0 | 下载次数 |
| expire_time | DATETIME | - | YES | NULL | 过期时间 |
| status | TINYINT | 4 | NO | 1 | 状态（0=禁用，1=启用） |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| is_deleted | TINYINT | 4 | NO | 0 | 是否删除 |

**索引**:
- PRIMARY KEY (`id`)
- UNIQUE KEY `uk_share_code` (`share_code`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_font_id` (`font_id`)

### 2.7 系统配置表 (system_config)
存储系统配置信息

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | 20 | NO | AUTO_INCREMENT | 主键 |
| config_key | VARCHAR | 100 | NO | - | 配置键 |
| config_value | TEXT | - | YES | NULL | 配置值 |
| config_type | VARCHAR | 50 | YES | NULL | 配置类型 |
| description | VARCHAR | 255 | YES | NULL | 配置描述 |
| create_time | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY (`id`)
- UNIQUE KEY `uk_config_key` (`config_key`)

## 3. 数据库初始化脚本

### 3.1 创建数据库
```sql
CREATE DATABASE IF NOT EXISTS handwriting_input_app
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE handwriting_input_app;
```

### 3.2 创建表
```sql
-- 用户表
CREATE TABLE user_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    wechat_openid VARCHAR(100) DEFAULT NULL COMMENT '微信OpenID',
    nickname VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    avatar_url VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    password VARCHAR(255) DEFAULT NULL COMMENT '密码（BCrypt加密）',
    salt VARCHAR(50) DEFAULT NULL COMMENT '密码盐值',
    age INT(11) DEFAULT NULL COMMENT '年龄',
    gender TINYINT(4) DEFAULT 0 COMMENT '性别（0=未知，1=男，2=女）',
    occupation VARCHAR(50) DEFAULT NULL COMMENT '职业',
    status TINYINT(4) NOT NULL DEFAULT 1 COMMENT '状态（0=禁用，1=正常）',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(50) DEFAULT NULL COMMENT '最后登录IP',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_phone (phone),
    UNIQUE KEY uk_wechat_openid (wechat_openid),
    KEY idx_status (status),
    KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 笔迹数据表
CREATE TABLE handwriting_data (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    collection_type TINYINT(4) NOT NULL DEFAULT 1 COMMENT '采集类型（1=直接手写，2=扫描文档）',
    character_code VARCHAR(10) NOT NULL COMMENT '汉字编码',
    character_text VARCHAR(10) NOT NULL COMMENT '汉字内容',
    stroke_sequence JSON DEFAULT NULL COMMENT '笔画顺序',
    start_pressure DECIMAL(5,2) DEFAULT NULL COMMENT '起笔力度（0-255）',
    end_pressure DECIMAL(5,2) DEFAULT NULL COMMENT '收笔力度（0-255）',
    stroke_arc DECIMAL(5,2) DEFAULT NULL COMMENT '连笔弧度（度）',
    character_spacing DECIMAL(5,2) DEFAULT NULL COMMENT '字间距',
    writing_speed DECIMAL(5,2) DEFAULT NULL COMMENT '书写速度',
    original_data_url VARCHAR(255) DEFAULT NULL COMMENT '原始数据URL',
    image_url VARCHAR(255) DEFAULT NULL COMMENT '笔迹图片URL',
    quality_score DECIMAL(3,2) DEFAULT NULL COMMENT '质量评分（0-1）',
    collection_device VARCHAR(100) DEFAULT NULL COMMENT '采集设备',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_character_code (character_code),
    KEY idx_collection_type (collection_type),
    KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='笔迹数据表';

-- 笔迹特征表
CREATE TABLE handwriting_feature (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    feature_data JSON DEFAULT NULL COMMENT '特征数据（JSON格式）',
    model_version VARCHAR(50) DEFAULT NULL COMMENT '模型版本',
    extraction_time DATETIME DEFAULT NULL COMMENT '特征提取时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_id (user_id),
    KEY idx_model_version (model_version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='笔迹特征表';

-- 字体表
CREATE TABLE user_font (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    font_name VARCHAR(50) NOT NULL COMMENT '字体名称',
    font_type VARCHAR(20) NOT NULL DEFAULT 'ttf' COMMENT '字体类型（ttf/otf）',
    font_url VARCHAR(255) NOT NULL COMMENT '字体文件URL',
    preview_image_url VARCHAR(255) DEFAULT NULL COMMENT '预览图片URL',
    similarity_score DECIMAL(3,2) DEFAULT NULL COMMENT '相似度评分（0-1）',
    font_size_range VARCHAR(20) DEFAULT '12-72' COMMENT '字号范围',
    beautify_mode TINYINT(4) NOT NULL DEFAULT 1 COMMENT '美化模式（1=自然还原，2=清晰优化，3=艺术加工）',
    is_default TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否默认字体',
    generate_status TINYINT(4) NOT NULL DEFAULT 0 COMMENT '生成状态（0=生成中，1=已完成，2=失败）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_is_default (is_default),
    KEY idx_generate_status (generate_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字体表';

-- 字体使用记录表
CREATE TABLE font_usage_log (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    font_id BIGINT(20) NOT NULL COMMENT '字体ID',
    usage_scene VARCHAR(50) DEFAULT NULL COMMENT '使用场景（聊天/文档/笔记）',
    character_count INT(11) DEFAULT NULL COMMENT '输入字符数',
    device_info VARCHAR(255) DEFAULT NULL COMMENT '设备信息',
    ip_address VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_font_id (font_id),
    KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字体使用记录表';

-- 字体分享表
CREATE TABLE font_share (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    font_id BIGINT(20) NOT NULL COMMENT '字体ID',
    share_code VARCHAR(50) NOT NULL COMMENT '分享码',
    share_type TINYINT(4) NOT NULL DEFAULT 1 COMMENT '分享类型（1=公开，2=私密）',
    view_count INT(11) NOT NULL DEFAULT 0 COMMENT '浏览次数',
    download_count INT(11) NOT NULL DEFAULT 0 COMMENT '下载次数',
    expire_time DATETIME DEFAULT NULL COMMENT '过期时间',
    status TINYINT(4) NOT NULL DEFAULT 1 COMMENT '状态（0=禁用，1=启用）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_share_code (share_code),
    KEY idx_user_id (user_id),
    KEY idx_font_id (font_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字体分享表';

-- 系统配置表
CREATE TABLE system_config (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT DEFAULT NULL COMMENT '配置值',
    config_type VARCHAR(50) DEFAULT NULL COMMENT '配置类型',
    description VARCHAR(255) DEFAULT NULL COMMENT '配置描述',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';
```

## 4. 数据库备份策略

### 4.1 备份类型
- **全量备份**: 每天凌晨2点
- **增量备份**: 每小时
- **日志备份**: 实时

### 4.2 备份保留
- 全量备份保留30天
- 增量备份保留7天
- 日志备份保留3天

### 4.3 备份脚本
```bash
# 全量备份
mysqldump -u root -p handwriting_input_app > /backup/full_backup_$(date +%Y%m%d).sql

# 增量备份
mysqldump -u root -p --single-transaction --flush-logs --master-data=2 handwriting_input_app > /backup/incremental_backup_$(date +%Y%m%d_%H).sql
```

## 5. 数据库优化建议

### 5.1 索引优化
- 为高频查询字段添加索引
- 定期分析索引使用情况
- 删除冗余索引

### 5.2 查询优化
- 避免SELECT *
- 使用分页查询
- 优化JOIN操作
- 使用EXPLAIN分析慢查询

### 5.3 分库分表预留
- 当单表数据量超过1000万时考虑分表
- 按用户ID分表（user_id % 10）
- 按时间分表（按月/年）

---

**文档版本**: v1.0
**创建日期**: 2026-01-29
**最后更新**: 2026-01-29
**维护人员**: 开发团队