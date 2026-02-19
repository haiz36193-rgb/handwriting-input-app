-- Railway数据库初始化脚本（简化版）
-- 在Railway MySQL Console中执行

USE handwriting_input_app;

-- 用户表
CREATE TABLE IF NOT EXISTS user_info (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    nickname VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    avatar_url VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    password VARCHAR(255) DEFAULT NULL COMMENT '密码（BCrypt加密）',
    status TINYINT(4) NOT NULL DEFAULT 1 COMMENT '状态（0=禁用，1=正常）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 笔迹数据表
CREATE TABLE IF NOT EXISTS handwriting_data (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    character_code VARCHAR(10) NOT NULL COMMENT '汉字编码',
    character_text VARCHAR(10) NOT NULL COMMENT '汉字内容',
    image_url VARCHAR(255) DEFAULT NULL COMMENT '笔迹图片URL',
    quality_score DECIMAL(3,2) DEFAULT NULL COMMENT '质量评分（0-1）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='笔迹数据表';

-- 字体表
CREATE TABLE IF NOT EXISTS user_font (
    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
    user_id BIGINT(20) NOT NULL COMMENT '用户ID',
    font_name VARCHAR(50) NOT NULL COMMENT '字体名称',
    font_url VARCHAR(255) NOT NULL COMMENT '字体文件URL',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_deleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '是否删除',
    PRIMARY KEY (id),
    KEY idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字体表';