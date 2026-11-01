import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/base_style_after_variant.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class BaseStyleAfterVariantTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => BaseStyleAfterVariant();

  void test_base_style_after_variant_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler().onHovered(BoxStyler().width(1)).[!height!](8);
''',
      messageContains: ["'height'", "'onHovered'"],
    );
  }

  void test_base_style_after_several_variants_reports_once() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .onDark(BoxStyler().width(1))
    .onHovered(BoxStyler().width(1))
    .[!width!](10)
    .height(10);
''');
  }

  void test_base_style_after_animate_after_variant_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .onHovered(BoxStyler().width(1))
    .animate(Object())
    .[!height!](8);
''');
  }

  void test_parenthesized_chain_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = (BoxStyler().onHovered(BoxStyler().width(1))).[!height!](8);
''');
  }

  void test_on_constraints_on_grid_subtype_is_a_variant() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
class BrandGridStyler extends GridBoxStyler {}
final s = BrandGridStyler()
    .onConstraints(Object(), GridBoxStyler().gap(1))
    .[!gap!](2);
''');
  }

  void test_base_style_after_constructor_variants_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler(variants: [Object()]).[!width!](1);
''',
      messageContains: ["'width'", "'variants'"],
    );
  }

  void test_base_style_after_constraint_branches_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = GridBoxStyler(constraintBranches: [Object()]).[!gap!](8);
''');
  }

  void test_base_style_after_empty_constructor_variants_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler(variants: const []).width(1);
''');
  }

  void test_grid_on_constraints_is_a_variant() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final s = GridBoxStyler().onConstraints(Object(), GridBoxStyler()).[!gap!](8);
''');
  }

  void test_base_style_after_variant_factory_root_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final a = GridBoxStyler.onConstraints(Object(), GridBoxStyler()).[!gap!](8);
final GridBoxStyler b = .onConstraints(Object(), GridBoxStyler()).[!gap!](8);
''',
      messageContains: ["'gap'", "'onConstraints'"],
    );
  }

  void test_variants_last_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).height(8).onHovered(BoxStyler().width(2));
''');
  }

  void test_animate_after_variant_no_diagnostic() async {
    // The canonical implicit-animation pattern.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onHovered(BoxStyler().width(2))
    .onPressed(BoxStyler().width(3))
    .animate(Object());
''');
  }

  void test_modifier_after_variant_no_diagnostic() async {
    // `modifier` is the generated alias of `wrap`.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onHovered(BoxStyler().width(2))
    .modifier(Object())
    .phaseAnimation(Object());
''');
  }

  void test_structural_calls_after_variant_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onDark(BoxStyler().width(2))
    .wrap(Object())
    .keyframeAnimation(Object())
    .merge(BoxStyler())
    .applyVariants([]);
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(BaseStyleAfterVariantTest);
  });
}
