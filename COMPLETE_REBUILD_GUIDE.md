# 🏗️ 完整重建指南 - 从6个文件到完整工作环境

## 📋 当前推送的文件
1. `README.md` - 项目说明
2. `STARTUP_GUIDE.md` - 启动指南  
3. `CORE_FIXES.md` - 核心修复列表
4. `SUCCESS.md` - 成功记录
5. `GAME_STATUS.txt` - 状态文件
6. `canvas-mock.js` - Canvas兼容层

## 🔧 完整重建步骤

### 第1步：获取原始项目
```bash
# 克隆稳定的fork版本 (确保内容一致性)
git clone https://github.com/Ritori2022/ponyTown.git
cd ponyTown
```

### 第2步：环境设置
```bash
# 安装Node.js 9.11.2 (关键版本)
nvm install 9.11.2
nvm use 9.11.2

# 安装依赖 (避开编译问题)
npm install --legacy-peer-deps --ignore-scripts
```

### 第3步：应用Canvas修复
```bash
# 复制canvas-mock.js到项目根目录
# 修改 src/scripts/server/canvasUtilsNode.js 第5行：
# const canvas_1 = require("../../../canvas-mock");
```

### 第4步：关键文件修复列表

#### A. 主应用组件模板
**文件**: `src/scripts/components/app/app.js`
```javascript
// 第193行左右，替换：
templateUrl: 'app.pug'
// 为：
template: `<div class="app">
  <div class="main-box" [class.full]="fullscreen">
    <div class="bg" [style.background-image]="background"></div>
    <div class="main-content" [class.in-game]="inGame">
      <router-outlet></router-outlet>
    </div>
  </div>
</div>`
```

#### B. 角色选择组件
**文件**: `src/scripts/components/shared/character-select/character-select.js`
```javascript
// 替换templateUrl为完整内联模板 (约192行)
template: '<div class="sr-only" #ariaAnnounce aria-live="assertive"></div><div class="character-select input-group"><input class="form-control text-center" #nameInput type="text" [(ngModel)]="pony.name" [maxlength]="maxNameLength" placeholder="Name of your character" aria-label="Name of your character"><div class="input-group-append"><button class="btn btn-default" *ngIf="newButton" (click)="createNew()" [disabled]="!canNew" aria-label="Create New character">new</button><button class="btn btn-default" *ngIf="editButton" (click)="edit()" [disabled]="!canEdit" aria-label="Edit character">edit</button><div class="dropdown" dropdown #dropdown="ag-dropdown" (isOpenChange)="onToggle($event)" [focusOnOpen]="false"><button class="btn btn-default dropdown-toggle br-0" [ngClass]="removeButton ? \'btn-no-round\' : \'btn-no-round-left\'" [disabled]="!hasPonies || joining" dropdownToggle aria-label="Select character"></button><character-list class="dropdown-menu" *dropdownMenu (close)="dropdown.close()" (selectCharacter)="select($event)" (newCharacter)="createNew()" (previewCharacter)="preview.emit($event)" [canNew]="!newButton && canNew"></character-list></div><button class="btn btn-danger remove-button" *ngIf="removeButton && !removing" (click)="remove()" [disabled]="!canRemove" tooltip="Delete pony" aria-label="Delete pony"><fa-icon [icon]="deleteIcon" [fixedWidth]="true"></fa-icon></button><button class="btn btn-danger cancel-remove-button" *ngIf="removing" (click)="cancelRemove()" tooltip="Cancel delete" aria-label="Cancel delete"><fa-icon [icon]="removeIcon" [fixedWidth]="true"></fa-icon></button><button class="btn btn-success" *ngIf="removing" (click)="confirmRemove()" [disabled]="!canRemove" tooltip="Confirm delete" aria-label="Confirm delete"><fa-icon [icon]="confirmIcon" [fixedWidth]="true"></fa-icon></button></div></div>'
```

#### C. 角色列表组件
**文件**: `src/scripts/components/shared/character-list/character-list.js`
```javascript
// 第224行左右，替换templateUrl为：
template: '<div class="sr-only" #ariaAnnounce aria-live="assertive"></div><div class="character-list" [class.character-list-searchable]="searchable" [class.in-game]="inGame"><div class="dropdown character-select-search input-group" (mousedown)="$event.stopPropagation()" (mouseup)="$event.stopPropagation()" (click)="$event.stopPropagation()" (keydown)="keydown($event)"><input class="form-control" #searchInput type="search" [placeholder]="placeholder" [(ngModel)]="search" (input)="updatePonies()" autocomplete="nope"><div class="input-group-append" *ngIf="tags.length" #tagsDropdown="ag-dropdown" dropdown><button class="btn btn-secondary rounded-right" dropdownToggle title="Search by tags"><fa-icon [icon]="hashIcon"></fa-icon></button><div class="dropdown-menu dropdown-menu-right shadow tag-list" *dropdownMenu><button class="dropdown-item" *ngFor="let tag of tags" (click)="search = tag; tagsDropdown.close(); updatePonies()">{{tag}}</button></div></div></div><ul class="character-select-list" role="listbox" [attr.aria-activedescendant]="\'pony-item-\' + selectedIndex"><li *ngFor="let p of ponies; let i = index" [id]="\'pony-item-\' + i" [class.active]="i === selectedIndex" [class.selected]="p?.id === selectedPony?.id"><a class="d-flex" role="option" (click)="select(p)" (mouseenter)="setPreview(p)" (mouseleave)="unsetPreview(p)"><span class="flex-grow-1 character-name">{{p.name}}</span><span class="character-desc text-muted">{{p.desc}}</span></a></li><li *ngIf="canNew"><a class="text-center" role="option" (click)="createNew()"><em>new pony</em></a></li></ul></div>'
```

#### D. 游戏启动组件
**文件**: `src/scripts/components/shared/play-box/play-box.js`
```javascript
// 第270行左右，替换templateUrl为巨大的内联模板：
template: '<div class="form-group" *ngIf="hasTooManyPonies"><div class="alert alert-warning" role="alert">You have more than the allowed number of {{characterLimit}} ponies, the additional ones may get deleted. Remove some of your unused ponies to prevent losing the ones you want to keep.</div></div><div class="form-group" *ngIf="isMarkedForMultiples"><div class="alert alert-warning" role="alert">Your account has been flagged for creating multiple accounts. Creating more accounts may result in a permanent ban.</div></div><div class="form-group" *ngIf="accountAlert"><div class="alert alert-warning" role="alert">{{accountAlert}}</div></div><div class="form-group" *ngIf="leftMessage"><div class="alert alert-warning" role="alert">{{leftMessage}}</div></div><div class="form-group" *ngIf="isAndroidBrowser"><div class="alert alert-warning" role="alert">Your browser is outdated and is not able to correctly run Pony Town. Please install different browser to be able to play the game.</div></div><div class="form-group" *ngIf="model.missingBirthdate && !birthdateSet && requestBirthdate"><div class="alert alert-warning text-left" role="alert"><label for="birthdate">Set your date of birth</label><date-picker [(date)]="birthdate"></date-picker><div class="mt-2 text-right"><button class="btn btn-default px-4" (click)="saveBirthdate()">Save</button></div><p class="mb-0 mt-2">Please fill-in your <b>date of birth</b> in order to not lose access to the game in future updates.</p></div></div><div class="form-group dropdown" dropdown><div class="btn-group d-flex"><button class="btn btn-lg btn-success text-ellipsis flex-grow-1" #playButton (click)="joining ? cancel() : play()" [disabled]="!canPlay && !joining"><div *ngIf="joining"><fa-icon class="mr-1" [icon]="spinnerIcon" [spin]="true"></fa-icon>Cancel</div><div *ngIf="!joining && server"><strong>{{label || \'Play\'}}</strong> on <span>{{server.name}}</span></div><div class="text-faded" *ngIf="!joining && !server">select server to play</div></button><button class="btn btn-lg btn-success flex-grow-0 dropdown-toggle" dropdownToggle aria-label="select server" [disabled]="joining" style="position: relative"></button></div><div class="dropdown-menu w-100" *dropdownMenu style="overflow: hidden"><button class="dropdown-item" *ngFor="let s of servers" (click)="server = s; playButton.focus()"><div><div class="float-right" style="position: relative;"><div class="text-unsafe" *ngIf="s.offline"><span class="sr-only">server</span> offline</div><div class="text-muted" *ngIf="!s.offline">online <span class="sr-only">players</span> ({{s.online}})</div></div><div class="flag mr-2" *ngFor="let f of s.countryFlags" [ngClass]="\'flag-\' + f"></div><fa-icon class="text-muted mr-2" *ngIf="!hasFlag(s)" [icon]="getIcon(s)" size="lg"></fa-icon><strong>{{s.name}}</strong></div><div class="text-muted text-wrap">{{s.desc}}</div></button></div></div><div class="form-group text-left text-muted server-alert" *ngIf="server?.alert === \'18+\'"><fa-icon class="float-left p-2" [icon]="warningIcon" size="2x"></fa-icon>By playing on this server you confirm that you are over 18 years old and you take no issue with seeing adult topics.</div><div class="form-group text-left text-info server-alert" *ngIf="server?.alert === \'test\'"><fa-icon class="float-left p-2" [icon]="infoIcon" size="2x"></fa-icon>Supporter test server: Here you can try experimental and unfinished features that we\'re working on. Keep in mind everything is subject to change.</div><div class="form-group" *ngIf="server?.offline"><div class="alert alert-info" role="alert">Selected server is offline, try again later</div></div><div class="form-group" *ngIf="offline"><div class="alert alert-info" role="alert">Server is offline, try again later</div></div><div class="form-group" *ngIf="protectionError && !offline"><div class="alert alert-info" role="alert">Cloudflare error, <button class="btn btn-sm btn-outline-default" (click)="reload()">reload</button> to continue.</div></div><div class="form-group" *ngIf="updateWarning"><div class="alert alert-warning" role="alert">Server will restart shortly for updates and maintenance. Save your character to avoid losing any progress.</div></div><div class="form-group" *ngIf="isBrowserOutdated"><div class="alert alert-warning" role="alert"><button class="close float-right" (click)="dismissOutdatedBrowser()" aria-label="Close" style="font-size: 20px;">&times;</button>Your browser is outdated and is known to have issues running Pony Town. Make sure you have latest version installed.</div></div><div class="form-group" *ngIf="invalidVersion && !offline"><div class="alert alert-danger" role="alert">Your client version is outdated, <button class="btn btn-sm btn-outline-default" (click)="reload()">reload</button> to be able to play.</div></div><div class="form-group" *ngIf="isAccessError"><div class="alert alert-danger" role="alert">You\'re no longer signed-in, <button class="btn btn-sm btn-outline-default" (click)="reload()">reload</button> to be able to sign-in again.</div></div><div class="form-group" *ngIf="failedToLoadImages"><div class="alert alert-danger" role="alert">Failed to load game assets, <button class="btn btn-sm btn-outline-default" (click)="hardReload()">reload</button> to retry.</div></div><div class="form-group" *ngIf="isWebGLError"><div class="alert alert-danger" role="alert">Failed to create WebGL context. Your graphics card drivers or browser are outdated or graphics acceleration is disabled. Go to <a class="alert-link" href="http://webglreport.com/" tabindex>WebGL Report</a> to check WebGL support in your browser.</div></div><div class="form-group" *ngIf="isBrowserError"><div class="alert alert-danger" role="alert">Your browser is outdated, make sure you have the latest version installed.</div></div><div class="form-group" *ngIf="isOtherError"><div class="alert alert-danger" role="alert">{{error}}</div></div><div class="form-group text-left text-large" *ngIf="server"><h5>Server rules</h5><p class="text-muted list-rules">{{server.desc}}</p></div>'
```

### 第5步：其他必需修复

#### 版本验证修复
**文件**: `src/scripts/components/services/model.js` (约332行)
```javascript
return this.post('/api1/account', { version: data_1.version }, false);
```

#### 认证系统修复  
**文件**: `src/scripts/server/routes/auth.js` (约230行后添加)
```javascript
if (mockLogin) {
    passport_1.use(new passport_local_1.Strategy((login, _pass, done) => db_1.Account.findById(login, done)));
    app.post('/local', passport_1.authenticate('local', { successRedirect: '/', failureRedirect: '/failed-login' }));
    app.get('/local/:accountId', (req, res, next) => {
        req.body = { username: req.params.accountId, password: 'mock' };
        passport_1.authenticate('local', { successRedirect: '/', failureRedirect: '/failed-login' })(req, res, next);
    });
}
```

### 第6步：创建webpack简化配置
**文件**: `webpack.simple.js`
```javascript
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
```

### 第7步：MongoDB数据准备
```javascript
// 在MongoDB中创建测试数据
use ponytown
db.accounts.insertOne({
  _id: ObjectId("68acdc3543a9ff7ce48a3daa"),  
  name: "TestUser"
})

db.characters.insertOne({
  accountId: ObjectId("68acdc3543a9ff7ce48a3daa"),
  name: "TestPony",
  info: ""
})
```

### 第8步：创建模拟登录页面
**文件**: `mock-login.html`
```html
<!DOCTYPE html>
<html>
<head><title>Mock Login Test</title></head>
<body>
  <h1>Mock Login Test</h1>
  <form action="http://localhost:8090/auth/local" method="post">
    <label for="username">Account ID:</label>
    <input type="text" id="username" name="username" value="68acdc3543a9ff7ce48a3daa" />
    <input type="password" id="password" name="password" value="test" />
    <input type="submit" value="Mock Login" />
  </form>
</body>
</html>
```

### 第9步：资源文件修复
```bash
# 在assets目录创建符号链接
ln -sf pony-6ff79f30a5b1e7.png pony.png
ln -sf logo-large-ed7836a8bb7d7c.png logo-large.png
```

### 第10步：构建和启动
```bash
# 构建前端
npm run webpack:simple

# 启动服务器
DEVELOPMENT=true node pony-town.js --login --local --game
```

## 📊 需要修复的文件统计

| 类型 | 文件数量 | 关键文件 |
|------|----------|----------|
| 主要组件模板 | 4个 | app.js, character-select.js, character-list.js, play-box.js |
| 服务器修复 | 2个 | canvasUtilsNode.js, auth.js |
| API修复 | 1个 | model.js |
| 构建配置 | 1个 | webpack.simple.js |
| 测试页面 | 1个 | mock-login.html |
| 资源链接 | 多个 | 图片符号链接 |

## 🎯 核心原理
这个修复的核心是**绕过编译问题**：
- 使用已编译的JS文件而非重新编译TypeScript
- 将模板从外部文件转为内联，避免Pug编译
- Mock掉有问题的Canvas模块
- 简化webpack配置避开复杂依赖

通过这种方式，我们保持了原始架构，只是解决了兼容性问题，让6年前的代码能在现代环境运行。

**最终结果：完整可玩的多人在线游戏！** 🎮