import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_avoid_defining_tokens_within_style.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../mix_stub.dart';

@reflectiveTest
class MixAvoidDefiningTokensWithinStyleTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixAvoidDefiningTokensWithinStyle();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_token_inside_styler_method_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().color(MyToken());
}
''',
      [lint(75, 9)],
    );
  }

  void test_token_outside_styler_chain_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  final s = BoxStyler().color(t);
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixAvoidDefiningTokensWithinStyleTest);
  });
}
