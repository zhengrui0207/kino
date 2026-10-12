import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kino_mash_app/src/kino_app.dart';
import 'package:kino_mash_app/src/models.dart';
import 'package:kino_mash_app/src/widgets/kino_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<List<String>> pumpPublic(
    WidgetTester tester, {
    PublicLaunch launch = PublicLaunch.empty,
    ClientEnvironment environment = const ClientEnvironment(isWindows: true),
    bool showBoot = false,
    Size size = const Size(1280, 900),
    Duration bootDelay = const Duration(seconds: 30),
    SessionIntentStore? store,
    List<String>? replaced,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final navigations = <String>[];
    await tester.pumpWidget(
      KinoApp(
        launch: launch,
        environment: environment,
        intentStore: store,
        showBootSkeleton: showBoot,
        bootDelay: bootDelay,
        bootEnterDelay: const Duration(milliseconds: 300),
        onNavigate: navigations.add,
        onReplaceUrl: replaced?.add,
      ),
    );
    return navigations;
  }

  testWidgets('US-01 hero, paths, and honest data-loop are readable logged out', (
    tester,
  ) async {
    await pumpPublic(tester);
    await tester.pumpAndSettle();

    expect(find.text('选剧，开剪。'), findsOneWidget);
    final flow = tester.widget<KinoButton>(find.byKey(const Key('btn-flow')));
    final login = tester.widget<KinoButton>(find.byKey(const Key('btn-login-hero')));
    final download = tester.widget<KinoButton>(find.byKey(const Key('btn-download')));
    expect(flow.label, '查看生产流程');
    expect(flow.variant, KinoButtonVariant.primary);
    expect(login.label, '登录后开剪');
    expect(login.variant, KinoButtonVariant.secondary);
    expect(download.label, '下载客户端（仅 Windows）');
    expect(download.variant, KinoButtonVariant.tertiary);
    expect(download.label, isNot(contains('推荐')));
    expect(ctaWeight(flow.variant), greaterThan(ctaWeight(login.variant)));
    expect(ctaWeight(login.variant), greaterThan(ctaWeight(download.variant)));
    expect(find.text('产品流程'), findsWidgets);
    expect(find.text('能力与 Demo'), findsOneWidget);
    expect(find.text('术语说明'), findsWidgets);
    expect(find.text('帮助/联系'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('data-loop-note')));
    expect(find.text('快速开始 · 生产循环'), findsOneWidget);
    expect(find.text('挑爆款'), findsWidgets);
    expect(find.text('数据反馈（尚未接入）'), findsOneWidget);
    expect(find.text('自动化创作 · 敬请期待 · 时间待定'), findsOneWidget);
    expect(find.textContaining('投放数据反馈尚未接入'), findsWidgets);
    expect(find.textContaining('从成片库下载后独立分发与测投'), findsOneWidget);
    expect(find.textContaining('Path A · 智能切片测投'), findsOneWidget);
    expect(find.textContaining('Path B · 精品重构'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('btn-flow')));
    await tester.tap(find.byKey(const Key('btn-flow')));
    await tester.pumpAndSettle();
    expect(find.text('快速开始 · 生产循环'), findsOneWidget);
  });

  testWidgets('US-02 glossary vernacular is on the page', (tester) async {
    await pumpPublic(tester);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('gloss-Remix')));
    expect(find.text('裂变改剪（多版本变体扩量）'), findsOneWidget);
    expect(find.text('智能切片（按剧情/高光切短视频）'), findsOneWidget);
    expect(find.text('精品重构（故事线 / 解说向）'), findsOneWidget);
    expect(find.textContaining('上传成片/剧集，进入待审素材库'), findsOneWidget);
  });

  testWidgets('US-03 login primary path redirects and hides the copy URL', (
    tester,
  ) async {
    final navigations = await pumpPublic(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn-login-top')));
    await tester.pumpAndSettle();

    expect(find.text('请先登录'), findsOneWidget);
    expect(find.text('去登录'), findsOneWidget);
    expect(find.text('备选：复制登录链接（降级，非主路径）'), findsOneWidget);
    expect(find.byKey(const Key('lw-url')), findsNothing);
    expect(find.textContaining('复制原始'), findsNothing);

    await tester.tap(find.byKey(const Key('lw-go')));
    await tester.pumpAndSettle();

    expect(navigations, hasLength(1));
    final uri = Uri.parse(navigations.single);
    expect(uri.path, '/login-mock');
    expect(uri.queryParameters['client_id'], 'kino-flux');
    expect(uri.queryParameters['intent'], '立即登录');

    await tester.tap(find.byKey(const Key('btn-login-hero')));
    await tester.pumpAndSettle();
    expect(find.textContaining('触发来源：登录后开剪'), findsOneWidget);
    await tester.tap(find.byKey(const Key('lw-fallback-toggle')));
    await tester.pumpAndSettle();
    final fallback = tester.widget<SelectableText>(find.byKey(const Key('lw-url')));
    final fallbackUri = Uri.parse(fallback.data!);
    expect(fallbackUri.host, 'vkino.cn');
    expect(fallbackUri.queryParameters['state'], 'intent=登录后开剪');
    expect(fallbackUri.queryParameters['client_id'], 'kino-flux');
  });

  testWidgets('US-04 entry cards separate test, batch, hit, and coming soon', (
    tester,
  ) async {
    final navigations = await pumpPublic(tester);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('entry-cut-test')));
    expect(find.textContaining('10–20 条试投切片'), findsWidgets);
    expect(find.textContaining('而非再试 10–20 条'), findsOneWidget);
    expect(find.text('挑爆款 · 有效素材'), findsOneWidget);
    expect(find.text('敬请期待 · 时间待定'), findsWidgets);

    final soon = tester.widget<KinoButton>(
      find.byKey(const ValueKey('disabled-entry-smart-commentary')),
    );
    expect(soon.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('gate-entry-cut-test')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('lw-go')));
    await tester.pumpAndSettle();
    expect(
      Uri.parse(navigations.single).queryParameters['intent'],
      '测投·智能切片',
    );
  });

  testWidgets('US-05 demos state input, output, and next step', (tester) async {
    await pumpPublic(tester, size: const Size(1280, 1000));
    await tester.pumpAndSettle();

    final fission = find.byKey(const ValueKey('anchor-fission-hub'));
    await tester.ensureVisible(fission);
    expect(
      find.descendant(of: fission, matching: find.textContaining('1 选有效片')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: fission, matching: find.textContaining('排故事线')),
      findsNothing,
    );
    expect(
      find.descendant(
        of: fission,
        matching: find.textContaining('已确认有效的切片（非整剧）'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: fission, matching: find.textContaining('多版本改剪')),
      findsOneWidget,
    );

    final story = find.byKey(const ValueKey('anchor-storyline-hub'));
    await tester.ensureVisible(story);
    expect(
      find.descendant(of: story, matching: find.text('精品 · 故事线（Craft）说明')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: story, matching: find.textContaining('2 排故事线')),
      findsOneWidget,
    );

    final premium = find.byKey(const ValueKey('anchor-premium-hub'));
    await tester.ensureVisible(premium);
    expect(
      find.descendant(of: premium, matching: find.text('高精度解说（Craft）演示')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: premium, matching: find.textContaining('排故事线')),
      findsNothing,
    );
    expect(
      find.descendant(
        of: premium,
        matching: find.textContaining('带高精度解说轨的精品成片'),
      ),
      findsOneWidget,
    );

    final highlight = find.byKey(const ValueKey('anchor-highlight-hub'));
    await tester.ensureVisible(highlight);
    expect(find.text('切点A'), findsOneWidget);
    expect(find.textContaining('整剧 / 多集成片源'), findsOneWidget);
  });

  testWidgets('US-06 non-windows download explains the block and the web path', (
    tester,
  ) async {
    await pumpPublic(
      tester,
      environment: const ClientEnvironment(isWindows: false),
    );
    await tester.pumpAndSettle();
    final banner = find.byKey(const Key('banner-narrow'));
    expect(banner, findsOneWidget);
    expect(
      find.descendant(of: banner, matching: find.textContaining('非 Windows')),
      findsWidgets,
    );
    expect(
      find.descendant(of: banner, matching: find.textContaining('窄屏')),
      findsNothing,
    );

    await tester.tap(find.byKey(const Key('btn-download')));
    await tester.pumpAndSettle();
    expect(find.textContaining('非 Windows 系统'), findsWidgets);
    expect(find.textContaining('请使用浏览器访问 Web'), findsOneWidget);
    final disabled = tester.widget<KinoButton>(find.byKey(const Key('dl-disabled')));
    expect(disabled.onPressed, isNull);
    expect(find.byKey(const Key('dl-use-web')), findsOneWidget);
  });

  testWidgets('US-06 windows keeps an illustrative download and no silent block', (
    tester,
  ) async {
    await pumpPublic(
      tester,
      environment: const ClientEnvironment(isWindows: true),
      size: const Size(1280, 900),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('banner-narrow')), findsNothing);

    await tester.tap(find.byKey(const Key('btn-download')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dl-illustrative')));
    await tester.pumpAndSettle();
    expect(find.textContaining('不触发真实下载'), findsOneWidget);
    expect(find.textContaining('kino_mash_app 0.5.1'), findsWidgets);
  });

  testWidgets('US-06 Windows narrow banner names the narrow reason only', (
    tester,
  ) async {
    await pumpPublic(
      tester,
      environment: const ClientEnvironment(isWindows: true, isNarrow: true),
      size: const Size(1280, 900),
    );
    await tester.pumpAndSettle();
    final banner = find.byKey(const Key('banner-narrow'));
    expect(banner, findsOneWidget);
    expect(
      find.descendant(of: banner, matching: find.textContaining('窄屏/非桌面宽度')),
      findsWidgets,
    );
    expect(
      find.descendant(of: banner, matching: find.textContaining('非 Windows')),
      findsNothing,
    );
  });

  testWidgets('US-07 contact form accepts input and reports empty submit', (
    tester,
  ) async {
    await pumpPublic(tester, size: const Size(1280, 900));
    await tester.pumpAndSettle();

    final submit = find.byKey(const Key('contact-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.textContaining('请完整填写必填项'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('contact-name')), '林可');
    await tester.enterText(find.byKey(const Key('contact-contact')), 'lin@example.com');
    await tester.ensureVisible(find.byKey(const Key('contact-topic')));
    await tester.tap(find.byKey(const Key('contact-topic')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('登录问题').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('contact-msg')), '登录后不知道回到哪一节。');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.textContaining('已提交（原型 mock，未发往服务端）'), findsOneWidget);
    expect(find.text('林可'), findsNothing);
  });

  testWidgets('intent return shows 你来自 and does not open a workstation', (
    tester,
  ) async {
    final replaced = <String>[];
    await pumpPublic(
      tester,
      launch: PublicLaunch(
        query: const {'mock_session': '1', 'intent': '精品·故事线'},
        fragment: 'storyline-hub',
      ),
      replaced: replaced,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('intent-bar')), findsOneWidget);
    expect(find.textContaining('你来自：'), findsOneWidget);
    expect(find.textContaining('精品·故事线'), findsWidgets);
    expect(find.textContaining('不进入登录后工作台'), findsWidgets);
    expect(find.byKey(const Key('mock-session-note')), findsOneWidget);
    expect(find.text('审核工作台'), findsNothing);
    expect(find.text('精品 · 故事线（Craft）说明'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('intent-clear')));
    await tester.tap(find.byKey(const Key('intent-clear')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('intent-bar')), findsNothing);
    expect(find.byKey(const Key('mock-session-note')), findsNothing);
    expect(replaced, isNotEmpty);
    expect(replaced.last, isNot(contains('intent=')));
  });

  testWidgets('library gate carries its own intent', (tester) async {
    final navigations = await pumpPublic(tester);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('gate-outputs')));
    await tester.tap(find.byKey(const ValueKey('gate-outputs')));
    await tester.pumpAndSettle();
    expect(find.textContaining('触发来源：成片库'), findsOneWidget);
    await tester.tap(find.byKey(const Key('lw-go')));
    await tester.pumpAndSettle();
    expect(Uri.parse(navigations.single).queryParameters['intent'], '成片库');
  });

  testWidgets('boot skeleton offers skip-to-flow', (tester) async {
    await pumpPublic(tester, showBoot: true);
    await tester.pump();
    expect(find.textContaining('正在加载 KinoFlux 工作台资源'), findsOneWidget);
    expect(find.textContaining('14MB'), findsWidgets);
    expect(find.text('先看流程（跳过加载）'), findsOneWidget);

    await tester.tap(find.byKey(const Key('skel-enter')));
    await tester.pump();
    expect(find.text('仍在拉取引擎资源…'), findsOneWidget);

    await tester.tap(find.byKey(const Key('skel-skip')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('boot-skel')), findsNothing);
    expect(find.text('快速开始 · 生产循环'), findsOneWidget);
  });

  testWidgets('SSO mock returns to the public anchor for the intent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final navigations = <String>[];
    await tester.pumpWidget(
      KinoApp(
        showBootSkeleton: false,
        onNavigate: navigations.add,
        launch: PublicLaunch(
          path: '/login-mock',
          query: const {'client_id': 'kino-flux', 'intent': '智能裂变'},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kino统一认证中心'), findsOneWidget);
    expect(find.textContaining('client_id：kino-flux'), findsOneWidget);
    expect(find.textContaining('登录意图 intent：智能裂变'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('sso-user')), 'editor@kino.test');
    await tester.enterText(find.byKey(const Key('sso-pass')), 'secret');
    await tester.tap(find.byKey(const Key('sso-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Mock 登录成功'), findsOneWidget);
    expect(find.textContaining('登录后编辑器'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sso-back-intent')));
    await tester.pumpAndSettle();
    final uri = Uri.parse(navigations.single);
    expect(uri.queryParameters['mock_session'], '1');
    expect(uri.queryParameters['intent'], '智能裂变');
    expect(uri.fragment, 'fission-hub');
  });

  testWidgets('narrow width lays out without overflow', (tester) async {
    await pumpPublic(
      tester,
      size: const Size(390, 844),
      environment: const ClientEnvironment(isWindows: false, isNarrow: true),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('banner-narrow')), findsOneWidget);
    expect(find.text('选剧，开剪。'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('data-loop-note')));
    expect(find.text('数据反馈（尚未接入）'), findsOneWidget);
  });

  testWidgets('theme fab and flow fab move the public surface', (tester) async {
    await pumpPublic(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('fab-theme')));
    await tester.pumpAndSettle();
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color(0xFF121018));

    await tester.tap(find.byKey(const Key('fab-flow')));
    await tester.pumpAndSettle();
    expect(find.text('快速开始 · 生产循环'), findsOneWidget);
  });
}
