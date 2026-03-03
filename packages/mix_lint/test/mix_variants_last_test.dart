import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_variants_last.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixVariantsLastTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixVariantsLast();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_base_after_variant_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().onHovered(BoxStyler().color(0)).paddingAll(8);
}
''',
      [lint(101, 10)],
    );
  }

  void test_variants_last_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().color(0).paddingAll(8).onHovered(BoxStyler().color(0));
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixVariantsLastTest);
  });
}
