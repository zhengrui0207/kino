import 'package:flutter/material.dart';

import '../intent_contract.dart';
import '../public_content.dart';
import '../sso_links.dart';
import '../theme.dart';
import 'kino_button.dart';

class SurfaceLinks {
  const SurfaceLinks({
    required this.wide,
    required this.openLogin,
    required this.scrollTo,
    required this.openDownload,
    required this.keyFor,
  });

  final bool wide;
  final void Function(String intent) openLogin;
  final void Function(String sectionId) scrollTo;
  final VoidCallback openDownload;
  final GlobalKey Function(String id) keyFor;
}

class PublicBody extends StatelessWidget {
  const PublicBody({
    super.key,
    required this.links,
    required this.intentLabel,
    required this.showMockNote,
    required this.onClearIntent,
  });

  final SurfaceLinks links;
  final String? intentLabel;
  final bool showMockNote;
  final VoidCallback onClearIntent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageWrap(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (intentLabel != null) ...[
                const SizedBox(height: 12),
                IntentStrip(
                  intent: intentLabel!,
                  onOpen: () => links.scrollTo(
                    IntentContract.sectionIdFor(intentLabel!),
                  ),
                  onClear: onClearIntent,
                ),
              ],
              if (showMockNote) ...[
                const SizedBox(height: 8),
                const MockSessionNote(),
              ],
              const SizedBox(height: 8),
              HomeHero(links: links),
              const SizedBox(height: 8),
              const DegradeCallout(),
            ],
          ),
        ),
        PageWrap(child: FlowSection(links: links)),
        PageWrap(child: PathsSection(links: links)),
        PageWrap(child: EntriesSection(links: links)),
        PageWrap(child: DemosSection(links: links)),
        PageWrap(child: GlossarySection(links: links)),
        PageWrap(child: LibrariesSection(links: links)),
        PageWrap(child: ContactSection(links: links)),
        PageWrap(child: ProfileSection(links: links)),
        const PageWrap(child: SiteFooter()),
        const SizedBox(height: 72),
      ],
    );
  }
}

class PageWrap extends StatelessWidget {
  const PageWrap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

class IntentStrip extends StatelessWidget {
  const IntentStrip({
    super.key,
    required this.intent,
    required this.onOpen,
    required this.onClear,
  });

  final String intent;
  final VoidCallback onOpen;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      key: const Key('intent-bar'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.brandSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.brand.withValues(alpha: 0.25)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(color: colors.brandDeep, fontSize: 13),
              children: [
                const TextSpan(text: '你来自：'),
                TextSpan(
                  text: intent,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Text(
            '（公开面意图条 · 不进入登录后工作台）',
            style: TextStyle(color: colors.ink3, fontSize: 12),
          ),
          KinoButton(
            key: const Key('intent-go'),
            label: '查看对应说明',
            small: true,
            variant: KinoButtonVariant.ghost,
            onPressed: onOpen,
          ),
          KinoButton(
            key: const Key('intent-clear'),
            label: '清除',
            small: true,
            variant: KinoButtonVariant.ghost,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

class MockSessionNote extends StatelessWidget {
  const MockSessionNote({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      key: const Key('mock-session-note'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.warnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.warnLine),
      ),
      child: Text(
        'Mock 会话已建立（公开面）。按「你来自」意图查看对应说明即可；登录后工作台不在本范围。',
        style: TextStyle(color: colors.warnInk, fontSize: 13, height: 1.5),
      ),
    );
  }
}

class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            '选剧，开剪。',
            style: TextStyle(
              color: colors.ink,
              fontSize: links.wide ? 52 : 36,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '持续流动，持续裂变，持续进化',
          style: TextStyle(
            color: colors.brand,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'KinoFlux 帮助短剧团队在一个工作台里统一管理剧集与媒体素材，用 AI 完成智能切片、爆款裂变与精品重构，并自动生成解说、旁白、字幕与封面。投放数据回流尚在建设中——现行需从成片库下载后自行分发与测投，再开启下一轮创作。',
          style: TextStyle(color: colors.ink2, fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            KinoButton(
              key: const Key('btn-flow'),
              label: '查看生产流程',
              variant: KinoButtonVariant.primary,
              onPressed: () => links.scrollTo('get-started'),
            ),
            KinoButton(
              key: const Key('btn-login-hero'),
              label: '登录后开剪',
              variant: KinoButtonVariant.secondary,
              onPressed: () => links.openLogin('登录后开剪'),
            ),
            KinoButton(
              key: const Key('btn-download'),
              label: '下载客户端（仅 Windows）',
              variant: KinoButtonVariant.tertiary,
              tooltip: 'Windows-only · 三级入口',
              onPressed: links.openDownload,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '主路径：先看生产流程 → 再登录开剪。客户端为可选三级入口，仅 Windows；非 Windows / 窄屏请使用浏览器 Web。',
          style: TextStyle(color: colors.ink3, fontSize: 12, height: 1.45),
        ),
      ],
    );

    final hero = Anchor(
      id: 'home',
      links: links,
      child: Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 12),
        child: links.wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 11, child: copy),
                  const SizedBox(width: 32),
                  const Expanded(flex: 9, child: EngineCard()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  copy,
                  const SizedBox(height: 20),
                  const EngineCard(),
                ],
              ),
      ),
    );
    return hero;
  }
}

class EngineCard extends StatefulWidget {
  const EngineCard({super.key});

  @override
  State<EngineCard> createState() => _EngineCardState();
}

class _EngineCardState extends State<EngineCard> {
  int _index = 2;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final slide = kEngineSlides[_index];
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.hero0, colors.hero1, colors.hero2],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.brand.withValues(alpha: 0.18),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ENGINE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slide.$2,
            key: const Key('engine-title'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < kEngineSlides.length; i++)
                _EngineTab(
                  label: '${kEngineSlides[i].$1} · ${_engineShort(kEngineSlides[i].$1)}',
                  selected: i == _index,
                  onTap: () => setState(() => _index = i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFFFF8C50).withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final color in const [
                      Color(0xFF554433),
                      Color(0xFF443322),
                      Color(0xFF334455),
                      Color(0xFF445533),
                    ])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < kEngineSlides.length; i++)
                Container(
                  width: i == _index ? 18 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _index
                        ? const Color(0xFFC4B5FF)
                        : Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _engineShort(String id) {
    switch (id) {
      case 'Cut':
        return '智能切片';
      case 'Remix':
        return '裂变改剪';
      case 'Craft':
        return '精品重构';
      default:
        return id;
    }
  }
}

class _EngineTab extends StatelessWidget {
  const _EngineTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: selected ? 0.22 : 0.10),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class DegradeCallout extends StatelessWidget {
  const DegradeCallout({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgElev,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⏳', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '首屏较重 · 可先看流程再进工作台',
                  style: TextStyle(
                    color: colors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '现网 Flutter Web 首包约 14MB+（main.dart.js + canvaskit.wasm）。本页保留骨架加载态。未登录即可走完「产品流程 / 术语 / Demo」；上传与开剪等写入操作走登录。登录后工作台 UI 不在本 P0 范围。',
                  style: TextStyle(color: colors.ink2, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlowSection extends StatelessWidget {
  const FlowSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Anchor(
      id: 'get-started',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('产品流程 · /get-started'),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '快速开始 · 生产循环',
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: colors.line),
                      ),
                      child: Text(
                        '自动化创作 · 敬请期待 · 时间待定',
                        style: TextStyle(
                          color: colors.ink3,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'KinoFlux 主张「影像内容持续流动」——一部剧进入流水线后，切片、测投、裂变、精品重构可循环迭代。',
                  style: TextStyle(color: colors.ink2, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: '生产循环',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (var i = 0; i < kFlowSteps.length; i++) ...[
                        FlowChip(step: kFlowSteps[i]),
                        if (i != kFlowSteps.length - 1)
                          Text('→', style: TextStyle(color: colors.ink3)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                HonestNote(onPickHit: () => links.scrollTo('pick-hit')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HonestNote extends StatelessWidget {
  const HonestNote({super.key, required this.onPickHit});

  final VoidCallback onPickHit;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final style = TextStyle(color: colors.warnInk, fontSize: 13, height: 1.55);
    return Container(
      key: const Key('data-loop-note'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.warnBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.warnLine),
      ),
      child: Text.rich(
        TextSpan(
          style: style,
          children: [
            const TextSpan(
              text: '「数据反馈」步诚实降级（US-08） — ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text:
                  '投放数据反馈尚未接入。现行 workaround：从成片库下载后独立分发与测投，再人工进入下一轮；请勿按「已自动回流」做排期。\n',
            ),
            const TextSpan(
              text: '「挑爆款」步公开口径：',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text: '数据环未接入时，依据完播/互动等需结合站外投放结果或成片库下载后的独立分发数据筛选有效素材，再进入智能裂变（见 ',
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: InkWell(
                key: const Key('link-pick-hit'),
                onTap: onPickHit,
                child: Text(
                  '入口卡',
                  style: style.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const TextSpan(text: '）。'),
          ],
        ),
      ),
    );
  }
}

class PathsSection extends StatelessWidget {
  const PathsSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    return Anchor(
      id: 'paths',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('两条主路径'),
          Tiled(
            wide: links.wide,
            columns: 2,
            children: [
              Anchor(
                id: 'path-a',
                links: links,
                child: PathCard(
                  title: 'Path A · 智能切片测投 → 智能裂变扩量',
                  lead: '先用小批量切片试效果，确认有效素材后再多版本改剪扩量。',
                  bullets: const [
                    '能做什么：10–20 条试投切片；成本可控；多版本扩量',
                    '建议节奏：切片测投 → 挑爆款/有效素材 → 有效片裂变 → 确认量级后再精品',
                    '衔接说明：投放数据环未接入时，挑爆款依据完播/互动等需在站外或成片库侧完成；公开面提供说明卡（见入口区）。',
                  ],
                  actions: [
                    (
                      '高光切片 Demo',
                      () => links.scrollTo('highlight-hub'),
                    ),
                    (
                      '裂变 Demo',
                      () => links.scrollTo('fission-hub'),
                    ),
                  ],
                ),
              ),
              Anchor(
                id: 'path-b',
                links: links,
                child: PathCard(
                  muted: true,
                  title: 'Path B · 精品重构（故事线 / 高精度解说）',
                  lead: '在测投验证后，面向精品输出做故事线重编或高精度解说轨。',
                  bullets: const [
                    '精品·故事线：按故事线重编的精品向成片',
                    '精品·高精度解说：高精度解说轨成片',
                    '精品·智能解说：尚未开放（时间待定）',
                  ],
                  actions: [
                    (
                      '故事线说明',
                      () => links.scrollTo('storyline-hub'),
                    ),
                    (
                      '高精度解说 Demo',
                      () => links.scrollTo('premium-hub'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class EntriesSection extends StatelessWidget {
  const EntriesSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    return Anchor(
      id: 'entries',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const SectionLabel('开剪入口（公开可读 · 写入需登录）'),
          Tiled(
            wide: links.wide,
            columns: 3,
            children: [
              for (final entry in kEntries)
                Anchor(
                  id: entry.id == 'pick-hit' ? 'pick-hit' : 'entry-slot-${entry.id}',
                  links: links,
                  child: EntryCard(entry: entry, links: links),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemosSection extends StatelessWidget {
  const DemosSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    return Anchor(
      id: 'demos',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const SectionLabel('公开 Demo · 工序条 + 输入/输出示意 + 下一步'),
          Tiled(
            wide: links.wide,
            columns: 3,
            children: [
              for (final demo in kDemos)
                Anchor(
                  id: demo.id,
                  links: links,
                  child: DemoCard(demo: demo, links: links),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class GlossarySection extends StatelessWidget {
  const GlossarySection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Anchor(
      id: 'glossary',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const SectionLabel('术语白话对照'),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '术语说明',
                  style: TextStyle(
                    color: colors.ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '剪辑/切片场景对照（与入口卡文案一致）。',
                  style: TextStyle(color: colors.ink2, fontSize: 14),
                ),
                const SizedBox(height: 12),
                for (final term in kGlossary)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: links.wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 168,
                                child: Text(
                                  term.term,
                                  style: TextStyle(
                                    color: colors.brandDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  term.definition,
                                  key: ValueKey('gloss-${term.term}'),
                                  style: TextStyle(
                                    color: colors.ink2,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                term.term,
                                style: TextStyle(
                                  color: colors.brandDeep,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                term.definition,
                                key: ValueKey('gloss-${term.term}'),
                                style: TextStyle(color: colors.ink2, height: 1.45),
                              ),
                            ],
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LibrariesSection extends StatelessWidget {
  const LibrariesSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    return Anchor(
      id: 'libs',
      links: links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('库与工具（登录后可用 · 公开仅说明）'),
          Tiled(
            wide: links.wide,
            columns: 2,
            children: [
              for (final lib in kLibraries)
                Anchor(
                  id: lib.id,
                  links: links,
                  child: LibCard(spec: lib, links: links),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _msg = TextEditingController();
  String? _message;
  bool _error = false;

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _msg.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    final valid = form?.validate() ?? false;
    if (valid) {
      form!.reset();
      _name.clear();
      _contact.clear();
      _msg.clear();
    }
    setState(() {
      _error = !valid;
      _message = valid
          ? '已提交（原型 mock，未发往服务端）。我们会尽快联系您。'
          : '请完整填写必填项后再提交。';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Anchor(
      id: 'faq',
      links: widget.links,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const SectionLabel('帮助 / 联系 · /faq'),
          Panel(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '帮助与联系',
                    style: TextStyle(
                      color: colors.ink,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '登录或理解失败时可提交联系信息（表单可聚焦、可输入、可提交）。',
                    style: TextStyle(color: colors.ink2, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        _field(
                          key: const Key('contact-name'),
                          label: '称呼',
                          hint: '怎么称呼您',
                          controller: _name,
                          autofill: AutofillHints.name,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          key: const Key('contact-contact'),
                          label: '联系方式',
                          hint: '邮箱 / 手机 / 企业微信',
                          controller: _contact,
                          autofill: AutofillHints.email,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: const Key('contact-topic'),
                          initialValue: null,
                          isExpanded: true,
                          decoration: _decoration(colors, '问题类型'),
                          hint: const Text('请选择'),
                          items: [
                            for (final topic in kContactTopics)
                              DropdownMenuItem(value: topic, child: Text(topic)),
                          ],
                          onChanged: (_) {},
                          validator: (value) =>
                              (value == null || value.isEmpty) ? '请选择问题类型' : null,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          key: const Key('contact-msg'),
                          label: '描述',
                          hint: '简要描述遇到的问题',
                          controller: _msg,
                          lines: 4,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: KinoButton(
                            key: const Key('contact-submit'),
                            label: '提交留言',
                            onPressed: _submit,
                          ),
                        ),
                        if (_message != null) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _message!,
                              key: const Key('form-msg'),
                              style: TextStyle(
                                color: _error ? colors.danger : colors.ok,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required Key key,
    required String label,
    required String hint,
    required TextEditingController controller,
    String? autofill,
    int lines = 1,
  }) {
    final colors = kinoColorsOf(context);
    return TextFormField(
      key: key,
      controller: controller,
      minLines: lines,
      maxLines: lines,
      enabled: true,
      autofillHints: autofill == null ? null : [autofill],
      decoration: _decoration(colors, label).copyWith(hintText: hint),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? '请填写$label' : null,
    );
  }

  InputDecoration _decoration(KinoColors colors, String label) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.line),
    );
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: colors.bg,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.brand, width: 2),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.links});

  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Anchor(
      id: 'profile',
      links: links,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '个人中心 · /profile（公开面占位）',
                style: TextStyle(
                  color: colors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '登录后的账号与会话能力不在本 P0 范围臆造。请使用「立即登录」走 vkino SSO。',
                style: TextStyle(color: colors.ink2, fontSize: 14),
              ),
              const SizedBox(height: 10),
              KinoButton(
                key: const Key('btn-login-profile'),
                label: '立即登录',
                small: true,
                onPressed: () => links.openLogin('立即登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    final style = TextStyle(color: colors.ink3, fontSize: 12, height: 1.6);
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 24),
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: style.copyWith(color: colors.ink2),
                children: [
                  const TextSpan(
                    text: 'KinoFlux',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' 公开面可用性改造 · Phase 1 P0 · 版本对外 ${SsoLinks.versionLabel}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'SSO：${SsoLinks.ssoHost} · client_id=${SsoLinks.clientId} · 主路径为标准跳转；不臆造登录后工作台。',
              style: style,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgElev,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '路由对照（公开引导参考 · 深链仍按 PRD P1；本页用页内锚点）',
                    style: TextStyle(
                      color: colors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    kRouteIndex,
                    style: style.copyWith(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Desktop-first：下载为三级弱入口且 Windows-only（无「推荐」标记）；非 Windows / 窄屏见顶栏「请用浏览器 Web」。meta 含 user-scalable=no；非 100% 缩放时顶栏提示。',
                    style: style,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry, required this.links});

  final EntrySpec entry;
  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Opacity(
      opacity: entry.dim ? 0.62 : 1,
      child: Container(
        key: ValueKey(entry.id),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.bgElev,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.soon != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.soon!,
                  style: TextStyle(
                    color: colors.ink3,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              entry.title,
              style: TextStyle(
                color: colors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(entry.meta, style: TextStyle(color: colors.ink3, fontSize: 12)),
            const SizedBox(height: 8),
            for (final line in entry.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: colors.ink2, fontSize: 13, height: 1.45),
                    children: [
                      if (line.label.isNotEmpty)
                        TextSpan(
                          text: line.label,
                          style: TextStyle(
                            color: colors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      TextSpan(text: line.text),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in entry.actions)
                  KinoButton(
                    key: ValueKey(
                      action.disabled
                          ? 'disabled-${entry.id}'
                          : action.gate
                              ? 'gate-${entry.id}'
                              : 'link-${entry.id}-${action.scrollTo}',
                    ),
                    label: action.label,
                    small: true,
                    variant: action.gate
                        ? KinoButtonVariant.primary
                        : KinoButtonVariant.ghost,
                    onPressed: action.disabled
                        ? null
                        : action.gate
                            ? () => links.openLogin(entry.intent)
                            : () => links.scrollTo(action.scrollTo!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DemoCard extends StatelessWidget {
  const DemoCard({super.key, required this.demo, required this.links});

  final DemoSpec demo;
  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElev,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: const Color(0xFF1A1528),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (var i = 0; i < demo.steps.length; i++) ...[
                        _StepPill(demo.steps[i]),
                        if (i != demo.steps.length - 1)
                          Text(
                            '→',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: StoryPaneView(pane: demo.panes[0])),
                      const Padding(
                        padding: EdgeInsets.only(top: 36, left: 4, right: 4),
                        child: Text(
                          '→',
                          style: TextStyle(
                            color: Color(0xFFCFC4FF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(child: StoryPaneView(pane: demo.panes[1])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  demo.title,
                  style: TextStyle(
                    color: colors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text('输入：${demo.input}', style: TextStyle(color: colors.ink2, fontSize: 12)),
                Text('输出：${demo.output}', style: TextStyle(color: colors.ink2, fontSize: 12)),
                Text('下一步：${demo.next}', style: TextStyle(color: colors.ink2, fontSize: 12, height: 1.4)),
                const SizedBox(height: 10),
                KinoButton(
                  key: ValueKey('gate-${demo.id}'),
                  label: demo.buttonLabel,
                  small: true,
                  variant: KinoButtonVariant.soft,
                  onPressed: () => links.openLogin(demo.gateIntent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoryPaneView extends StatelessWidget {
  const StoryPaneView({super.key, required this.pane});

  final StoryPane pane;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pane.label,
            style: const TextStyle(
              color: Color(0xFFB9A8FF),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  pane.metaLeft,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                pane.metaRight,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (pane.segments.isNotEmpty || pane.cuts.isNotEmpty)
            _Timeline(segments: pane.segments, cuts: pane.cuts),
          if (pane.compare.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final chip in pane.compare)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      chip,
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: _frameGradient(pane.frameKind),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                pane.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            pane.mapLine,
            style: const TextStyle(color: Color(0xFFEFEAFF), fontSize: 10, height: 1.35),
          ),
        ],
      ),
    );
  }

  LinearGradient _frameGradient(String kind) {
    switch (kind) {
      case 'out':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A3A), Color(0xFF36CFC9), Color(0xFF112222)],
        );
      case 'fission':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A2030), Color(0xFFFF7A59), Color(0xFF2A2150)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A2F5C), Color(0xFF6B4EFF), Color(0xFF2A2150)],
        );
    }
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.segments, required this.cuts});

  final List<TimelineSeg> segments;
  final List<TimelineCut> cuts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        Color segColor(String kind) {
          switch (kind) {
            case 'out':
              return const Color(0xCC36CFC9);
            case 'fis':
              return const Color(0xD9FF7A59);
            case 'voice':
              return const Color(0xD9FFD666);
            default:
              return const Color(0xBF6B4EFF);
          }
        }

        return SizedBox(
          height: cuts.isEmpty ? 28 : 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 4,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              for (final seg in segments)
                Positioned(
                  left: width * seg.left,
                  width: width * seg.width,
                  bottom: seg.kind == 'voice' ? 6 : 8,
                  height: seg.kind == 'voice' ? 5 : 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: segColor(seg.kind),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              for (final cut in cuts)
                Positioned(
                  left: (width * cut.left - 16).clamp(0, width - 32),
                  top: 0,
                  child: Column(
                    children: [
                      Text(
                        cut.label,
                        style: const TextStyle(
                          color: Color(0xFFFFD666),
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 16,
                        color: const Color(0xFFFFD666),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFEFEAFF),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class LibCard extends StatelessWidget {
  const LibCard({super.key, required this.spec, required this.links});

  final LibSpec spec;
  final SurfaceLinks links;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgElev,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.brandSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(spec.icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spec.title,
                  style: TextStyle(
                    color: colors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(color: colors.ink2, fontSize: 12, height: 1.45),
                    children: [
                      TextSpan(text: spec.body),
                      if (spec.warn != null)
                        TextSpan(
                          text: spec.warn,
                          style: TextStyle(
                            color: colors.warn,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                KinoButton(
                  key: ValueKey(
                    spec.disabled ? 'disabled-${spec.id}' : 'gate-${spec.id}',
                  ),
                  label: spec.buttonLabel ?? '登录后使用',
                  small: true,
                  variant: KinoButtonVariant.ghost,
                  onPressed: spec.disabled
                      ? null
                      : () => links.openLogin(spec.gateIntent ?? '需登录操作'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PathCard extends StatelessWidget {
  const PathCard({
    super.key,
    required this.title,
    required this.lead,
    required this.bullets,
    required this.actions,
    this.muted = false,
  });

  final String title;
  final String lead;
  final List<String> bullets;
  final List<(String, VoidCallback)> actions;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Opacity(
      opacity: muted ? 0.92 : 1,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color.alphaBlend(colors.ink.withValues(alpha: 0.03), colors.bgElev),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(lead, style: TextStyle(color: colors.ink2, fontSize: 13)),
            const SizedBox(height: 8),
            for (final bullet in bullets)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('· ', style: TextStyle(color: colors.ink2)),
                    Expanded(
                      child: Text(
                        bullet,
                        style: TextStyle(color: colors.ink2, fontSize: 13, height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in actions)
                  KinoButton(
                    label: action.$1,
                    small: true,
                    variant: KinoButtonVariant.ghost,
                    onPressed: action.$2,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlowChip extends StatelessWidget {
  const FlowChip({super.key, required this.step});

  final FlowStep step;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Tooltip(
      message: step.hint ?? step.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: step.muted ? colors.warnBg : colors.brandSoft,
          borderRadius: BorderRadius.circular(999),
          border: step.muted ? Border.all(color: colors.warnLine) : null,
        ),
        child: Text(
          step.label,
          style: TextStyle(
            color: step.muted ? colors.warnInk : colors.brandDeep,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.bgElev,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF281850).withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = kinoColorsOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          color: colors.brand,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class Tiled extends StatelessWidget {
  const Tiled({
    super.key,
    required this.wide,
    required this.columns,
    required this.children,
  });

  final bool wide;
  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = wide ? columns : 1;
        const gap = 14.0;
        final maxWidth = constraints.maxWidth;
        final width = cols == 1 ? maxWidth : (maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class Anchor extends StatelessWidget {
  const Anchor({
    super.key,
    required this.id,
    required this.links,
    required this.child,
  });

  final String id;
  final SurfaceLinks links;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey('anchor-$id'),
      child: Container(key: links.keyFor(id), child: child),
    );
  }
}
