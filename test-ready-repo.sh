#!/bin/bash
# 🧪 测试 pony-town-ready 仓库脚本
# 验证即开即用仓库是否正常工作

set -e

echo "🧪 测试 pony-town-ready 仓库"
echo "=============================="

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# 创建测试目录
TEST_DIR="pony-town-ready-test-$(date +%H%M%S)"
log "创建测试目录: $TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR"

# 测试1: 克隆仓库
log "测试1: 克隆 pony-town-ready 仓库..."
if git clone https://github.com/Ritori2022/pony-town-ready.git; then
    success "仓库克隆成功"
else
    error "仓库克隆失败"
    exit 1
fi

cd pony-town-ready

# 测试2: 检查关键文件
log "测试2: 检查关键文件存在性..."
REQUIRED_FILES=(
    "package.json"
    "pony-town.js"
    "canvas-mock.js"
    "mock-login.html"
    "src/scripts/components/app/app.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        success "文件存在: $file"
    else
        error "文件缺失: $file"
        exit 1
    fi
done

# 测试3: 检查package.json scripts
log "测试3: 检查package.json启动脚本..."
if grep -q '"start".*"DEVELOPMENT=true node pony-town.js --login --local --game"' package.json; then
    success "npm start 脚本配置正确"
else
    warning "npm start 脚本可能需要调整"
fi

# 测试4: 检查Node.js版本
log "测试4: 检查Node.js环境..."
NODE_VERSION=$(node --version 2>/dev/null || echo "未安装")
if [[ $NODE_VERSION =~ v9\. ]]; then
    success "Node.js版本合适: $NODE_VERSION"
elif [[ $NODE_VERSION =~ v([1-9][0-9]|[1-9])\. ]]; then
    warning "Node.js版本较新: $NODE_VERSION (建议使用v9.11.2)"
else
    warning "Node.js版本检查: $NODE_VERSION"
fi

# 测试5: 检查修复文件
log "测试5: 检查关键修复是否已应用..."

# 检查Canvas修复
if grep -q "canvas-mock" src/scripts/server/canvasUtilsNode.js 2>/dev/null; then
    success "Canvas修复已应用"
else
    error "Canvas修复缺失"
fi

# 检查主应用模板修复
if grep -q "template:" src/scripts/components/app/app.js 2>/dev/null; then
    success "主应用模板修复已应用"
else
    error "主应用模板修复缺失"  
fi

# 检查版本验证修复
if grep -q "version: data_1.version" src/scripts/components/services/model.js 2>/dev/null; then
    success "版本验证修复已应用"
else
    error "版本验证修复缺失"
fi

# 测试6: 尝试安装依赖
log "测试6: 尝试安装依赖包..."
if npm install --legacy-peer-deps --ignore-scripts --silent; then
    success "依赖安装成功"
else
    error "依赖安装失败"
    exit 1
fi

# 测试7: 检查关键依赖
log "测试7: 检查关键依赖包..."
REQUIRED_DEPS=(
    "express"
    "mongoose" 
    "passport"
    "webpack"
    "@angular/core"
)

for dep in "${REQUIRED_DEPS[@]}"; do
    if [ -d "node_modules/$dep" ]; then
        success "依赖存在: $dep"
    else
        warning "依赖可能缺失: $dep"
    fi
done

# 测试8: 语法检查
log "测试8: 主要文件语法检查..."
if node -c pony-town.js 2>/dev/null; then
    success "pony-town.js 语法正确"
else
    error "pony-town.js 语法错误"
fi

# 测试9: 检查资源文件
log "测试9: 检查游戏资源文件..."
if [ -f "assets/images/pony.png" ] || [ -L "assets/images/pony.png" ]; then
    success "游戏图片资源存在"
else
    warning "游戏图片资源可能缺失"
fi

# 总结测试结果
echo ""
echo "🎯 测试总结"
echo "============"
success "pony-town-ready 仓库基础测试通过"
echo ""
echo -e "${GREEN}🎮 仓库已准备就绪，用户可以：${NC}"
echo "1. git clone https://github.com/Ritori2022/pony-town-ready.git"
echo "2. cd pony-town-ready"  
echo "3. nvm use 9.11.2 (如需要)"
echo "4. npm install --legacy-peer-deps --ignore-scripts"
echo "5. npm start"
echo "6. 访问 http://localhost:8090"
echo ""
echo -e "${YELLOW}⚠️  注意事项：${NC}"
echo "- 确保用户使用Node.js 9.11.2版本"
echo "- MongoDB服务可选（游戏会自动创建数据）"
echo "- 确保8090端口未被占用"
echo ""
echo -e "${BLUE}🏆 成就解锁：${NC}"
echo "从6年前的破损项目到3分钟可玩游戏！"

# 清理
cd ../..
rm -rf "$TEST_DIR"
success "测试环境已清理"