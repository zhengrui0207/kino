import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web/web.dart' as web;

import 'src/kino_app.dart';
import 'src/models.dart';
import 'src/web_session_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final launch = PublicLaunch.fromUri(Uri.base);
  final viewport = web.window.visualViewport;
  final environment = ClientEnvironment.detect(
    userAgent: web.window.navigator.userAgent,
    viewportWidth: web.window.innerWidth,
    devicePixelRatio: web.window.devicePixelRatio,
    visualViewportScale: viewport?.scale,
    outerWidth: web.window.outerWidth,
    innerWidth: web.window.innerWidth,
  );
  runApp(
    KinoApp(
      launch: launch,
      environment: environment,
      intentStore: WebSessionIntentStore(),
      onNavigate: (url) => web.window.location.assign(url),
      onReplaceUrl: (url) => web.window.history.replaceState(null, '', url),
    ),
  );
}
