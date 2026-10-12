import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../sso_links.dart';
import '../theme.dart';
import 'kino_button.dart';

/// Login wall: standard redirect is the primary action.
/// Copy-link stays collapsed and always includes the current intent.
class LoginWallDialog extends StatefulWidget {
  const LoginWallDialog({
    super.key,
    required this.intent,
    required this.onGo,
    this.onCopy,
  });

  final String intent;
  final VoidCallback onGo;
  final Future<void> Function(String text)? onCopy;

  @override
  State<LoginWallDialog> createState() => _LoginWallDialogState();
}

class _LoginWallDialogState extends State<LoginWallDialog> {
  bool _fallbackOpen = false;
  String _copyLabel = '复制链接';

  String get _fallbackUrl => SsoLinks.fallbackOAuthUrl(widget.intent);

  Future<void> _copy() async {
    final copy = widget.onCopy;
    try {
      if (copy != null) {
        await copy(_fallbackUrl);
      } else {
        await Clipboard.setData(ClipboardData(text: _fallbackUrl));
      }
      if (!mounted) return;
      setState(() => _copyLabel = '已复制（含 intent）');
    } catch (_) {
      if (!mounted) return;
      setState(() => _copyLabel = '请手动选择复制');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Dialog(
      backgroundColor: colors.bgElev,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '请先登录',
                      key: const Key('lw-title'),
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('lw-close'),
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                '当前操作需要登录后才能继续。确认后将打开 Kino 统一认证（vkino.cn）。',
                style: TextStyle(color: colors.ink2, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                '触发来源：${widget.intent}',
                key: const Key('lw-source'),
                style: TextStyle(color: colors.ink3, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  KinoButton(
                    key: const Key('lw-go'),
                    label: '去登录',
                    onPressed: widget.onGo,
                  ),
                  KinoButton(
                    key: const Key('lw-cancel'),
                    label: '取消',
                    variant: KinoButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: const Key('lw-fallback-toggle'),
                  onPressed: () => setState(() => _fallbackOpen = !_fallbackOpen),
                  child: Text(
                    '备选：复制登录链接（降级，非主路径）',
                    style: TextStyle(
                      color: colors.ink3,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (_fallbackOpen) ...[
                SelectableText(
                  _fallbackUrl,
                  key: const Key('lw-url'),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: colors.ink2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: KinoButton(
                    key: const Key('lw-copy'),
                    label: _copyLabel,
                    small: true,
                    variant: KinoButtonVariant.ghost,
                    onPressed: _copy,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
