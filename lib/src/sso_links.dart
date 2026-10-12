import 'intent_contract.dart';

/// vkino SSO identifiers and the two login URLs.
///
/// Primary path: same-window redirect to the in-app IAM mock (`/login-mock`),
/// which stands in for `https://vkino.cn/kino-iam-platform/login`.
/// Degradation path: the real authorize URL, folded in the login wall, and it
/// always carries the same intent in `state`.
class SsoLinks {
  const SsoLinks._();

  static const clientId = 'kino-flux';
  static const ssoHost = 'vkino.cn';
  static const versionLabel = 'kino_mash_app 0.5.1';
  static const redirectUri = 'https://kinoflux.tvjoy.cn/oauth/callback';
  static const authorizeBase = 'https://vkino.cn/kino-iam-platform/login';

  static String mockLoginLocation(String intent) {
    return Uri(
      path: '/login-mock',
      queryParameters: {
        'client_id': clientId,
        'from': 'app',
        'intent': intent,
      },
    ).toString();
  }

  /// Real authorize URL used only as the folded copy-link fallback.
  static String fallbackOAuthUrl(String intent) {
    final redirect = Uri.encodeComponent(redirectUri);
    final state = Uri.encodeComponent('intent=$intent');
    return '$authorizeBase'
        '?response_type=code'
        '&client_id=$clientId'
        '&redirect_uri=$redirect'
        '&scope=openid%20profile'
        '&state=$state';
  }

  /// Public-surface return. Does not open a post-login workstation.
  static String returnLocation(String intent) {
    final anchor = IntentContract.anchorFor(intent);
    final fragment = anchor.startsWith('#') ? anchor.substring(1) : anchor;
    return Uri(
      path: '/',
      queryParameters: {
        'mock_session': '1',
        'intent': intent,
      },
      fragment: fragment,
    ).toString();
  }
}
