import 'package:flutter/material.dart';

import '../models.dart';
import '../sso_links.dart';
import '../theme.dart';
import 'kino_button.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key, required this.environment});

  final ClientEnvironment environment;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final allowed = environment.windowsDesktopDownload;
    return Dialog(
      backgroundColor: colors.bgElev,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '下载客户端',
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('dl-close'),
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              if (allowed)
                Text(
                  '检测到 Windows 桌面环境。客户端为可选三级入口。本页不提供真实安装包；请优先使用浏览器 Web 完成流程理解与登录。',
                  style: TextStyle(color: colors.ink2, height: 1.5),
                )
              else
                Text.rich(
                  TextSpan(
                    style: TextStyle(color: colors.ink2, height: 1.55, fontSize: 14),
                    children: [
                      const TextSpan(
                        text: '当前环境无法使用 Windows 客户端。\n',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: '原因：${environment.downloadBlockReason}。\n'),
                      const TextSpan(
                        text: '替代路径：请使用浏览器访问 Web（本页即可继续查看流程与 Demo）。不出现静默禁用。',
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (allowed) ...[
                    KinoButton(
                      key: const Key('dl-illustrative'),
                      label: '下载 Windows 客户端（示意）',
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('未开始下载'),
                            content: Text(
                              '示意：不触发真实下载。\n版本：${SsoLinks.versionLabel}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('知道了'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    KinoButton(
                      label: '仍用浏览器 Web',
                      variant: KinoButtonVariant.ghost,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ] else ...[
                    KinoButton(
                      key: const Key('dl-use-web'),
                      label: '请用浏览器 Web',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    KinoButton(
                      key: const Key('dl-disabled'),
                      label: '下载客户端（仅 Windows）',
                      tooltip: '非 Windows / 窄屏已禁用，请用浏览器 Web',
                      onPressed: null,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
