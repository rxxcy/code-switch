# Code Switch

AI Relay 管理工具，集中管理 Claude & Codex 供应商、热力墙与请求日志。基于 [Wails 3](https://v3.wails.io)。

## 预览
![亮色主界面](resources/images/code-switch.png)
![暗色主界面](resources/images/code-swtich-dark.png)
![日志亮色](resources/images/code-switch-logs.png)
![日志暗色](resources/images/code-switch-logs-dark.png)

## 开发准备
- Go 1.24+
- Node.js 18+
- npm / pnpm / yarn
- Wails 3 CLI：`go install github.com/wailsapp/wails/v3/cmd/wails3@latest`

## 开发运行
```bash
wails3 task dev
```

## 构建流程
1. 同步 build metadata：
   ```bash
   wails3 task common:update:build-assets
   ```
2. 打包 macOS `.app`：
   ```bash
   wails3 task package
   ```

### 交叉编译 Windows (macOS 环境)
1. 安装 `mingw-w64`：
   ```bash
   brew install mingw-w64
   ```
2. 运行 Windows 任务：
   ```bash
   wails3 task windows:build ARCH=amd64
   # 生成安装器
   wails3 task windows:package ARCH=amd64
   ```

## 发布
脚本 `scripts/publish_release.sh` 将自动打包并上传以下资产：
- `codeswitch-macos.zip`
- `codeswitch-arm64-installer.exe`
- `codeswitch.exe`

若要手动发布，可执行：
```bash
wails3 task package
wails3 task windows:package ARCH=amd64
scripts/publish_release.sh
```

## 常见问题
- 若 `.app` 无法打开，先执行 `wails3 task common:update:build-assets` 后再构建。
- macOS 交叉编译需要终端拥有完全磁盘访问权限，否则 `~/Library/Caches/go-build` 会报 *operation not permitted*。
