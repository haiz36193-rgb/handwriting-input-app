-- 个性化手写输入法APP - PostgreSQL数据库初始化脚本
-- Render部署版本

-- 创建用户
CREATE USER handwriting WITH PASSWORD 'handwriting123';

-- 创建数据库
CREATE DATABASE handwriting_input_app OWNER handwriting;

-- 连接到数据库
\c handwriting_input_app;

-- 授权
GRANT ALL PRIVILEGES ON DATABASE handwriting_input_app TO handwriting;

-- 用户表
CREATE TABLE IF NOT EXISTS user_info (
    id BIGSERIAL PRIMARY KEY,
    phone VARCHAR(20) UNIQUE,
    wechat_openid VARCHAR(100) UNIQUE,
    nickname VARCHAR(50),
    avatar_url VARCHAR(255),
    password VARCHAR(255),
    salt VARCHAR(50),
    age INTEGER,
    gender SMALLINT DEFAULT 0,
    occupation VARCHAR(50),
    status SMALLINT NOT NULL DEFAULT 1,
    last_login_time TIMESTAMP,
    last_login_ip VARCHAR(50),
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted SMALLINT NOT NULL DEFAULT 0
);

-- 笔迹数据表
CREATE TABLE IF NOT EXISTS handwriting_data (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    collection_type SMALLINT NOT NULL DEFAULT 1,
    character_code VARCHAR(10) NOT NULL,
    character_text VARCHAR(10) NOT NULL,
    stroke_sequence JSONB,
    start_pressure DECIMAL(5,2),
    end_pressure DECIMAL(5,2),
    stroke_arc DECIMAL(5,2),
    character_spacing DECIMAL(5,2),
    writing_speed DECIMAL(5,2),
    original_data_url VARCHAR(255),
    image_url VARCHAR(255),
    quality_score DECIMAL(3,2),
    collection_device VARCHAR(100),
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted SMALLINT NOT NULL DEFAULT 0
);

-- 笔迹特征表
CREATE TABLE IF NOT EXISTS handwriting_feature (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    feature_data JSONB,
    model_version VARCHAR(50),
    extraction_time TIMESTAMP,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted SMALLINT NOT NULL DEFAULT 0
);

-- 字体表
CREATE TABLE IF NOT EXISTS user_font (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    font_name VARCHAR(50) NOT NULL,
    font_type VARCHAR(20) NOT NULL DEFAULT 'ttf',
    font_url VARCHAR(255) NOT NULL,
    preview_image_url VARCHAR(255),
    similarity_score DECIMAL(3,2),
    font_size_range VARCHAR(20) DEFAULT '12-72',
    beautify_mode SMALLINT NOT NULL DEFAULT 1,
    is_default SMALLINT NOT NULL DEFAULT 0,
    generate_status SMALLINT NOT NULL DEFAULT 0,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted SMALLINT NOT NULL DEFAULT 0
);

-- 字体使用记录表
CREATE TABLE IF NOT EXISTS font_usage_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    font_id BIGINT NOT NULL,
    usage_scene VARCHAR(50),
    character_count INTEGER,
    device_info VARCHAR(255),
    ip_address VARCHAR(50),
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 字体分享表
CREATE TABLE IF NOT EXISTS font_share (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    font_id BIGINT NOT NULL,
    share_code VARCHAR(50) UNIQUE NOT NULL,
    share_type SMALLINT NOT NULL DEFAULT 1,
    view_count INTEGER NOT NULL DEFAULT 0,
    download_count INTEGER NOT NULL DEFAULT 0,
    expire_time TIMESTAMP,
    status SMALLINT NOT NULL DEFAULT 1,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted SMALLINT NOT NULL DEFAULT 0
);

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_config (
    id BIGSERIAL PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    config_type VARCHAR(50),
    description VARCHAR(255),
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 插入默认系统配置
INSERT INTO system_config (config_key, config_value, config_type, description) VALUES
('maxHandwritingCount', '2000', 'int', '最大笔迹采集字数'),
('fontGenerateTimeout', '300', 'int', '字体生成超时时间（秒）'),
('supportedFontTypes', 'ttf,otf', 'string', '支持的字体类型');

-- 创建测试用户（密码：123456）
INSERT INTO user_info (phone, password, nickname, status) VALUES
('13800138000', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '测试用户', 1);
