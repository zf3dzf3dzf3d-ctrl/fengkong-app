<div align="center">

# 📱 峰控手机智能体

**ZF FengKong Mobile — 装进手机口袋里的完整智能体**

[![Platform](https://img.shields.io/badge/platform-Android%207.0%2B-3ddc84?logo=android)]()
[![Language](https://img.shields.io/badge/language-Kotlin-7f52ff?logo=kotlin)]()
[![Build](https://img.shields.io/badge/AGP-8.5.2-167dff?logo=gradle)]()
[![Latest](https://img.shields.io/badge/release-v93-orange)]()
[![Repo](https://img.shields.io/badge/status-independent--repo-success)]()

*一个 App，就是完整的「朱峰社区智能体无限」——与 PC 版同一大脑、同一账号、几乎同一界面。*

</div>

---

## ✨ 为什么做这个项目

PC 端智能体已经很强，但人不会一直坐在电脑前。**峰控手机智能体**把整套智能体能力装进 Android 手机：

- 🧠 **同一大脑** — 直连社区 LLM / 自有 API，手机端与 PC 端共享账号与上下文
- 🖥️ **界面零开发** — Android WebView 壳直接加载智能体 Web UI，PC 端界面升级手机端自动跟进
- 🔌 **原生能力桥** — 通过 `NativeBridge (window.ZFMobile)` 暴露原生接口，逐步解锁手机独有能力
- 📦 **独立仓库** — 从 5.5.5 主仓库迁出，独立文件夹 + 独立 git，独立演进不受 PC 版发版节奏拖累

## 🏗️ 架构一览

```
┌──────────────────────────────────────────────┐
│           📱 峰控手机智能体 App                │
│         (Android WebView 壳 · Kotlin)         │
│                                              │
│   ┌────────────────────────────────────┐     │
│   │   智能体 Web UI（与 PC 完全一致）     │     │
│   └───────────────┬────────────────────┘     │
│                   │ window.ZFMobile          │
│   ┌───────────────▼────────────────────┐     │
│   │  NativeBridge 原生能力桥            │     │
│   │   P1  isApp / appVersion   ✅       │     │
│   │   P2  Keystore token / LLM 直连 ⏳  │     │
│   │   P3  无障碍读屏 / SAF / HTTP  🔧   │     │
│   └────────────────────────────────────┘     │
└──────────────────┬───────────────────────────┘
                   │  同一账号 · 同一大脑
        ┌──────────▼──────────┐    ┌──────────────┐
        │  社区 LLM / API 云端  │    │ 🖥️ PC 端主仓 │
        └─────────────────────┘    └──────────────┘
```

## 📊 项目状态

| 阶段 | 状态 | 内容 |
|:---:|:---:|---|
| **P1** 骨架 | ✅ 完成过审 | MainActivity / NativeBridge / Prefs / Gradle 工程 |
| **P3** 无障碍工具层 | 🔧 待真机验证 | ZFAccessibilityService + 桥接八接口已落盘 |
| **P2** 安全与直连 | ⏳ 计划中 | Keystore token、LLM 直连、cleartext 收回 |
| **P4** 安全收口 | ⏳ 计划中 | WebView 调试关闭、token 加固 |
| **P5** 正式包 | ⏳ 计划中 | 品牌 mipmap 图标、正式签名发布 |

> 📦 最新发布：`zf-fengkong-v93.apk`（versionCode 118 · MD5 `e81aa34b...`）

## 🚀 快速开始

### 构建 APK

```bash
# 前置：Android Studio（推荐）或 Gradle 8.7+ / JDK 17
git clone <本仓库>
cd 峰控手机智能体
./gradlew assembleDebug
# 产物 → app/build/outputs/apk/debug/app-debug.apk
```

### 连接智能体服务

| 场景 | 地址 |
|---|---|
| 模拟器调试 | `http://10.0.2.2:8555` |
| 真机（同一局域网） | `http://<PC局域网IP>:8555`（port.json host 改 `0.0.0.0`） |
| 正式版 | 社区云端（P2 接入后开放） |

> 🔑 签名使用 `zf.keystore`，与历史 v87~v93 同源，可直接覆盖升级。

## 📂 项目结构

```
峰控手机智能体/
├── app/src/main/java/com/zhufeng/agent/mobile/
│   ├── MainActivity.kt      # WebView 壳
│   ├── NativeBridge.kt      # JS ↔ 原生桥
│   └── Prefs.kt             # 配置存储
├── assets/web/              # 打进包内的 Web 资源
├── bridge/                  # Termux 桥 · PC 端脚本（协议 v1）
├── 手机端-termux_bridge/     # 手机端 Termux 侧脚本
├── share/zf_peak_scripts/   # 共享脚本
├── scripts/                 # 图标生成等开发脚本
└── docs/                    # BUILD.md · PROGRESS.md · 详细文档
```

## 🛠️ 技术栈

`Kotlin` · `Android WebView` · `AccessibilityService` · `AGP 8.5.2` · `Gradle 8.7` · `JDK 17` · `Termux 桥接`

## 📖 更多文档

- 🧾 [构建细节](docs/BUILD.md)
- 📜 [开发进度存档](docs/PROGRESS.md)（逐轮收口记录、APK 归档 MD5）

---

<div align="center">

**朱峰社区智能体无限** 系列项目 · 手机端成员

</div>
