import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/fixes/mix_prefer_dot_shorthands_fix.dart';
import 'package:mix_lint/src/rules/mix_prefer_dot_shorthands.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/lint_fix_test_helper.dart';
import '../mix_stub.dart';

@reflectiveTest
class MixPreferDotShorthandsFixTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixPreferDotShorthands();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
    registeredFixGenerators.registerFixForLint(
      MixPreferDotShorthands.code,
      MixPreferDotShorthandsFix.new,
    );
  }

  void test_fix_producer_has_expected_fix_kind() {
    final producer = MixPreferDotShorthandsFix(
      context: StubCorrectionProducerContext.instance,
    );
    expect(producer.fixKind.id, 'mix_prefer_dot_shorthands.useDotShorthand');
    expect(producer.fixKind.message, 'Use dot shorthand');
    expect(producer.applicability, CorrectionApplicability.singleLocation);
  }

  void test_quick_fix_replaces_static_method_with_dot_shorthand() async {
    const content = r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().padding(EdgeInsetsGeometryMix.all(10));
}
''';
    await assertDiagnostics(content, [lint(77, 29)]);

    final newContent = await applyQuickFixForResult(
      result,
      MixPreferDotShorthands.code,
      selectFix: (f) => f.change.message.contains('dot shorthand'),
    );

    expect(newContent, contains('.all(10)'));
    expect(newContent, isNot(contains('EdgeInsetsGeometryMix.all(10)')));
  }

  void test_quick_fix_replaces_static_property_with_dot_shorthand() async {
    const content = r'''
import 'package:mix/mix.dart';
void main() {
  final s = TextStyler().fontWeight(FontWeight.w600);
}
''';
    await assertDiagnostics(content, [lint(81, 15)]);

    final newContent = await applyQuickFixForResult(
      result,
      MixPreferDotShorthands.code,
      selectFix: (f) => f.change.message.contains('dot shorthand'),
    );

    expect(newContent, contains('.w600'));
    expect(newContent, isNot(contains('FontWeight.w600')));
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixPreferDotShorthandsFixTest);
  });
}
