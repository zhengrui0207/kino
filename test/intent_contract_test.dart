import 'package:flutter_test/flutter_test.dart';
import 'package:kino_mash_app/src/intent_contract.dart';
import 'package:kino_mash_app/src/public_content.dart';

void main() {
  test('INTENT_HASH matches the public prototype contract', () {
    expect(IntentContract.hashByIntent, {
      '测投·智能切片': '#entries',
      '量产·智能切片': '#entries',
      '挑爆款·有效素材': '#pick-hit',
      '智能裂变': '#fission-hub',
      '精品·故事线': '#storyline-hub',
      '精品·高精度解说': '#premium-hub',
      '精品·智能解说': '#entries',
      '高光切片 Demo 后开剪': '#highlight-hub',
      '裂变 Demo 后开剪': '#fission-hub',
      '解说 Demo 后创作': '#premium-hub',
      '素材库': '#materials',
      '成片库': '#outputs',
      '创作草稿': '#drafts',
      '任务': '#tasks',
      '视频处理模板': '#templates',
      'AI前贴': '#intros',
      'AI封面': '#covers',
      '登录后开剪': '#get-started',
      '立即登录': '#get-started',
      '需登录操作': '#get-started',
    });
  });

  test('unknown intent falls back to the production flow', () {
    expect(IntentContract.anchorFor('不存在的入口'), '#get-started');
    expect(IntentContract.sectionIdFor('精品·故事线'), 'storyline-hub');
    expect(IntentContract.sectionIdFor('精品·高精度解说'), 'premium-hub');
  });

  test('storyline and premium hubs stay on different anchors', () {
    expect(
      IntentContract.anchorFor('精品·故事线'),
      isNot(IntentContract.anchorFor('精品·高精度解说')),
    );
    expect(IntentContract.anchorFor('智能裂变'), '#fission-hub');
    expect(IntentContract.anchorFor('裂变 Demo 后开剪'), '#fission-hub');
    expect(IntentContract.anchorFor('解说 Demo 后创作'), '#premium-hub');
  });

  test('gated public intents all resolve', () {
    for (final entry in kEntries) {
      expect(
        IntentContract.hashByIntent.containsKey(entry.intent),
        isTrue,
        reason: entry.intent,
      );
    }
    for (final demo in kDemos) {
      expect(
        IntentContract.hashByIntent.containsKey(demo.gateIntent),
        isTrue,
        reason: demo.gateIntent,
      );
    }
    for (final lib in kLibraries) {
      final intent = lib.gateIntent;
      if (intent == null) {
        expect(lib.disabled, isTrue);
        continue;
      }
      expect(IntentContract.hashByIntent.containsKey(intent), isTrue);
    }
  });

  test('fission procedure does not include storyline steps', () {
    expect(kFissionDemo.id, 'fission-hub');
    expect(kFissionDemo.procedureMentionsStoryline, isFalse);
    expect(kFissionDemo.steps.join(' '), isNot(contains('故事线')));
    expect(kStorylineDemo.id, 'storyline-hub');
    expect(kStorylineDemo.procedureMentionsStoryline, isTrue);
    expect(kPremiumDemo.id, 'premium-hub');
    expect(kPremiumDemo.steps.join(' '), isNot(contains('故事线')));
    expect(kPremiumDemo.title, contains('高精度解说'));
    expect(kStorylineDemo.title, contains('故事线'));
  });

  test('glossary covers the PRD vernacular table', () {
    final terms = {for (final term in kGlossary) term.term: term.definition};
    expect(terms['Cut'], '智能切片（按剧情/高光切短视频）');
    expect(terms['Remix'], '裂变改剪（多版本变体扩量）');
    expect(terms['Craft'], '精品重构（故事线 / 解说向）');
    expect(terms['测投·智能切片'], '先切一版去投放试效果');
    expect(terms['量产·智能切片'], '批量出切片');
    expect(terms['智能裂变'], '基于有效切片做多版改剪');
    expect(terms['上传审库'], '上传成片/剧集，进入待审素材库');
    expect(terms['精品·智能解说'], contains('时间待定'));
    expect(terms['挑爆款 / 有效素材'], contains('裂变池'));
    expect(terms['自动化创作'], contains('尚未开放'));
    expect(kFlowSteps.map((step) => step.label), contains('挑爆款'));
    expect(
      kFlowSteps.singleWhere((step) => step.muted).label,
      '数据反馈（尚未接入）',
    );
  });
}
