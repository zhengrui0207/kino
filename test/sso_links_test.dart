import 'package:flutter_test/flutter_test.dart';
import 'package:kino_mash_app/src/models.dart';
import 'package:kino_mash_app/src/sso_links.dart';

void main() {
  test('primary login is a same-window mock redirect carrying intent', () {
    final url = SsoLinks.mockLoginLocation('精品·故事线');
    final uri = Uri.parse(url);
    expect(uri.path, '/login-mock');
    expect(uri.queryParameters['client_id'], 'kino-flux');
    expect(uri.queryParameters['intent'], '精品·故事线');
    expect(url, isNot(contains('kino-iam-platform')));
  });

  test('folded fallback is the vkino authorize URL and carries intent', () {
    final url = SsoLinks.fallbackOAuthUrl('测投·智能切片');
    final uri = Uri.parse(url);
    expect(uri.host, 'vkino.cn');
    expect(uri.path, '/kino-iam-platform/login');
    expect(uri.queryParameters['response_type'], 'code');
    expect(uri.queryParameters['client_id'], 'kino-flux');
    expect(
      uri.queryParameters['redirect_uri'],
      'https://kinoflux.tvjoy.cn/oauth/callback',
    );
    expect(uri.queryParameters['scope'], 'openid profile');
    expect(uri.queryParameters['state'], 'intent=测投·智能切片');
  });

  test('return URL stays on the public surface and uses the intent anchor', () {
    final uri = Uri.parse(SsoLinks.returnLocation('挑爆款·有效素材'));
    expect(uri.path, '/');
    expect(uri.queryParameters['mock_session'], '1');
    expect(uri.queryParameters['intent'], '挑爆款·有效素材');
    expect(uri.fragment, 'pick-hit');

    final story = Uri.parse(SsoLinks.returnLocation('精品·故事线'));
    expect(story.fragment, 'storyline-hub');
    final premium = Uri.parse(SsoLinks.returnLocation('精品·高精度解说'));
    expect(premium.fragment, 'premium-hub');
    final fission = Uri.parse(SsoLinks.returnLocation('裂变 Demo 后开剪'));
    expect(fission.fragment, 'fission-hub');
  });

  test('launch parsing keeps intent, mock session, and fragment', () {
    final launch = PublicLaunch.fromUri(
      Uri.parse(
        'https://kinoflux.tvjoy.cn/home?mock_session=1&intent=智能裂变#fission-hub',
      ),
    );
    expect(launch.isPublicSurface, isTrue);
    expect(launch.isSsoMock, isFalse);
    expect(launch.mockSession, isTrue);
    expect(launch.intent, '智能裂变');
    expect(launch.fragment, 'fission-hub');

    final sso = PublicLaunch.fromUri(
      Uri.parse('https://kinoflux.tvjoy.cn/login-mock?client_id=kino-flux&intent=立即登录'),
    );
    expect(sso.isSsoMock, isTrue);
    expect(sso.intent, '立即登录');
  });

  test('environment detection explains non-windows and zoom', () {
    final linux = ClientEnvironment.detect(
      userAgent: 'Mozilla/5.0 (X11; Linux x86_64)',
      viewportWidth: 1440,
      devicePixelRatio: 1,
      visualViewportScale: 1,
      outerWidth: 1440,
      innerWidth: 1440,
    );
    expect(linux.isWindows, isFalse);
    expect(linux.showBrowserBanner, isTrue);
    expect(linux.windowsDesktopDownload, isFalse);
    expect(linux.downloadBlockReason, '非 Windows 系统');

    final windowsNarrow = ClientEnvironment.detect(
      userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
      viewportWidth: 800,
      devicePixelRatio: 1,
      visualViewportScale: 1,
      outerWidth: 800,
      innerWidth: 800,
    );
    expect(windowsNarrow.windowsDesktopDownload, isFalse);
    expect(windowsNarrow.downloadBlockReason, '窄屏/非桌面宽度');

    final windows = ClientEnvironment.detect(
      userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
      viewportWidth: 1440,
      devicePixelRatio: 1,
      visualViewportScale: 1,
      outerWidth: 1440,
      innerWidth: 1440,
    );
    expect(windows.windowsDesktopDownload, isTrue);
    expect(windows.showBrowserBanner, isFalse);

    final zoom = ClientEnvironment.detect(
      userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
      viewportWidth: 1440,
      devicePixelRatio: 1.25,
      visualViewportScale: 1,
      outerWidth: 1440,
      innerWidth: 1440,
    );
    expect(zoom.zoomAnomaly, isTrue);
  });
}
