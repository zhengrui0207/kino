# KinoFlux (`kino_mash_app` 0.5.1)

Flutter Web 公开面，对应 Phase 1 / P0 可用性改造（US-01–US-08）。

信息架构、文案和 `INTENT_HASH` 与公开面原型一致：理解类内容（产品流程、术语、Demo、挑爆款说明）登录前可读；上传、开剪、库与工具的写入动作走登录墙。登录后编辑器、时间线、库内管理和审核工作台不在本阶段范围内。

## 运行

```bash
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

打开 `/` 或 `/home`。

## 登录

- 主路径：点击「去登录」后**同一窗口**进入 `/login-mock`（vkino IAM 的 mock，`client_id=kino-flux`），不把复制 URL 当作主路径。
- 降级：登录墙里折叠的「复制登录链接」是真实 `https://vkino.cn/kino-iam-platform/login` 授权地址，`state` 中带当前 intent。
- 回跳：`/?mock_session=1&intent=…#锚点` 只在公开面显示「你来自」，不进入登录后工作台。

意图对照见 `lib/src/intent_contract.dart`。`#storyline-hub` 只对应精品·故事线（Craft）；`#premium-hub` 只对应高精度解说。裂变 Demo 的工序不包含故事线。

## 范围之外

History API 深链、真实 SSO 会话、真实 Windows 安装包、投放数据回流产品化。数据反馈在生产循环上明确标注「尚未接入」。
