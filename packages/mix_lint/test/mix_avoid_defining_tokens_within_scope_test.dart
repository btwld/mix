import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_avoid_defining_tokens_within_scope.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixAvoidDefiningTokensWithinScopeTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixAvoidDefiningTokensWithinScope();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_token_inside_scope_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  MixScope({MyToken(): 1});
}
''',
      [lint(57, 9)],
    );
  }

  void test_token_outside_scope_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final t = MyToken();
  MixScope({t: 1});
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixAvoidDefiningTokensWithinScopeTest);
  });
}
