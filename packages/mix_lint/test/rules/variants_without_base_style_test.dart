import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/variants_without_base_style.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class VariantsWithoutBaseStyleTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => VariantsWithoutBaseStyle();

  void test_only_variants_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = [!BoxStyler()!]
    .onHovered(BoxStyler().width(1))
    .onDark(BoxStyler().width(2));
''');
  }

  void test_variants_and_animate_without_base_style_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = [!BoxStyler()!].onHovered(BoxStyler().width(1)).animate(Object());
''');
  }

  void test_base_style_then_variants_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(10).onDark(BoxStyler().width(2));
''');
  }

  void test_on_builder_alone_no_diagnostic() async {
    // onBuilder builds the whole style from context.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().onBuilder((context) => BoxStyler().width(1));
''');
  }

  void test_nested_variant_style_no_diagnostic() async {
    // The inner Styler only applies when dark mode is on.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onDark(BoxStyler().onHovered(BoxStyler().width(2)));
''');
  }

  void test_merged_fragment_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).merge(BoxStyler().onHovered(BoxStyler()));
''');
  }

  void test_empty_styler_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler();
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(VariantsWithoutBaseStyleTest);
  });
}
