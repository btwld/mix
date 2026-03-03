import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_avoid_empty_variants.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixAvoidEmptyVariantsTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixAvoidEmptyVariants();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_only_variants_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().onHovered(BoxStyler().color(0)).onDark(BoxStyler().color(0));
}
''',
      [lint(57, 11)],
    );
  }

  void test_base_then_variants_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().color(0).onHovered(BoxStyler().color(0));
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixAvoidEmptyVariantsTest);
  });
}
