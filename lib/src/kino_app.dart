import 'package:flutter/material.dart';

import 'models.dart';
import 'pages/public_surface_page.dart';
import 'pages/sso_mock_page.dart';
import 'sso_links.dart';
import 'theme.dart';

class KinoApp extends StatefulWidget {
  const KinoApp({
    super.key,
    required this.onNavigate,
    this.launch = PublicLaunch.empty,
    this.environment = const ClientEnvironment(),
    this.intentStore,
    this.onReplaceUrl,
    this.showBootSkeleton = true,
    this.bootDelay = const Duration(milliseconds: 2400),
    this.bootEnterDelay = const Duration(milliseconds: 1200),
  });

  final PublicLaunch launch;
  final ClientEnvironment environment;
  final SessionIntentStore? intentStore;
  final void Function(String url) onNavigate;
  final void Function(String url)? onReplaceUrl;
  final bool showBootSkeleton;
  final Duration bootDelay;
  final Duration bootEnterDelay;

  @override
  State<KinoApp> createState() => _KinoAppState();
}

class _KinoAppState extends State<KinoApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final launch = widget.launch;
    return MaterialApp(
      title: 'KinoFlux',
      debugShowCheckedModeBanner: false,
      theme: buildKinoTheme(Brightness.light),
      darkTheme: buildKinoTheme(Brightness.dark),
      themeMode: _mode,
      home: launch.isSsoMock
          ? SsoMockPage(
              clientId: launch.query['client_id']?.isNotEmpty == true
                  ? launch.query['client_id']!
                  : SsoLinks.clientId,
              intent: launch.intent ?? '立即登录',
              onNavigate: widget.onNavigate,
            )
          : PublicSurfacePage(
              launch: launch,
              environment: widget.environment,
              intentStore: widget.intentStore,
              onNavigate: widget.onNavigate,
              onReplaceUrl: widget.onReplaceUrl,
              onToggleTheme: _toggleTheme,
              showBootSkeleton: widget.showBootSkeleton,
              bootDelay: widget.bootDelay,
              bootEnterDelay: widget.bootEnterDelay,
            ),
    );
  }
}
