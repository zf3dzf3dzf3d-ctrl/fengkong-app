# FACTS.md — README 事实源清单

> README 修订前必须对照本文件核对，杜绝「文案声称 ≠ 仓库事实」。

## 已跟踪内容（git ls-files 核准）
- Android 工程：app/（Kotlin，AGP 8.5.2，minSdk 24 / targetSdk 34，实测 build.gradle.kts）
- termux_bridge 脚本
- README.md、docs/、.gitignore

## 密钥状态
- zf.keystore：**未入库**（.gitignore 规则 `*.keystore` 命中），仅本地一份 + 仓库外备份 `_备份_仓库外\zf.keystore.20261025.bak`
- README 中写法：本地保留、不随仓库分发、需自行离线备份。禁止写成"仓库内容"。

## 底层能力表述规范
- 手机操控卖点的对外措辞：「智能体可以直接控制手机上的 App 完成任务」
- 禁用词（客户 README）：无障碍 / AccessibilityService / P1~P5 阶段编号 / 待做 / 开发中 / 项目状态表 / 版本号 vNN
- 禁用元素：emoji 图标、徽章图片（img.shields.io）

## 遗留事项
- git remote 为空：等用户提供 GitHub/Gitee 地址后推送，消除单机单点风险
- 仓库外 `_回收_手机端残留\`（手机版/手机端 旧目录）：待独立仓稳定运行一段时间后可整体删除

## 安全边界（对外表述必读）
- Termux 桥（bridge/、手机端-termux_bridge/）目前**无 token/鉴权机制**，仅限同一局域网内使用；对外文案不得宣称"公网安全遥控"，README 中如写遥控电脑须带「局域网」限定词。
