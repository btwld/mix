import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_max_number_of_attributes_per_style.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixMaxNumberOfAttributesPerStyleTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixMaxNumberOfAttributesPerStyle();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_within_limit_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().color(0).paddingAll(1).paddingAll(2).paddingAll(3);
}
''');
  }

  void test_over_default_limit_reports() async {
    // Default max is 15. Build a chain with 16 calls.
    final chain = List.generate(16, (i) => '.paddingAll($i)').join();
    await assertDiagnostics(
      '''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler()$chain;
}
''',
      [lint(57, 11)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixMaxNumberOfAttributesPerStyleTest);
  });
}
