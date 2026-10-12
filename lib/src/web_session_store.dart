import 'package:web/web.dart' as web;

import 'models.dart';

/// `sessionStorage` backing store so a refresh can restore「你来自」.
class WebSessionIntentStore implements SessionIntentStore {
  static const _key = 'kf_intent';

  @override
  void clear() {
    web.window.sessionStorage.removeItem(_key);
  }

  @override
  String? read() {
    final value = web.window.sessionStorage.getItem(_key);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  void write(String intent) {
    web.window.sessionStorage.setItem(_key, intent);
  }
}
