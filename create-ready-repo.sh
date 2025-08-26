#!/bin/bash
# 🏗️ 创建 ponytown-ready 仓库脚本
# 基于完全修复的项目创建即开即用的仓库

set -e

echo "🏗️ 创建 ponytown-ready 仓库"
echo "================================"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 工作目录
READY_DIR="ponytown-ready"
SOURCE_DIR="../ponyTown-master"  # 指向您的修复后项目

log "正在创建即开即用的PonyTown仓库..."

# 检查源目录
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 源目录不存在: $SOURCE_DIR"
    echo "请确保指向您已修复的PonyTown项目目录"
    exit 1
fi

# 创建新仓库目录
if [ -d "$READY_DIR" ]; then
    log "清理现有目录..."
    rm -rf "$READY_DIR"
fi

mkdir "$READY_DIR"
cd "$READY_DIR"

log "复制完整的修复后项目..."
cp -r "$SOURCE_DIR"/* .
cp -r "$SOURCE_DIR"/.[^.]* . 2>/dev/null || true  # 复制隐藏文件

# 清理不需要的文件
log "清理开发文件..."
rm -rf .git/
rm -rf node_modules/
rm -rf *.log
rm -rf logs/
rm -rf settings/

success "项目文件复制完成"

# 创建优化的README
log "创建优化的README..."
cat > README.md << 'README_EOF'
# 🎮 PonyTown Ready - 即开即用版本

**6年前的多人在线游戏，现在即可游玩！**

![Game](https://img.shields.io/badge/Game-READY_TO_PLAY-brightgreen)
![Status](https://img.shields.io/badge/Status-FULLY_WORKING-success)
![Node](https://img.shields.io/badge/Node.js-v9.11.2-green)

## 🚀 3分钟启动游戏

```bash
# 1. 克隆项目
git clone https://github.com/Ritori2022/ponytown-ready.git
cd ponytown-ready

# 2. 设置环境 (一次性设置)
nvm use 9.11.2  # 或 nvm install 9.11.2

# 3. 安装依赖 (一次性安装)
npm install --legacy-peer-deps --ignore-scripts

# 4. 启动游戏！
npm start
```

**🌐 游戏地址**: http://localhost:8090

## 🎮 游戏特色

这是一个可爱的**2D像素风格多人在线角色扮演游戏**：

- 🐴 **创建小马角色** - 自定义你的可爱小马
- 🌍 **探索像素世界** - 美丽的2D像素艺术风格
- 👥 **多人互动** - 与其他玩家实时聊天和互动
- 🎭 **角色扮演** - 完整的RPG游戏体验
- 💬 **社交系统** - 在线聊天和交友

## 📸 游戏截图

### 登录界面
![登录界面](../pony-town-reboot/登录界面截图.PNG)

### 游戏世界  
![游戏世界](../pony-town-reboot/主地图截图.PNG)

## 🔐 测试登录

游戏包含便捷的测试登录功能：

- 访问 http://localhost:8090/mock-login.html
- 使用预设的TestPony角色登录
- 立即开始游戏！

## ⚙️ 启动选项

```bash
# 标准启动
npm start

# 或者使用完整命令
DEVELOPMENT=true node pony-town.js --login --local --game

# 后台运行
nohup npm start &
```

## 🎯 系统要求

- **Node.js** 9.11.2 (推荐) 或更高版本
- **现代浏览器** (Chrome, Firefox, Safari, Edge)
- **RAM**: 至少512MB可用内存
- **网络**: 局域网或互联网连接 (多人游戏)

## 📚 这个版本包含什么？

✅ **所有修复已应用**:
- Canvas兼容性修复
- 100+ Angular组件模板修复
- TypeScript编译兼容性
- MongoDB数据结构优化
- 静态资源路径修复
- 认证系统集成

✅ **开箱即用**:
- 预配置的构建系统
- 测试登录页面
- 简化的启动脚本
- 优化的依赖配置

## 🏆 修复成就

这个项目代表了软件考古学的一个奇迹：

- **6年技术鸿沟** - 从2018年的技术栈到2025年的环境
- **100+文件修复** - 系统性解决兼容性问题
- **完整功能恢复** - 多人在线游戏完全可玩
- **用户友好** - 从复杂修复到3个命令启动

## 🔗 相关项目

- [pony-town-reboot](https://github.com/Ritori2022/pony-town-reboot) - 修复过程和自动化工具
- [ponyTown](https://github.com/Ritori2022/ponyTown) - 原始项目fork

## 🎉 开始游戏！

现在就运行 `npm start` 开始体验这个可爱的2D像素多人在线世界吧！

创建你的小马角色，探索美丽的像素世界，与其他玩家一起享受游戏的乐趣！

---

*这个项目展示了如何让6年前的代码重新焕发生机。技术在变化，但好的游戏是永恒的！* 🌟
README_EOF

# 创建快速启动指南
log "创建快速启动指南..."
cat > QUICK_START.md << 'QUICKSTART_EOF'
# ⚡ 快速启动指南

## 🎯 目标
在3分钟内启动PonyTown多人在线游戏

## ✅ 前置检查
```bash
# 检查Node.js
node --version  # 需要 >= 9.11.2

# 如果版本不对，设置正确版本
nvm install 9.11.2
nvm use 9.11.2
```

## 🚀 启动步骤

### 第1步: 获取项目 (30秒)
```bash
git clone https://github.com/Ritori2022/ponytown-ready.git
cd ponytown-ready
```

### 第2步: 安装依赖 (2分钟)
```bash
npm install --legacy-peer-deps --ignore-scripts
```

### 第3步: 启动游戏 (立即)
```bash
npm start
```

## 🎮 访问游戏
- 浏览器打开: http://localhost:8090
- 快速登录: http://localhost:8090/mock-login.html

## 🎉 完成！
现在就可以创建小马角色，探索2D像素世界了！

---
**总耗时: 约3分钟 | 难度: ⭐☆☆☆☆**
QUICKSTART_EOF

# 优化package.json
log "优化package.json启动脚本..."
if [ -f "package.json" ]; then
    # 添加便捷的启动脚本
    cat package.json | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
data['scripts']['start'] = 'DEVELOPMENT=true node pony-town.js --login --local --game'
data['scripts']['dev'] = 'DEVELOPMENT=true node pony-town.js --login --local --game'  
data['scripts']['play'] = 'DEVELOPMENT=true node pony-town.js --login --local --game'
data['scripts']['game'] = 'DEVELOPMENT=true node pony-town.js --login --local --game'
json.dump(data, sys.stdout, indent=2)
" > package.json.tmp && mv package.json.tmp package.json
    success "package.json启动脚本已优化"
fi

# 创建环境检查脚本
log "创建环境检查脚本..."
cat > check-env.sh << 'CHECKENV_EOF'
#!/bin/bash
# 环境检查脚本

echo "🔍 检查运行环境..."

# 检查Node.js
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js未安装"
    echo "请安装Node.js: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//')
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1)

if [ "$NODE_MAJOR" -lt 9 ]; then
    echo "⚠️  建议使用Node.js 9.11.2"
    echo "当前版本: v$NODE_VERSION"
    echo "运行: nvm install 9.11.2 && nvm use 9.11.2"
else
    echo "✅ Node.js版本合适: v$NODE_VERSION"
fi

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "📦 需要安装依赖"
    echo "运行: npm install --legacy-peer-deps --ignore-scripts"
else
    echo "✅ 依赖已安装"
fi

echo ""
echo "🎮 准备就绪！运行 'npm start' 开始游戏"
CHECKENV_EOF

chmod +x check-env.sh

# 创建Git仓库
log "初始化Git仓库..."
git init
git add .
git commit -m "🎮 PonyTown Ready - Complete playable game

🎯 READY TO PLAY:
- All 100+ fixes pre-applied
- Optimized package.json with npm start
- Quick start guide and environment checker
- Test login page included
- Beautiful README with screenshots

🚀 USER EXPERIENCE:
1. git clone
2. npm install  
3. npm start
4. Play game!

⭐ ACHIEVEMENT:
From broken 6-year-old project to 3-command gameplay!
This is the ultimate software archaeology user experience.

🎮 Access: http://localhost:8090"

success "ponytown-ready 仓库创建完成！"

echo ""
echo -e "${YELLOW}📍 下一步操作：${NC}"
echo "1. 创建GitHub仓库: ponytown-ready"  
echo "2. 添加远程仓库: git remote add origin https://github.com/Ritori2022/ponytown-ready.git"
echo "3. 推送到GitHub: git push -u origin main"
echo ""
echo -e "${GREEN}🎮 用户将可以直接使用：${NC}"
echo "git clone https://github.com/Ritori2022/ponytown-ready.git"
echo "cd ponytown-ready && npm install --legacy-peer-deps --ignore-scripts"
echo "npm start"
echo ""
echo -e "${BLUE}🌟 这将是软件修复领域的终极用户体验！${NC}"