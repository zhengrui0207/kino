/// Where the public shell was opened from (path, query, fragment).
class PublicLaunch {
  const PublicLaunch({
    this.path = '/',
    this.query = const {},
    this.fragment,
  });

  static const empty = PublicLaunch();

  final String path;
  final Map<String, String> query;
  final String? fragment;

  factory PublicLaunch.fromUri(Uri uri) {
    return PublicLaunch(
      path: uri.path.isEmpty ? '/' : uri.path,
      query: Map.unmodifiable(uri.queryParameters),
      fragment: uri.fragment.isEmpty ? null : uri.fragment,
    );
  }

  String? get intent {
    final value = query['intent'];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  bool get mockSession => query['mock_session'] == '1';

  bool get isSsoMock => _normalize(path) == '/login-mock';

  bool get isPublicSurface {
    final p = _normalize(path);
    return p == '/' || p == '/home' || p == '/index.html';
  }

  static String _normalize(String path) {
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }
}

/// Remembers the last public intent for the「你来自」strip.
abstract class SessionIntentStore {
  String? read();
  void write(String intent);
  void clear();
}

class MemoryIntentStore implements SessionIntentStore {
  String? _value;

  @override
  void clear() => _value = null;

  @override
  String? read() => _value;

  @override
  void write(String intent) => _value = intent;
}

/// Desktop-first environment signals used by US-06 and the top banners.
class ClientEnvironment {
  const ClientEnvironment({
    this.isWindows = false,
    this.isNarrow = false,
    this.zoomAnomaly = false,
  });

  final bool isWindows;
  final bool isNarrow;
  final bool zoomAnomaly;

  bool get showBrowserBanner => !isWindows || isNarrow;

  /// Windows desktop can offer the (still illustrative) client download.
  bool get windowsDesktopDownload => isWindows && !isNarrow;

  String get downloadBlockReason {
    if (!isWindows) return '非 Windows 系统';
    if (isNarrow) return '窄屏/非桌面宽度';
    return '';
  }

  static ClientEnvironment detect({
    required String userAgent,
    required int viewportWidth,
    required double devicePixelRatio,
    double? visualViewportScale,
    required int outerWidth,
    required int innerWidth,
  }) {
    final isWindows = RegExp(
      'Windows',
      caseSensitive: false,
    ).hasMatch(userAgent);
    final isNarrow = viewportWidth <= 960;
    final scaleOdd =
        visualViewportScale != null && (visualViewportScale - 1).abs() > 0.02;
    final dprOdd = (devicePixelRatio - devicePixelRatio.round()).abs() > 0.01;
    final ratioOdd =
        innerWidth > 0 && (outerWidth / innerWidth - 1).abs() > 0.05;
    return ClientEnvironment(
      isWindows: isWindows,
      isNarrow: isNarrow,
      zoomAnomaly: scaleOdd || dprOdd || ratioOdd,
    );
  }
}
