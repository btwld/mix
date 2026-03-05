import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/mix_prefer_dot_shorthands.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'src/mix_stub.dart';

@reflectiveTest
class MixPreferDotShorthandsTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MixPreferDotShorthands();
    newPackage('mix').addFile('lib/mix.dart', mixStubLibContent);
    super.setUp();
  }

  void test_static_method_in_styler_argument_reports() async {
    // EdgeInsetsGeometryMix.all(10) -> .all(10) when in .padding(...)
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().padding(EdgeInsetsGeometryMix.all(10));
}
''',
      [lint(77, 29)],
    );
  }

  void test_static_property_in_styler_argument_reports() async {
    // FontWeight.w600 -> .w600 when in .fontWeight(...)
    await assertDiagnostics(
      r'''
import 'package:mix/mix.dart';
void main() {
  final s = TextStyler().fontWeight(FontWeight.w600);
}
''',
      [lint(81, 15)],
    );
  }

  void test_dot_shorthand_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().padding(.all(10));
}
''');
  }

  void test_static_from_other_class_no_diagnostic() async {
    // Rule only diagnoses when the static is from the same type as the prefix.
    // When the prefix type is not the class that declares the static, no diagnostic.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
void main() {
  final s = BoxStyler().height(Constants.foo);
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MixPreferDotShorthandsTest);
  });
}
