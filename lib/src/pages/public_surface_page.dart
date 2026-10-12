import 'dart:async';

import 'package:flutter/material.dart';

import '../intent_contract.dart';
import '../models.dart';
import '../public_content.dart';
import '../sso_links.dart';
import '../theme.dart';
import '../widgets/download_dialog.dart';
import '../widgets/kino_button.dart';
import '../widgets/login_wall.dart';
import '../widgets/surface_sections.dart';

class PublicSurfacePage extends StatefulWidget {
  const PublicSurfacePage({
    super.key,
    required this.launch,
    required this.environment,
    required this.onNavigate,
    this.intentStore,
    this.onReplaceUrl,
    this.onToggleTheme,
    this.showBootSkeleton = true,
    this.bootDelay = const Duration(milliseconds: 2400),
    this.bootEnterDelay = const Duration(milliseconds: 1200),
  });

  final PublicLaunch launch;
  final ClientEnvironment environment;
  final void Function(String url) onNavigate;
  final SessionIntentStore? intentStore;
  final void Function(String url)? onReplaceUrl;
  final VoidCallback? onToggleTheme;
  final bool showBootSkeleton;
  final Duration bootDelay;
  final Duration bootEnterDelay;

  @override
  State<PublicSurfacePage> createState() => _PublicSurfacePageState();
}

class _PublicSurfacePageState extends State<PublicSurfacePage> {
  final Map<String, GlobalKey> _keys = {};
  final ScrollController _scroll = ScrollController();
  Timer? _bootTimer;
  bool _boot = false;
  bool _enterBusy = false;
  String? _intent;
  bool _mockNote = false;
  String _activeNav = 'home';
  late final SessionIntentStore _store;

  @override
  void initState() {
    super.initState();
    _store = widget.intentStore ?? MemoryIntentStore();
    final fromQuery = widget.launch.intent;
    final stored = _store.read();
    final intent = fromQuery ?? stored;
    if (intent != null && intent.isNotEmpty) {
      _intent = intent;
      _store.write(intent);
    }
    _mockNote = widget.launch.mockSession;
    if (widget.showBootSkeleton) {
      _boot = true;
      _bootTimer = Timer(widget.bootDelay, _finishBoot);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_boot) _scrollToInitial();
    });
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(String id) => _keys.putIfAbsent(id, GlobalKey.new);

  void _finishBoot() {
    if (!mounted) return;
    setState(() {
      _boot = false;
      _enterBusy = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToInitial());
  }

  void _continueWaiting() {
    _bootTimer?.cancel();
    setState(() => _enterBusy = true);
    _bootTimer = Timer(widget.bootEnterDelay, _finishBoot);
  }

  void _skipBoot() {
    _bootTimer?.cancel();
    setState(() {
      _boot = false;
      _enterBusy = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo('get-started'));
  }

  void _scrollToInitial() {
    final fragment = widget.launch.fragment;
    if (fragment != null && fragment.isNotEmpty) {
      _scrollTo(fragment, animated: false);
      return;
    }
    final intent = _intent;
    if (intent != null) {
      _scrollTo(IntentContract.sectionIdFor(intent), animated: false);
    }
  }

  void _scrollTo(String id, {bool animated = true}) {
    final target = _keys[id]?.currentContext;
    if (target == null) return;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    Scrollable.ensureVisible(
      target,
      alignment: 0,
      duration: (!animated || reduceMotion)
          ? Duration.zero
          : const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _syncNav() {
    final viewport = context.findRenderObject();
    if (viewport is! RenderBox || !viewport.hasSize) return;
    var current = 'home';
    for (final item in kNavItems) {
      final box = _keys[item.$1]?.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
      if (dy <= 120) current = item.$1;
    }
    if (current != _activeNav && mounted) {
      setState(() => _activeNav = current);
    }
  }

  Future<void> _openLogin(String intent) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return LoginWallDialog(
          intent: intent,
          onGo: () {
            Navigator.of(dialogContext).pop();
            widget.onNavigate(SsoLinks.mockLoginLocation(intent));
          },
        );
      },
    );
  }

  void _openDownload() {
    final environment = _liveEnvironment;
    showDialog<void>(
      context: context,
      builder: (_) => DownloadDialog(environment: environment),
    );
  }

  void _clearIntent() {
    _store.clear();
    setState(() {
      _intent = null;
      _mockNote = false;
    });
    final replace = widget.onReplaceUrl;
    if (replace == null) return;
    final path = widget.launch.path.isEmpty ? '/' : widget.launch.path;
    final fragment = widget.launch.fragment;
    final hash = (fragment == null || fragment.isEmpty) ? '' : '#$fragment';
    replace('$path$hash');
  }

  bool get _wide => MediaQuery.sizeOf(context).width > 960;

  ClientEnvironment get _liveEnvironment {
    final narrow =
        widget.environment.isNarrow || MediaQuery.sizeOf(context).width <= 960;
    return ClientEnvironment(
      isWindows: widget.environment.isWindows,
      isNarrow: narrow,
      zoomAnomaly: widget.environment.zoomAnomaly,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final environment = _liveEnvironment;
    final links = SurfaceLinks(
      wide: _wide,
      openLogin: _openLogin,
      scrollTo: _scrollTo,
      openDownload: _openDownload,
      keyFor: _keyFor,
    );

    return Scaffold(
      backgroundColor: colors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              if (widget.environment.zoomAnomaly)
                _Banner(
                  key: const Key('banner-zoom'),
                  color: colors.warnBg,
                  ink: colors.warnInk,
                  tag: '显示缩放',
                  text:
                      '检测到非 100% 显示缩放或 DPR 异常，桌面端布局可能错位。建议系统显示缩放设为 100% 后刷新。（现网 meta：user-scalable=no，偏向桌面固定逻辑像素）',
                ),
              if (environment.showBrowserBanner)
                _Banner(
                  key: const Key('banner-narrow'),
                  color: colors.infoBg,
                  ink: colors.infoInk,
                  tag: environment.downloadBlockReason,
                  text:
                      '本产品 Desktop-first。客户端下载仅支持 Windows（非主 CTA）。当前原因：${environment.downloadBlockReason}。请直接使用浏览器 Web，勿依赖客户端安装包。',
                ),
              _Header(
                wide: _wide,
                active: _activeNav,
                onScroll: _scrollTo,
                onLogin: () => _openLogin('立即登录'),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis == Axis.vertical) {
                      _syncNav();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    key: const Key('public-scroll'),
                    controller: _scroll,
                    child: PublicBody(
                      links: links,
                      intentLabel: _intent,
                      showMockNote: _mockNote,
                      onClearIntent: _clearIntent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: Column(
              children: [
                _FabButton(
                  key: const Key('fab-home'),
                  tooltip: '回到首页',
                  label: 'K',
                  onPressed: () => _scrollTo('home'),
                ),
                const SizedBox(height: 8),
                _FabButton(
                  key: const Key('fab-theme'),
                  tooltip: '切换浅色/深色示意',
                  label: '☾',
                  onPressed: widget.onToggleTheme ?? () {},
                ),
                const SizedBox(height: 8),
                _FabButton(
                  key: const Key('fab-flow'),
                  tooltip: '滚到产品流程',
                  label: '◎',
                  onPressed: () => _scrollTo('get-started'),
                ),
              ],
            ),
          ),
          if (_boot)
            BootSkeleton(
              enterBusy: _enterBusy,
              onEnter: _continueWaiting,
              onSkip: _skipBoot,
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.wide,
    required this.active,
    required this.onScroll,
    required this.onLogin,
  });

  final bool wide;
  final String active;
  final void Function(String id) onScroll;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final width = MediaQuery.sizeOf(context).width;
    return Material(
      color: colors.bgElev.withValues(alpha: 0.92),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.line)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => onScroll('home'),
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6B4EFF),
                                      Color(0xFF36CFC9),
                                      Color(0xFFFF7A59),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'KinoFlux',
                                style: TextStyle(
                                  color: colors.ink,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (wide)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final item in kNavItems)
                                    _NavLink(
                                      label: item.$2,
                                      selected: active == item.$1,
                                      onTap: () => onScroll(item.$1),
                                    ),
                                ],
                              ),
                            ),
                          )
                        else
                          const Spacer(),
                        if (width >= 720) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: colors.line),
                            ),
                            child: Text(
                              SsoLinks.versionLabel,
                              style: TextStyle(color: colors.ink3, fontSize: 11),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        KinoButton(
                          key: const Key('btn-login-top'),
                          label: '立即登录',
                          small: true,
                          onPressed: onLogin,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!wide)
              SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        for (final item in kMobileNavItems) ...[
                          ActionChip(
                            label: Text(item.$2),
                            onPressed: () => onScroll(item.$1),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: selected ? colors.brandDeep : colors.ink2,
          backgroundColor: selected ? colors.brandSoft : Colors.transparent,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    super.key,
    required this.color,
    required this.ink,
    required this.tag,
    required this.text,
  });

  final Color color;
  final Color ink;
  final String tag;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ink.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class BootSkeleton extends StatelessWidget {
  const BootSkeleton({
    super.key,
    required this.enterBusy,
    required this.onEnter,
    required this.onSkip,
  });

  final bool enterBusy;
  final VoidCallback onEnter;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Positioned.fill(
      child: ColoredBox(
        key: const Key('boot-skel'),
        color: const Color(0xFFF6F8FA),
        child: Semantics(
          liveRegion: true,
          label: '正在加载 KinoFlux 工作台资源',
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6B4EFF),
                            Color(0xFF36CFC9),
                            Color(0xFFFF7A59),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '正在加载 KinoFlux 工作台资源…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _LoadBar(),
                    const SizedBox(height: 16),
                    Text(
                      '现网首屏约需拉取 main.dart.js ≈ 7MB + canvaskit.wasm ≈ 7MB（合计约 14MB+），不假设秒开。本页用骨架态表示首包等待。',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.ink2, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.brandSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.brand.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        '降级叙事（可先看流程再进工作台）\n若网络较慢，可先浏览「产品流程 / 术语 / Demo」了解选剧→切片→裂变→精品路径；写入类操作（上传、开剪、库管理）仍需登录。理解类内容不设门禁。',
                        style: TextStyle(color: colors.ink2, fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        KinoButton(
                          key: const Key('skel-enter'),
                          label: enterBusy ? '仍在拉取引擎资源…' : '继续等待进入首页',
                          variant: KinoButtonVariant.dark,
                          onPressed: enterBusy ? null : onEnter,
                        ),
                        KinoButton(
                          key: const Key('skel-skip'),
                          label: '先看流程（跳过加载）',
                          variant: KinoButtonVariant.ghost,
                          onPressed: onSkip,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadBar extends StatelessWidget {
  const _LoadBar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: const SizedBox(
        width: 320,
        height: 6,
        child: LinearProgressIndicator(
          backgroundColor: Color(0xFFE8E4F0),
          color: Color(0xFF6B4EFF),
        ),
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  const _FabButton({
    super.key,
    required this.tooltip,
    required this.label,
    required this.onPressed,
  });

  final String tooltip;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: colors.bgElev,
        shape: CircleBorder(side: BorderSide(color: colors.line)),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
