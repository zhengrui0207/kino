/// Public-surface intent → in-page anchor contract.
///
/// Shared by the login gate, the SSO mock return URL, and the「你来自」strip.
/// Keep this table aligned with the Phase 1 prototype INTENT_HASH
/// (`index.html` and `login-mock.html`).
class IntentContract {
  const IntentContract._();

  static const Map<String, String> hashByIntent = {
    '测投·智能切片': '#entries',
    '量产·智能切片': '#entries',
    '挑爆款·有效素材': '#pick-hit',
    '智能裂变': '#fission-hub',
    '精品·故事线': '#storyline-hub',
    '精品·高精度解说': '#premium-hub',
    '精品·智能解说': '#entries',
    '高光切片 Demo 后开剪': '#highlight-hub',
    '裂变 Demo 后开剪': '#fission-hub',
    '解说 Demo 后创作': '#premium-hub',
    '素材库': '#materials',
    '成片库': '#outputs',
    '创作草稿': '#drafts',
    '任务': '#tasks',
    '视频处理模板': '#templates',
    'AI前贴': '#intros',
    'AI封面': '#covers',
    '登录后开剪': '#get-started',
    '立即登录': '#get-started',
    '需登录操作': '#get-started',
  };

  /// Anchor for [intent], including the leading `#`.
  /// Unknown intents fall back to the public production-flow section.
  static String anchorFor(String intent) =>
      hashByIntent[intent] ?? '#get-started';

  static String sectionIdFor(String intent) {
    final anchor = anchorFor(intent);
    return anchor.startsWith('#') ? anchor.substring(1) : anchor;
  }
}
