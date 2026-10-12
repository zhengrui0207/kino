// Copy and information architecture for the public surface.
// Wording follows the Phase 1 prototype; post-login screens are not invented.

class GlossaryTerm {
  const GlossaryTerm(this.term, this.definition);
  final String term;
  final String definition;
}

class FlowStep {
  const FlowStep(this.label, {this.muted = false, this.hint});
  final String label;
  final bool muted;
  final String? hint;
}

class RichLine {
  const RichLine(this.label, this.text);
  final String label;
  final String text;
}

class EntryAction {
  const EntryAction.link(this.label, this.scrollTo)
      : gate = false,
        disabled = false;

  const EntryAction.gate(this.label)
      : scrollTo = null,
        gate = true,
        disabled = false;

  const EntryAction.disabled(this.label)
      : scrollTo = null,
        gate = false,
        disabled = true;

  final String label;
  final String? scrollTo;
  final bool gate;
  final bool disabled;
}

class EntrySpec {
  const EntrySpec({
    required this.id,
    required this.title,
    required this.meta,
    required this.lines,
    required this.intent,
    required this.actions,
    this.dim = false,
    this.soon,
  });

  final String id;
  final String title;
  final String meta;
  final List<RichLine> lines;
  final String intent;
  final List<EntryAction> actions;
  final bool dim;
  final String? soon;
}

class TimelineSeg {
  const TimelineSeg({
    required this.left,
    required this.width,
    this.kind = 'in',
  });

  /// 0–1 across the timeline.
  final double left;
  final double width;

  /// `in` (brand), `out` (teal), `fis` (coral).
  final String kind;
}

class TimelineCut {
  const TimelineCut(this.left, this.label);
  final double left;
  final String label;
}

class StoryPane {
  const StoryPane({
    required this.label,
    required this.metaLeft,
    required this.metaRight,
    required this.caption,
    required this.mapLine,
    this.frameKind = 'in',
    this.segments = const [],
    this.cuts = const [],
    this.compare = const [],
  });

  final String label;
  final String metaLeft;
  final String metaRight;
  final String caption;
  final String mapLine;
  final String frameKind;
  final List<TimelineSeg> segments;
  final List<TimelineCut> cuts;
  final List<String> compare;
}

class DemoSpec {
  const DemoSpec({
    required this.id,
    required this.title,
    required this.steps,
    required this.input,
    required this.output,
    required this.next,
    required this.buttonLabel,
    required this.gateIntent,
    required this.panes,
  });

  final String id;
  final String title;
  final List<String> steps;
  final String input;
  final String output;
  final String next;
  final String buttonLabel;
  final String gateIntent;
  final List<StoryPane> panes;

  bool get procedureMentionsStoryline =>
      steps.any((step) => step.contains('故事线'));
}

class LibSpec {
  const LibSpec({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    this.gateIntent,
    this.buttonLabel,
    this.disabled = false,
    this.warn,
  });

  final String id;
  final String icon;
  final String title;
  final String body;
  final String? gateIntent;
  final String? buttonLabel;
  final bool disabled;
  final String? warn;
}

const kFlowSteps = <FlowStep>[
  FlowStep('一部剧'),
  FlowStep('上传审库'),
  FlowStep('智能切片'),
  FlowStep('成片审核'),
  FlowStep('挑爆款', hint: '场景B衔接；数据环未接入时依完播/互动等公开口径'),
  FlowStep('智能裂变'),
  FlowStep('精品重构'),
  FlowStep('数据反馈（尚未接入）', muted: true, hint: '尚未接入'),
  FlowStep('下一轮'),
];

const kGlossary = <GlossaryTerm>[
  GlossaryTerm('选剧，开剪', '选定一部剧，开始出切片'),
  GlossaryTerm('Cut', '智能切片（按剧情/高光切短视频）'),
  GlossaryTerm('Remix', '裂变改剪（多版本变体扩量）'),
  GlossaryTerm('Craft', '精品重构（故事线 / 解说向）'),
  GlossaryTerm('测投·智能切片', '先切一版去投放试效果'),
  GlossaryTerm('量产·智能切片', '批量出切片'),
  GlossaryTerm('智能裂变', '基于有效切片做多版改剪'),
  GlossaryTerm(
    '挑爆款 / 有效素材',
    '按完播、互动等公开口径筛选高潜切片，产出入选裂变池的有效素材清单（数据环未接入时需结合站外/成片库下载后的分发数据）',
  ),
  GlossaryTerm('上传审库', '上传成片/剧集，进入待审素材库'),
  GlossaryTerm('成片审核', '人工或规则确认可分发切片'),
  GlossaryTerm('精品·故事线', '按故事线重编的精品向成片'),
  GlossaryTerm('精品·高精度解说', '高精度解说轨成片'),
  GlossaryTerm('精品·智能解说', '智能解说（尚未开放 · 时间待定）'),
  GlossaryTerm('物料库', '封面、前贴、模板等投放物料'),
  GlossaryTerm(
    '自动化创作',
    '无人值守自动出片（尚未开放 · 时间待定；勿与可用能力并列过强）',
  ),
];

const kEntries = <EntrySpec>[
  EntrySpec(
    id: 'entry-cut-test',
    title: '测投 · 智能切片',
    meta: '场景 A · 小批量试效果 · /highlight-hub',
    intent: '测投·智能切片',
    lines: [
      RichLine('谁适合：', '手里有待测投剧集、先验证潜力的宣发/切片运营。'),
      RichLine('边界：', '偏 10–20 条试投切片，看完播/互动再决定是否扩量。'),
      RichLine('产出：', '可测投短切片样本包。'),
      RichLine('登录后：', '上传/选剧并启动「试投切片」任务。'),
    ],
    actions: [EntryAction.gate('登录后开剪')],
  ),
  EntrySpec(
    id: 'entry-cut-batch',
    title: '量产 · 智能切片',
    meta: '与测投边界：策略复用 · 批量任务 · 审核吞吐',
    intent: '量产·智能切片',
    lines: [
      RichLine('谁适合：', '测投策略已跑通、需要规模化产能的团队。'),
      RichLine('边界：', '复用已验证切点/策略，走批量任务与更高审核吞吐，而非再试 10–20 条。'),
      RichLine('产出：', '大批量可分发切片。'),
      RichLine('登录后：', '配置批量切片任务（工作台细节待二次审计）。'),
    ],
    actions: [EntryAction.gate('登录后开剪')],
  ),
  EntrySpec(
    id: 'pick-hit',
    title: '挑爆款 · 有效素材',
    meta: '场景 B · Path A 衔接 · 公开说明（写入门禁）',
    intent: '挑爆款·有效素材',
    lines: [
      RichLine('谁适合：', '已有一批测投切片或投放结果、要筛高潜素材的运营。'),
      RichLine(
        '依据什么挑：',
        '完播、互动等公开口径（数据环未接入时需结合站外投放结果或成片库下载后的独立分发数据）。',
      ),
      RichLine('产出：', '入选裂变池的有效切片清单。'),
      RichLine(
        '登录后：',
        '在成片库/任务结果中筛选并标记进入裂变（库内 UI 待二次审计，此处不臆造）。',
      ),
    ],
    actions: [
      EntryAction.link('下一步：裂变 Demo', 'fission-hub'),
      EntryAction.gate('登录后筛选'),
    ],
  ),
  EntrySpec(
    id: 'entry-remix',
    title: '智能裂变',
    meta: '场景 C · /fission-hub',
    intent: '智能裂变',
    lines: [
      RichLine('谁适合：', '已有有效切片、要多版本扩量的剪辑。'),
      RichLine('产出：', '旁白/字幕/BGM 等变体。'),
      RichLine('登录后：', '选中爆款进入裂变改剪。'),
    ],
    actions: [EntryAction.gate('登录后裂变')],
  ),
  EntrySpec(
    id: 'entry-storyline',
    title: '精品 · 故事线',
    meta: '场景 D · /#storyline-hub',
    intent: '精品·故事线',
    lines: [
      RichLine('谁适合：', '精品向编导。'),
      RichLine('产出：', '故事线重编成片。'),
      RichLine('登录后：', '进入故事线工序（细节待二次审计）。'),
    ],
    actions: [EntryAction.gate('登录后创作')],
  ),
  EntrySpec(
    id: 'entry-premium',
    title: '精品 · 高精度解说',
    meta: '场景 D',
    intent: '精品·高精度解说',
    lines: [
      RichLine('谁适合：', '解说编导。'),
      RichLine('产出：', '高精度解说轨成片。'),
      RichLine('登录后：', '启动解说合成任务。'),
    ],
    actions: [EntryAction.gate('登录后创作')],
  ),
  EntrySpec(
    id: 'entry-smart-commentary',
    title: '精品 · 智能解说',
    meta: '尚未开放',
    intent: '精品·智能解说',
    dim: true,
    soon: '敬请期待 · 时间待定',
    lines: [
      RichLine('', '与「高精度解说」区分；开放前不与可选项同等 CTA 权重。'),
    ],
    actions: [EntryAction.disabled('暂不可用')],
  ),
];

const kHighlightDemo = DemoSpec(
  id: 'highlight-hub',
  title: '高光切片操作演示',
  steps: ['1 选剧', '2 标切点', '3 出短片', '4 审核', '5 导出测投'],
  input: '整剧 / 多集成片源',
  output: '可测投短切片（高光点）',
  next: '登录后上传己片并开剪',
  buttonLabel: '用我的片子开剪',
  gateIntent: '高光切片 Demo 后开剪',
  panes: [
    StoryPane(
      label: '输入 · 整剧源',
      metaLeft: '样例 45:00',
      metaRight: '多集源',
      caption: '剧集成片时间线',
      mapLine: '对应你片子里：整部待测投剧的成片/多集文件。',
      segments: [TimelineSeg(left: 0.04, width: 0.92)],
      cuts: [TimelineCut(0.22, '切点A'), TimelineCut(0.58, '切点B')],
    ),
    StoryPane(
      label: '输出 · 测投短片',
      metaLeft: '样例 00:22',
      metaRight: '高光切片',
      caption: '15–45s 可投切片',
      mapLine: '对应你片子里：从剧集里抽出的可测投短切片（前后对比：长片→短高光）。',
      frameKind: 'out',
      segments: [TimelineSeg(left: 0.10, width: 0.80, kind: 'out')],
      cuts: [TimelineCut(0.10, '入点'), TimelineCut(0.90, '出点')],
    ),
  ],
);

const kFissionDemo = DemoSpec(
  id: 'fission-hub',
  title: '智能裂变（Remix）操作演示',
  steps: ['1 选有效片', '2 选变体维度', '3 改旁白/字幕/BGM', '4 出多版', '5 导出扩量'],
  input: '已确认有效的切片（非整剧）',
  output: '多版本改剪（旁白/字幕/BGM 等）',
  next: '登录后选中爆款进入裂变；故事线见 Path B / 精品 Demo',
  buttonLabel: '登录后裂变',
  gateIntent: '裂变 Demo 后开剪',
  panes: [
    StoryPane(
      label: '输入 · Remix',
      metaLeft: '样例 00:28',
      metaRight: '有效切片',
      caption: '爆款切片 v1',
      mapLine: '对应你片子里：测投验证过的那条短片（不是整剧，也不是故事线重编）。',
      frameKind: 'fission',
      segments: [TimelineSeg(left: 0.08, width: 0.84, kind: 'fis')],
    ),
    StoryPane(
      label: '输出 · 多版变体',
      metaLeft: '各约 00:28',
      metaRight: '×3 变体',
      caption: '多投放版本',
      mapLine: '对应你片子里：同一条有效片的多投放版本，用于扩量。',
      frameKind: 'fission',
      compare: ['旁白 A', '字幕 B', 'BGM C', '合成包'],
    ),
  ],
);

const kStorylineDemo = DemoSpec(
  id: 'storyline-hub',
  title: '精品 · 故事线（Craft）说明',
  steps: ['1 选素材', '2 排故事线', '3 定节点', '4 合成', '5 导出精品'],
  input: '多段切片 / 成片素材',
  output: '按故事线重编的精品向成片',
  next: '登录后进入故事线工序（工作台细节待二次审计）',
  buttonLabel: '登录后创作',
  gateIntent: '精品·故事线',
  panes: [
    StoryPane(
      label: '输入 · 故事线',
      metaLeft: '样例 多段',
      metaRight: '素材池',
      caption: '多段可选素材',
      mapLine: '对应你片子里：要按故事线重编的若干切片/成片段落（不是 Remix 变体）。',
      segments: [
        TimelineSeg(left: 0.06, width: 0.28),
        TimelineSeg(left: 0.38, width: 0.24, kind: 'out'),
        TimelineSeg(left: 0.66, width: 0.28, kind: 'fis'),
      ],
    ),
    StoryPane(
      label: '输出 · 故事线成片',
      metaLeft: '样例 02:40',
      metaRight: '节点成片',
      caption: '故事线重编精品成片',
      mapLine: '对应你片子里：按叙事节点重排后的精品向成片（Path B · Craft，非裂变）。',
      frameKind: 'out',
      segments: [TimelineSeg(left: 0.05, width: 0.90, kind: 'out')],
      cuts: [TimelineCut(0.30, '情节点1'), TimelineCut(0.62, '情节点2')],
    ),
  ],
);

const kPremiumDemo = DemoSpec(
  id: 'premium-hub',
  title: '高精度解说（Craft）演示',
  steps: ['1 选片段', '2 生成解说轨', '3 校词', '4 合成', '5 导出精品'],
  input: '选定片段或成片',
  output: '带高精度解说轨的精品成片',
  next: '登录后启动解说任务；故事线见精品·故事线入口',
  buttonLabel: '登录后创作',
  gateIntent: '解说 Demo 后创作',
  panes: [
    StoryPane(
      label: '输入 · Craft',
      metaLeft: '样例 03:10',
      metaRight: '选定片段',
      caption: '精品向片段',
      mapLine: '对应你片子里：要做解说向精品输出的那段成片（可与测投流水线先后衔接）。',
      frameKind: 'out',
      segments: [TimelineSeg(left: 0.06, width: 0.88, kind: 'out')],
      cuts: [TimelineCut(0.06, '选段')],
    ),
    StoryPane(
      label: '输出 · 解说轨成片',
      metaLeft: '样例 03:10',
      metaRight: '解说轨 ON',
      caption: '画面 + 高精度解说轨',
      mapLine: '对应你片子里：同一片段叠上解说轨后的精品成片（前后对比：无解说→有解说轨）。',
      frameKind: 'out',
      segments: [
        TimelineSeg(left: 0.06, width: 0.88, kind: 'out'),
        TimelineSeg(left: 0.06, width: 0.88, kind: 'voice'),
      ],
    ),
  ],
);

const kDemos = <DemoSpec>[
  kHighlightDemo,
  kFissionDemo,
  kStorylineDemo,
  kPremiumDemo,
];

const kLibraries = <LibSpec>[
  LibSpec(
    id: 'materials',
    icon: '📁',
    title: '素材库 · /materials',
    body: '剧集与源片入库、待审素材。登录后管理；公开面不展示库内 UI。',
    gateIntent: '素材库',
    buttonLabel: '登录后使用',
  ),
  LibSpec(
    id: 'outputs',
    icon: '🎬',
    title: '成片库 · /outputs',
    body: '可分发切片与成片；数据环未接入时从此下载后独立分发。',
    gateIntent: '成片库',
    buttonLabel: '登录后使用',
  ),
  LibSpec(
    id: 'drafts',
    icon: '📝',
    title: '创作草稿 · /drafts',
    body: '进行中的切片/裂变/精品草稿。细节待登录后二次审计。',
    gateIntent: '创作草稿',
    buttonLabel: '登录后使用',
  ),
  LibSpec(
    id: 'tasks',
    icon: '📋',
    title: '任务 · /tasks',
    body: '切片/裂变/解说等任务队列入口（公开仅占位说明）。',
    gateIntent: '任务',
    buttonLabel: '登录后使用',
  ),
  LibSpec(
    id: 'templates',
    icon: '🧩',
    title: '视频处理模板 · /templates',
    body: '合成规格、水印贴纸；裂变/精品合成前套用。',
    gateIntent: '视频处理模板',
    buttonLabel: '打开模板（需登录）',
  ),
  LibSpec(
    id: 'intros',
    icon: '🎥',
    title: 'AI 前贴 · /intros',
    body: '为成片生成吸引点击的前贴；可入库或合并进成片。',
    gateIntent: 'AI前贴',
    buttonLabel: '打开 AI 前贴（需登录）',
  ),
  LibSpec(
    id: 'covers',
    icon: '🖼️',
    title: 'AI 封面海报 · /covers',
    body: '基于片段生成多封面；可作视频头图或物料。',
    gateIntent: 'AI封面',
    buttonLabel: '打开封面（需登录）',
  ),
  LibSpec(
    id: 'automation',
    icon: '🤖',
    title: '自动化创作 · /automation',
    body: '无人值守自动出片。',
    warn: '敬请期待 · 时间待定',
    disabled: true,
    buttonLabel: '敬请期待',
  ),
];

const kContactTopics = <String>[
  '登录问题',
  '流程/术语不清楚',
  '客户端 / Web 环境',
  '商务合作',
  '其他',
];

const kNavItems = <(String, String)>[
  ('home', '首页'),
  ('get-started', '产品流程'),
  ('demos', '能力与 Demo'),
  ('glossary', '术语说明'),
  ('faq', '帮助/联系'),
];

const kMobileNavItems = <(String, String)>[
  ('get-started', '流程'),
  ('paths', '路径'),
  ('entries', '入口'),
  ('pick-hit', '挑爆款'),
  ('demos', 'Demo'),
  ('glossary', '术语'),
  ('libs', '库与工具'),
  ('faq', '帮助'),
];

const kEngineSlides = <(String, String)>[
  ('Cut', 'KinoFlux Cut · 智能切片引擎'),
  ('Remix', 'KinoFlux Remix · 裂变改剪引擎'),
  ('Craft', 'KinoFlux Craft · 精品创作引擎'),
];

const kRouteIndex =
    '/home · /get-started · /highlight-hub · /fission-hub · /premium-hub · '
    '/materials · /outputs · /tasks · /drafts · /covers · /templates · '
    '/intros · /automation · /faq · /profile';
