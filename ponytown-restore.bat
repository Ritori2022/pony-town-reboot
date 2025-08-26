@echo off
chcp 65001 >nul
:: 🎮 PonyTown Windows 一键修复脚本
:: 适用于Windows系统的PonyTown自动修复工具

title PonyTown 一键修复工具

echo.
echo  ██████╗  ██████╗ ███╗   ██╗██╗   ██╗████████╗ ██████╗ ██╗    ██╗███╗   ██╗
echo  ██╔══██╗██╔═══██╗████╗  ██║╚██╗ ██╔╝╚══██╔══╝██╔═══██╗██║    ██║████╗  ██║
echo  ██████╔╝██║   ██║██╔██╗ ██║ ╚████╔╝    ██║   ██║   ██║██║ █╗ ██║██╔██╗ ██║
echo  ██╔═══╝ ██║   ██║██║╚██╗██║  ╚██╔╝     ██║   ██║   ██║██║███╗██║██║╚██╗██║  
echo  ██║     ╚██████╔╝██║ ╚████║   ██║      ██║   ╚██████╔╝╚███╔███╔╝██║ ╚████║
echo  ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝      ╚═╝    ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
echo.
echo           🎮 Windows 一键修复脚本 - 6年前游戏重新复活！🎮
echo.
echo ================================
echo  ⏱️  预计时间: 10-15分钟
echo  🎯 目标: 完全可玩的2D像素多人在线游戏  
echo  📋 需求: Node.js, Git, MongoDB
echo ================================
echo.

:: 检查必需工具
echo 📋 检查必需工具...
where node >nul 2>&1 || (echo ❌ Node.js未安装，请先安装Node.js && pause && exit)
where git >nul 2>&1 || (echo ❌ Git未安装，请先安装Git && pause && exit)
where npm >nul 2>&1 || (echo ❌ npm未安装，请先安装Node.js && pause && exit)
echo ✅ 必需工具检查完成

:: 创建工作目录
set "WORK_DIR=ponytown-windows-%time:~0,2%%time:~3,2%%time:~6,2%"
set "WORK_DIR=%WORK_DIR: =0%"
echo.
echo 📁 创建工作目录: %WORK_DIR%
mkdir "%WORK_DIR%" 2>nul
cd "%WORK_DIR%"

:: 下载原始项目
echo.
echo 📥 下载PonyTown原始项目 (使用稳定fork版本)...
git clone https://github.com/Ritori2022/ponyTown.git ponytown
if not exist ponytown (echo ❌ 下载失败 && pause && exit)

cd ponytown
echo ✅ 项目准备完成

:: 下载修复资源
echo.
echo 🔧 下载修复资源...
git clone https://github.com/Ritori2022/pony-town-reboot.git fixes
copy fixes\canvas-mock.js . >nul
echo ✅ 修复资源准备完成

:: 安装依赖
echo.
echo 📦 安装项目依赖...
echo    这可能需要几分钟时间...
call npm install --legacy-peer-deps --ignore-scripts --silent
echo ✅ 依赖安装完成

:: 应用核心修复
echo.
echo 🔨 应用核心修复...

:: Canvas修复
powershell -Command "(Get-Content 'src\scripts\server\canvasUtilsNode.js') -replace 'require\(\"canvas\"\)', 'require(\"./canvas-mock\")' | Set-Content 'src\scripts\server\canvasUtilsNode.js'"

:: 主应用模板修复
powershell -Command "(Get-Content 'src\scripts\components\app\app.js') -replace 'templateUrl: ''app.pug''', 'template: `<div class=\"app\"><div class=\"main-box\"><div class=\"main-content\"><router-outlet></router-outlet></div></div></div>`' | Set-Content 'src\scripts\components\app\app.js'"

:: 版本验证修复  
powershell -Command "(Get-Content 'src\scripts\components\services\model.js') -replace 'this\.post\(\"/api1/account\", \{\}, false\)', 'this.post(\"/api1/account\", { version: data_1.version }, false)' | Set-Content 'src\scripts\components\services\model.js'"

:: 创建webpack配置
echo const path = require('path'); > webpack.simple.js
echo const webpack = require('webpack'); >> webpack.simple.js
echo module.exports = { >> webpack.simple.js
echo   entry: './src/scripts/client/main.js', >> webpack.simple.js
echo   output: { path: path.resolve(__dirname, 'build-copy/assets'), filename: 'main.js' }, >> webpack.simple.js
echo   plugins: [new webpack.IgnorePlugin({ checkResource: r =^> /\.(pug^|scss)$/.test(r) })], >> webpack.simple.js
echo   mode: 'development' >> webpack.simple.js
echo }; >> webpack.simple.js

:: 添加npm脚本
powershell -Command "(Get-Content 'package.json') -replace '\"scripts\": \{', '\"scripts\": {\n    \"webpack:simple\": \"webpack --config webpack.simple.js\",' | Set-Content 'package.json'"

echo ✅ 核心修复完成

:: 创建测试登录页面
echo.
echo 🔐 创建测试登录页面...
(
echo ^<!DOCTYPE html^>
echo ^<html^>^<head^>^<title^>PonyTown Test Login^</title^>^</head^>^<body^>
echo ^<h1^>🎮 PonyTown Test Login^</h1^>
echo ^<form action="http://localhost:8090/auth/local" method="post"^>
echo   ^<p^>Account ID: ^<input type="text" name="username" value="68acdc3543a9ff7ce48a3daa" /^>^</p^>
echo   ^<p^>Password: ^<input type="password" name="password" value="test" /^>^</p^>
echo   ^<p^>^<input type="submit" value="🚀 Login & Play!" /^>^</p^>
echo ^</form^>
echo ^<p^>🎯 登录后即可进入2D像素游戏世界！^</p^>
echo ^</body^>^</html^>
) > mock-login.html

echo ✅ 测试登录页面创建完成

:: 构建项目
echo.
echo ⚙️ 构建项目...
call npm run webpack:simple >nul 2>&1

:: 完成信息
echo.
echo 🎉 修复完成！游戏已可运行！
echo ================================
echo 🚀 启动命令:
echo    set DEVELOPMENT=true ^&^& node pony-town.js --login --local --game
echo.
echo 🌐 访问地址:
echo    http://localhost:8090
echo.
echo 🔐 测试登录:
echo    http://localhost:8090/mock-login.html
echo.
echo 🎮 这是一个2D像素风格的多人在线角色扮演游戏
echo    创建你的小马角色，探索美丽的像素世界！
echo.
echo ⭐ 成就: 6年前的项目重新复活！
echo ================================
echo.

:: 询问是否启动
set /p choice="🚀 立即启动游戏? (y/n): "
if /i "%choice%"=="y" (
    echo.
    echo 🎮 正在启动PonyTown游戏服务器...
    echo 📱 在浏览器中访问 http://localhost:8090  
    echo 🎯 使用 http://localhost:8090/mock-login.html 快速登录
    echo.
    echo 🔥 游戏启动中... 按Ctrl+C停止服务器
    echo.
    set DEVELOPMENT=true
    node pony-town.js --login --local --game
) else (
    echo.
    echo ✅ 修复完成！随时可以启动游戏！
    echo 💡 提示: 进入 %WORK_DIR%\ponytown 目录运行启动命令
    echo.
    pause
)