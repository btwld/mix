import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_mixable_styler_has_create.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixMixableStylerHasCreateTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixMixableStylerHasCreate();
    newPackage(
      'mix_annotations',
    ).addFile('lib/mix_annotations.dart', mixAnnotationsStubLibContent);
    super.setUp();
  }

  void test_mixable_styler_without_create_reports() async {
    await assertDiagnostics(
      r'''
import 'package:mix_annotations/mix_annotations.dart';
@MixableStyler()
class MyStyler {}
''',
      [lint(78, 8)],
    );
  }

  void test_mixable_styler_with_create_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix_annotations/mix_annotations.dart';
@MixableStyler()
class MyStyler {
  const MyStyler.create();
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixMixableStylerHasCreateTest);
  });
}
