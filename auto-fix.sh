#!/bin/bash
# 🔧 PonyTown 自动修复脚本
# 从6个文件重建完整工作环境

set -e

echo "🎮 PonyTown 自动修复脚本启动..."

# 检查是否在正确目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在ponyTown-master目录下运行此脚本"
    exit 1
fi

echo "📋 第1步: 应用Canvas修复..."
# 复制canvas-mock.js (假设从reboot仓库获取)
if [ -f "../pony-town-reboot/canvas-mock.js" ]; then
    cp ../pony-town-reboot/canvas-mock.js .
    echo "✅ canvas-mock.js 已复制"
fi

# 修复canvasUtilsNode.js
sed -i.bak 's|require("canvas")|require("../../../canvas-mock")|g' src/scripts/server/canvasUtilsNode.js
echo "✅ canvasUtilsNode.js 已修复"

echo "📋 第2步: 修复主应用组件模板..."
# 修复 app.js - 替换 templateUrl 为内联模板
sed -i.bak 's|templateUrl: '\''app.pug'\''|template: `<div class="app"><div class="main-box" [class.full]="fullscreen"><div class="bg" [style.background-image]="background"></div><div class="main-content" [class.in-game]="inGame"><router-outlet></router-outlet></div></div></div>`|g' src/scripts/components/app/app.js
echo "✅ app.js 模板已修复"

echo "📋 第3步: 修复版本验证..."
# 修复 model.js
sed -i.bak 's|this.post('"'"'/api1/account'"'"', {}, false)|this.post("/api1/account", { version: data_1.version }, false)|g' src/scripts/components/services/model.js
echo "✅ model.js 版本验证已修复"

echo "📋 第4步: 创建webpack简化配置..."
cat > webpack.simple.js << 'EOF'
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: './src/scripts/client/main.js',
  output: {
    path: path.resolve(__dirname, 'build-copy/assets'),
    filename: 'main.js'
  },
  plugins: [
    new webpack.IgnorePlugin({
      checkResource(resource, context) {
        if (/\.(pug|scss)$/.test(resource)) return true;
        if (context && context.includes('/components/') && 
            (resource.includes('.pug') || resource.includes('.scss'))) return true;
        return false;
      }
    })
  ],
  mode: 'development'
};
EOF
echo "✅ webpack.simple.js 已创建"

echo "📋 第5步: 创建模拟登录页面..."
cat > mock-login.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Mock Login Test</title>
</head>
<body>
    <h1>Mock Login Test</h1>
    <form action="http://localhost:8090/auth/local" method="post">
        <label for="username">Account ID:</label>
        <input type="text" id="username" name="username" value="68acdc3543a9ff7ce48a3daa" />
        <br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="test" />
        <br><br>
        <input type="submit" value="Mock Login" />
    </form>
</body>
</html>
EOF
echo "✅ mock-login.html 已创建"

echo "📋 第6步: 添加npm脚本..."
# 添加webpack:simple脚本到package.json
if ! grep -q "webpack:simple" package.json; then
    sed -i.bak 's|"scripts": {|"scripts": {\n    "webpack:simple": "webpack --config webpack.simple.js",|g' package.json
    echo "✅ webpack:simple 脚本已添加"
fi

echo "📋 第7步: 创建资源符号链接..."
cd assets 2>/dev/null || echo "⚠️  assets目录不存在，跳过符号链接创建"
if [ -d "." ]; then
    # 查找并创建符号链接
    if ls pony-*.png >/dev/null 2>&1; then
        ln -sf pony-*.png pony.png 2>/dev/null || true
        echo "✅ pony.png 符号链接已创建"
    fi
    if ls logo-large-*.png >/dev/null 2>&1; then
        ln -sf logo-large-*.png logo-large.png 2>/dev/null || true
        echo "✅ logo-large.png 符号链接已创建"
    fi
    cd ..
fi

echo "🎯 基础修复完成！"
echo ""
echo "⚠️  注意: 还需要手动修复以下组件的模板："
echo "   - src/scripts/components/shared/character-select/character-select.js"
echo "   - src/scripts/components/shared/character-list/character-list.js"  
echo "   - src/scripts/components/shared/play-box/play-box.js"
echo "   - src/scripts/server/routes/auth.js (添加mock login)"
echo ""
echo "📖 详细步骤请参考 COMPLETE_REBUILD_GUIDE.md"
echo ""
echo "🚀 基础构建命令:"
echo "   npm run webpack:simple"
echo "   DEVELOPMENT=true node pony-town.js --login --local --game"
echo ""
echo "🌐 访问: http://localhost:8090"
EOF

chmod +x auto-fix.sh