#!/bin/bash

# Oracle Cloud 部署脚本
# 用于自动化部署手写输入法APP到Oracle Cloud

set -e  # 遇到错误立即退出

echo "============================================="
echo "Oracle Cloud 部署脚本"
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

# 检查依赖
check_dependencies() {
    print_info "检查系统依赖..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose 未安装"
        exit 1
    fi
    
    print_success "依赖检查通过"
}

# 检查环境变量
check_env_file() {
    print_info "检查环境变量文件..."
    
    if [ ! -f .env ]; then
        print_error ".env 文件不存在"
        print_info "正在创建 .env 文件..."
        cp .env.example .env
        print_info "请编辑 .env 文件，设置正确的密码和配置"
        print_info "编辑完成后重新运行此脚本"
        exit 1
    fi
    
    print_success "环境变量文件检查通过"
}

# 构建后端
build_backend() {
    print_info "构建后端服务..."
    
    cd backend
    if mvn clean package -DskipTests; then
        print_success "后端构建成功"
    else
        print_error "后端构建失败"
        exit 1
    fi
    
    cd ..
}

# 启动服务
start_services() {
    print_info "启动Docker服务..."
    
    if docker-compose -f docker-compose.oracle.yml up -d; then
        print_success "服务启动成功"
    else
        print_error "服务启动失败"
        exit 1
    fi
}

# 等待服务就绪
wait_for_services() {
    print_info "等待服务启动..."
    
    # 等待MySQL
    print_info "等待MySQL启动..."
    while ! docker exec handwriting-mysql mysqladmin ping -h localhost --silent; do
        sleep 2
    done
    print_success "MySQL 已就绪"
    
    # 等待Redis
    print_info "等待Redis启动..."
    while ! docker exec handwriting-redis redis-cli ping | grep -q PONG; do
        sleep 2
    done
    print_success "Redis 已就绪"
    
    # 等待后端服务
    print_info "等待后端服务启动..."
    sleep 30
    
    # 检查健康状态
    if curl -f http://localhost:8080/api/v1/health > /dev/null 2>&1; then
        print_success "后端服务已就绪"
    else
        print_error "后端服务启动失败"
        docker-compose -f docker-compose.oracle.yml logs backend
        exit 1
    fi
}

# 初始化数据库
init_database() {
    print_info "初始化数据库..."
    
    # 检查数据库是否已初始化
    DB_EXISTS=$(docker exec handwriting-mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "USE handwriting_input_app; SHOW TABLES;" 2>/dev/null | grep -c "user_info" || true)
    
    if [ "$DB_EXISTS" -eq 0 ]; then
        print_info "执行数据库初始化脚本..."
        if docker exec -i handwriting-mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD} < scripts/init.sql; then
            print_success "数据库初始化成功"
        else
            print_error "数据库初始化失败"
            exit 1
        fi
    else
        print_info "数据库已初始化，跳过"
    fi
}

# 显示服务状态
show_status() {
    print_info "服务状态:"
    echo ""
    docker-compose -f docker-compose.oracle.yml ps
    echo ""
    
    print_info "访问地址:"
    echo "  后端API: http://$(hostname -I | awk '{print $1}'):8080"
    echo "  健康检查: http://$(hostname -I | awk '{print $1}'):8080/api/v1/health"
    echo ""
    
    print_info "管理命令:"
    echo "  查看日志: docker-compose -f docker-compose.oracle.yml logs -f"
    echo "  停止服务: docker-compose -f docker-compose.oracle.yml down"
    echo "  重启服务: docker-compose -f docker-compose.oracle.yml restart"
}

# 主流程
main() {
    echo ""
    check_dependencies
    check_env_file
    build_backend
    start_services
    wait_for_services
    init_database
    show_status
    
    echo ""
    print_success "部署完成！"
    echo ""
}

# 运行主流程
main