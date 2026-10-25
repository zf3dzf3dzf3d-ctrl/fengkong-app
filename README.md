# 峰控手机智能体 (ZF FengKong Mobile)

> 手机里装一个 App，就是**完整的朱峰智能体无限**——和 PC 版几乎一模一样。
> 独立文件夹 + 独立 git 仓库，从 5.5.5 主仓库迁出定名「峰控手机智能体」。

## 一句话架构

```
┌─ 手机 App (Android WebView 壳) ────────────┐
│  加载智能体 Web UI（与 PC 完全一致，界面零开发）│
│  NativeBridge (window.ZFMobile)             │
│   ├─ P1: isApp / appVersion 占位            │
│   ├─ P2: Keystore token + LLM 直连          │
│   └─ P3: 无障碍读屏 / SAF 文件 / HTTP 工具    │
└─────────────────────────────────────────────┘
         │ 同一账号，同一大脑（社区 LLM / API）
```

## 阶段状态

| 阶段 | 状态 | 说明 |
|---|---|---|
| P1 骨架（WebView 壳） | ✅ 完成并过审 | MainActivity / NativeBridge / Prefs / Gradle (AGP 8.5.2 + Kotlin 1.9.24) |
| P3 无障碍工具层 | ⚠️ 代码完成、待真机验证 | ZFAccessibilityService + 桥接八接口已落盘 |
| P4 安全收口 | ⏳ 未开始 | cleartext 收回、WebView 调试关闭、token 安全 |
| P5 正式包 | ⏳ 未开始 | 品牌 mipmap 图标替换占位图标 |

## 构建

前置条件（二选一）：
- **推荐**：Android Studio 打开本仓库根目录（自动用内置 Gradle 同步）
- 或：Gradle 8.7+ / JDK 17 命令行：

```
gradlew assembleDebug
# 产物：app/build/outputs/apk/debug/app-debug.apk
```

当前签名用 zf.keystore，与历史 v87~v93 同源，可覆盖升级。

## 服务器地址

- 模拟器调试：`http://10.0.2.2:8555`
- 真机调试：同一局域网 `http://<PC局域网IP>:8555`（port.json host 改 0.0.0.0）
- 正式版：社区云端地址（P2 接入）

## 目录导览

| 路径 | 说明 |
|---|---|
| `app/src/main/java/com/zhufeng/agent/mobile/` | MainActivity.kt（WebView 壳）、NativeBridge.kt（JS↔原生桥）、Prefs.kt（配置存储） |
| `bridge/` | Termux 桥与 PC 端脚本（termux_bridge 协议 v1，见 bridge/README.md） |
| `手机端-termux_bridge/` | 手机端 Termux 侧脚本 |
| `assets/web/` | 打进包里的网页资源 |
| `share/zf_peak_scripts/` | 共享脚本 |
| `scripts/` | 图标生成等开发脚本 |
| `docs/` | 详细文档：BUILD.md / PROGRESS.md / README.md |

## 相关文档

- 构建细节：`docs/BUILD.md`
- 开发进度存档（逐轮收口记录、APK 归档 MD5）：`docs/PROGRESS.md`
- 最新发布：`zf-fengkong-v93.apk`（versionCode 118 / 5.5.28-v93，MD5 `e81aa34bb0cd33cee53962aab565cfe5`）

## 技术栈

Kotlin · Android WebView · AGP 8.5.2 · Gradle 8.7 · JDK 17 · Termux（桥接）
