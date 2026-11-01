import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/missing_create_constructor.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class MissingCreateConstructorTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => MissingCreateConstructor();

  // Reports.

  void test_mixable_without_create_reports() async {
    await assertLints(
      r'''
import 'package:mix_annotations/mix_annotations.dart';
@Mixable()
class [!ShadowMix!] {}
''',
      messageContains: ["'ShadowMix'", "'@Mixable'"],
    );
  }

  void test_mixable_styler_without_create_reports() async {
    await assertLints(
      r'''
import 'package:mix_annotations/mix_annotations.dart';
@MixableStyler()
class [!CardStyler!] {}
''',
      messageContains: ["'@MixableStyler'"],
    );
  }

  void test_const_annotation_without_create_reports() async {
    await assertLints(r'''
import 'package:mix_annotations/mix_annotations.dart';
@mixable
class [!ShadowMix!] {}
''');
  }

  // No diagnostics.

  void test_with_create_constructor_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix_annotations/mix_annotations.dart';
@Mixable()
class ShadowMix {
  const ShadowMix.create();
}
''');
  }

  void test_with_create_factory_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix_annotations/mix_annotations.dart';
@MixableStyler()
class CardStyler {
  factory CardStyler.create() => const CardStyler._();
  const CardStyler._();
}
''');
  }

  void test_merge_generation_skipped_no_diagnostic() async {
    // Without a generated merge(), nothing calls `.create`.
    await assertNoDiagnostics(r'''
import 'package:mix_annotations/mix_annotations.dart';
@Mixable(methods: GeneratedMixMethods.skipMerge)
class ShadowMix {}
''');
  }

  void test_other_annotation_no_diagnostic() async {
    await assertNoDiagnostics(r'''
@Deprecated('x')
class ShadowMix {}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingCreateConstructorTest);
  });
}
