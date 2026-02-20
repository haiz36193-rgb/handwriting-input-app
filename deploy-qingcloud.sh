#!/bin/bash

# 青云云服务器自动部署脚本
# 用于自动化部署手写输入法APP

set -e  # 遇到错误立即退出

echo "============================================="
echo "青云云服务器自动部署脚本"
echo "============================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数定义
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then 
    print_error "请使用root用户运行此脚本"
    exit 1
fi

# 第一步：更新系统
print_info "步骤1：更新系统..."
apt-get update -y
print_success "系统更新完成"

# 第二步：安装Docker
print_info "步骤2：安装Docker..."
if ! command -v docker &> /dev/null; then
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    print_success "Docker安装成功"
else
    print_info "Docker已安装，跳过"
fi

# 第三步：安装Docker Compose
print_info "步骤3：安装Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose安装成功"
else
    print_info "Docker Compose已安装，跳过"
fi

# 第四步：安装Git
print_info "步骤4：安装Git..."
if ! command -v git &> /dev/null; then
    apt-get install -y git
    print_success "Git安装成功"
else
    print_info "Git已安装，跳过"
fi

# 第五步：安装Maven（用于构建后端）
print_info "步骤5：安装Maven..."
if ! command -v mvn &> /dev/null; then
    apt-get install -y maven
    print_success "Maven安装成功"
else
    print_info "Maven已安装，跳过"
fi

# 第六步：克隆项目
print_info "步骤6：克隆项目..."
if [ ! -d "handwriting-input-app" ]; then
    git clone https://github.com/haiz36193-rgb/handwriting-input-app.git
    cd handwriting-input-app
    print_success "项目克隆成功"
else
    cd handwriting-input-app
    print_info "项目已存在，拉取最新代码"
    git pull
fi

# 第七步：配置环境变量
print_info "步骤7：配置环境变量..."
if [ ! -f .env ]; then
    cp .env.example .env
    
    # 生成随机密码
    MYSQL_ROOT_PASSWORD=$(openssl rand -base64 16)
    MYSQL_PASSWORD=$(openssl rand -base64 16)
    REDIS_PASSWORD=$(openssl rand -base64 16)
    JWT_SECRET=$(openssl rand -base64 32)
    
    # 更新.env文件
    sed -i "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD/" .env
    sed -i "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$MYSQL_PASSWORD/" .env
    sed -i "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=$REDIS_PASSWORD/" .env
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env
    
    print_success "环境变量配置完成"
    print_info "生成的密码已保存到.env文件"
else
    print_info "环境变量文件已存在，跳过"
fi

# 第八步：构建后端
print_info "步骤8：构建后端服务..."
cd backend
mvn clean package -DskipTests
if [ $? -eq 0 ]; then
    print_success "后端构建成功"
else
    print_error "后端构建失败"
    exit 1
fi
cd ..

# 第九步：启动服务
print_info "步骤9：启动Docker服务..."
docker-compose -f docker-compose.aliyun.yml up -d
print_success "服务启动成功"

# 第十步：等待服务就绪
print_info "步骤10：等待服务启动..."
sleep 30

# 检查MySQL
print_info "等待MySQL启动..."
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker exec handwriting-mysql mysqladmin ping -h localhost --silent 2>/dev/null; then
        print_success "MySQL已就绪"
        break
    fi
    ATTEMPT=$((ATTEMPT+1))
    sleep 2
done

# 检查Redis
print_info "等待Redis启动..."
MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker exec handwriting-redis redis-cli ping 2>/dev/null | grep -q PONG; then
        print_success "Redis已就绪"
        break
    fi
    ATTEMPT=$((ATTEMPT+1))
    sleep 2
done

# 检查后端服务
print_info "等待后端服务启动..."
sleep 20

MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -f http://localhost:8080/api/v1/health > /dev/null 2>&1; then
        print_success "后端服务已就绪"
        break
    fi
    ATTEMPT=$((ATTEMPT+1))
    sleep 2
done

# 第十一步：显示服务状态
print_info "步骤11：服务状态："
echo ""
docker-compose -f docker-compose.aliyun.yml ps
echo ""

# 第十二步：显示访问信息
print_info "部署完成！"
echo ""
echo "============================================="
echo "访问信息"
echo "============================================="
echo "后端API: http://139.198.30.21:8080"
echo "健康检查: http://139.198.30.21:8080/api/v1/health"
echo ""
echo "============================================="
echo "管理命令"
echo "============================================="
echo "查看日志: docker-compose -f docker-compose.aliyun.yml logs -f"
echo "查看后端日志: docker-compose -f docker-compose.aliyun.yml logs -f backend"
echo "停止服务: docker-compose -f docker-compose.aliyun.yml down"
echo "重启服务: docker-compose -f docker-compose.aliyun.yml restart"
echo ""
echo "============================================="
echo "测试API"
echo "============================================="
echo "# 注册用户"
echo "curl -X POST http://139.198.30.21:8080/api/v1/user/register \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"phone\":\"13800138000\",\"password\":\"123456\",\"nickname\":\"测试用户\"}'"
echo ""
echo "# 登录用户"
echo "curl -X POST http://139.198.30.21:8080/api/v1/user/login \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"phone\":\"13800138000\",\"password\":\"123456\"}'"
echo "============================================="