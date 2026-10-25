<div align="center">

# 峰控手机智能体

**ZF FengKong Mobile — 装进手机口袋里的完整智能体**

*一个 App，就是完整的「朱峰社区智能体无限」——控制手机、遥控电脑，与 PC 版同一大脑、同一账号。*

</div>

---

## 为什么做这个项目

PC 端智能体已经很强，但人不会一直坐在电脑前。**峰控手机智能体**把整套智能体能力装进 Android 手机，让它成为**双向遥控枢纽**：

- **控制手机** — 智能体可以直接控制手机上的 App 完成任务
- **反向遥控电脑** — Termux 桥接通道直通 PC 端主仓智能体，人在外面用手机就能指挥家里的电脑干活
- **同一大脑** — 直连社区 LLM / 自有 API，手机端与 PC 端共享账号与上下文
- **界面零开发** — Android WebView 壳直接加载智能体 Web UI，PC 端界面升级手机端自动跟进
- **原生能力桥** — 通过 `NativeBridge (window.ZFMobile)` 暴露原生接口，逐步解锁手机独有能力
- **独立仓库** — 从 5.5.5 主仓库迁出，独立文件夹 + 独立 git，独立演进不受 PC 版发版节奏拖累

## 架构一览

```
┌──────────────────────────────────────────────┐
│           峰控手机智能体 App                   │
│         (Android WebView 壳 · Kotlin)         │
│                                              │
│   ┌────────────────────────────────────┐     │
│   │   智能体 Web UI（与 PC 完全一致）     │     │
│   └───────────────┬────────────────────┘     │
│                   │ window.ZFMobile          │
│   ┌───────────────▼────────────────────┐     │
│   │  NativeBridge 原生能力桥            │     │
│   │   P1  isApp / appVersion   完成     │     │
│   │   P2  Keystore token / LLM 直连  待做│    │
│   │   P3  SAF / HTTP               开发中│    │
│   └────────────────────────────────────┘     │
└──────────────────┬───────────────────────────┘
                   │  同一账号 · 同一大脑
        ┌──────────▼──────────┐    ┌──────────────┐
        │  社区 LLM / API 云端  │    │  PC 端主仓   │
        └─────────────────────┘    └──────────────┘
```

## 项目状态

| 阶段 | 状态 | 内容 |
|:---:|:---:|---|
| **P1** 骨架 | 完成过审 | MainActivity / NativeBridge / Prefs / Gradle 工程 |
| **P2** 直连 | 进行中 | LLM API 直连、账号打通 |
| **P3** 原生 | 开发中 | SAF 文件、HTTP 通道 |

## 构建

- Android Studio 打开根目录直接 Run；或命令行 `gradlew assembleRelease`
- 服务器地址：模拟器 `10.0.2.2` / 真机与 PC 同一局域网 IP / 云端正式版（P2 接入后开放）

> 签名使用本地 `zf.keystore`（已由 `.gitignore` 排除，**不随仓库分发**，请自行离线备份），与历史 v87~v93 同源，可直接覆盖升级。

## 项目结构

```
峰控手机智能体/
├── app/src/main/java/com/zhufeng/agent/mobile/
│   ├── MainActivity.kt      # WebView 壳
│   ├── NativeBridge.kt      # JS 与原生桥
│   └── Prefs.kt             # 配置存储
├── assets/web/              # 打进包内的 Web 资源
├── bridge/                  # Termux 桥 · PC 端脚本（协议 v1）
├── 手机端-termux_bridge/     # 手机端 Termux 侧脚本
├── share/zf_peak_scripts/   # 共享脚本
├── scripts/                 # 开发脚本
└── docs/                    # BUILD.md · PROGRESS.md · 详细文档
```

## 技术栈

`Kotlin` · `Android WebView` · `AGP 8.5.2` · `Gradle 8.7` · `JDK 17` · `Termux 桥接`

## 更多文档

- [构建细节](docs/BUILD.md)
- [开发进度存档](docs/PROGRESS.md)（逐轮收口记录、APK 归档 MD5）

---

<div align="center">

**朱峰社区智能体无限** 系列项目 · 手机端成员

</div>
