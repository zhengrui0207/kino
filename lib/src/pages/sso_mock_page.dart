import 'package:flutter/material.dart';

import '../sso_links.dart';
import '../theme.dart';

/// Stand-in for the vkino IAM page. Success returns to the public surface
/// with the same intent; it does not open a post-login workstation.
class SsoMockPage extends StatefulWidget {
  const SsoMockPage({
    super.key,
    required this.clientId,
    required this.intent,
    required this.onNavigate,
  });

  final String clientId;
  final String intent;
  final void Function(String url) onNavigate;

  @override
  State<SsoMockPage> createState() => _SsoMockPageState();
}

class _SsoMockPageState extends State<SsoMockPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  var _tab = 'login';
  var _ok = false;

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _ok = true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
              decoration: BoxDecoration(
                color: colors.bgElev,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.line),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF281850).withValues(alpha: 0.12),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: _ok ? _success(colors) : _form(colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(KinoColors colors) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kino统一认证中心',
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Mock · 对应现网 vkino.cn IAM（非真实登录）',
                      style: TextStyle(color: colors.ink3, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            key: const Key('sso-meta'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line),
            ),
            child: DefaultTextStyle(
              style: TextStyle(color: colors.ink2, fontSize: 12, height: 1.7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('认证域：vkino.cn'),
                  Text('client_id：${widget.clientId}'),
                  Text('申请应用：KinoFlux · ${SsoLinks.versionLabel}'),
                  const Text('主路径：标准跳转 / 弹窗登录；裸 OAuth URL 复制仅为降级备选。'),
                  Text('登录意图 intent：${widget.intent}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _tabButton('login', '登录', colors)),
              const SizedBox(width: 8),
              Expanded(child: _tabButton('register', '注册', colors)),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('sso-user'),
            controller: _user,
            decoration: _decoration(colors, '账号', '手机号 / 邮箱'),
            autofillHints: const [AutofillHints.username],
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? '请填写账号' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('sso-pass'),
            controller: _pass,
            obscureText: true,
            decoration: _decoration(colors, '密码', '密码'),
            autofillHints: const [AutofillHints.password],
            validator: (value) =>
                (value == null || value.isEmpty) ? '请填写密码' : null,
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('sso-submit'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6B4EFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
            ),
            onPressed: _submit,
            child: const Text(
              '登录并返回 KinoFlux',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            key: const Key('sso-back-home'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
              side: BorderSide(color: colors.line),
            ),
            onPressed: () => widget.onNavigate('/#home'),
            child: Text('返回公开首页', style: TextStyle(color: colors.ink)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.warnBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.warnLine),
            ),
            child: Text(
              _tab == 'register'
                  ? '注册与登录在此 mock 中走同一返回。本页不进入、不臆造登录后工作台。成功后回到公开首页，并按 intent 显示「你来自」。'
                  : '本页仅作公开面的 SSO 标识与登录主路径示意。不进入、不臆造登录后工作台。成功后回到公开首页并提示「会话 mock 已建立」。',
              style: TextStyle(color: colors.warnInk, fontSize: 12, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _success(KinoColors colors) {
    return Column(
      key: const Key('sso-ok'),
      children: [
        Text(
          'Mock 登录成功',
          style: TextStyle(
            color: colors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '已模拟建立会话（client_id=${widget.clientId}）。登录后编辑器/库内 UI 不在 P0 范围。',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.ink3, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 14),
        FilledButton(
          key: const Key('sso-back-intent'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6B4EFF),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(46),
            shape: const StadiumBorder(),
          ),
          onPressed: () => widget.onNavigate(SsoLinks.returnLocation(widget.intent)),
          child: const Text(
            '按意图返回公开面',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _tabButton(String id, String label, KinoColors colors) {
    final on = _tab == id;
    return OutlinedButton(
      key: ValueKey('sso-tab-$id'),
      style: OutlinedButton.styleFrom(
        backgroundColor: on ? colors.brandSoft : colors.bgElev,
        foregroundColor: on ? colors.brandDeep : colors.ink,
        side: BorderSide(color: on ? colors.brandSoft : colors.line),
        shape: const StadiumBorder(),
      ),
      onPressed: () => setState(() => _tab = id),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  InputDecoration _decoration(KinoColors colors, String label, String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.line),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: colors.bgElev,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 2),
      ),
    );
  }
}
