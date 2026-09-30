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

  void test_dot_shorthand_root_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final BoxStyler s = [!.new()!].onHovered(BoxStyler().width(1));
''');
  }

  void test_structural_or_variant_factory_root_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final a = [!BoxStyler.animate(Object())!].onHovered(BoxStyler().width(1));
final BoxStyler b = [!.animate(Object())!].onHovered(BoxStyler().width(1));
final c = [!GridBoxStyler.onConstraints(Object(), GridBoxStyler().gap(1))!]
    .onHovered(GridBoxStyler().gap(2));
''');
  }

  void test_base_style_from_factory_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final a = BoxStyler.color(Colors.blue).onHovered(BoxStyler().width(1));
final b = BoxStyler(color: Colors.blue).onHovered(BoxStyler().width(1));
final BoxStyler c = .color(Colors.blue).onHovered(BoxStyler().width(1));
''');
  }

  void test_base_style_from_merge_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final base = BoxStyler().width(1);
final s = BoxStyler().merge(base).onHovered(BoxStyler().width(2));
''');
  }

  void test_style_returned_from_on_builder_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onBuilder((context) => BoxStyler().onDark(BoxStyler().width(2)));
''');
  }

  void test_style_in_variant_style_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).variants([
  VariantStyle(Object(), BoxStyler().onHovered(BoxStyler().width(2))),
]);
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
