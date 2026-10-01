import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/unnecessary_type_name.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class UnnecessaryTypeNameTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => UnnecessaryTypeName();

  // Reports.

  void test_static_method_of_parameter_type_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler().padding([!EdgeInsetsGeometryMix.all(10)!]);
''',
      messageContains: ["'EdgeInsetsGeometryMix'"],
    );
  }

  void test_static_field_of_parameter_type_reports() async {
    await assertLints(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight([!FontWeight.w600!]);
''',
      messageContains: ["'FontWeight'"],
    );
  }

  void test_static_field_with_import_prefix_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart' as ui;
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight([!ui.FontWeight.w600!]);
''');
  }

  void test_named_constructor_of_parameter_type_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().shadow([!BoxShadowMix.color(Colors.blue)!]);
''');
  }

  void test_argument_of_styler_factory_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final a = TextStyler.fontWeight([!FontWeight.w600!]);
final TextStyler b = .fontWeight([!FontWeight.w600!]);
final c = TextStyler().onHovered(.fontWeight([!FontWeight.w600!]));
''');
  }

  void test_argument_of_mix_call_inside_styler_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onNot(.widgetState([!WidgetState.hovered!]), BoxStyler().width(2))
    .border(BorderSideMix(style: [!BorderStyle.solid!]));
''');
  }

  // No diagnostics.

  void test_dot_shorthand_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().padding(.all(10));
''');
  }

  void test_static_of_other_class_no_diagnostic() async {
    // Colors.blue is a Color, and Color has no static `blue`.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().color(Colors.blue);
''');
  }

  void test_named_constructor_of_subtype_no_diagnostic() async {
    // `.only(...)` would resolve on EdgeInsetsGeometryMix, not on the subtype.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler()
    .padding(EdgeInsetsDirectionalMix.only(start: 8))
    .padding(EdgeInsetsMix.all(8));
''');
  }

  void test_instance_method_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const brand = Colors.blue;
const base = EdgeInsetsMix(left: 1);
final s = BoxStyler()
    .color(brand.withValues(alpha: .5))
    .padding(base.horizontal(8));
''');
  }

  void test_unnamed_constructor_no_diagnostic() async {
    // Mix style uses BoxShadowMix(...) for nullable inputs, not `.new(...)`.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().shadow(BoxShadowMix());
''');
  }

  void test_mix_call_outside_styler_no_diagnostic() async {
    // Only Styler expressions are checked, not other Mix code.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final v = ContextVariant.widgetState(WidgetState.pressed);
final b = BorderSideMix(style: BorderStyle.solid);
''');
  }

  void test_argument_of_flutter_api_no_diagnostic() async {
    // Only Mix APIs are checked.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
final r = Row(mainAxisAlignment: MainAxisAlignment.center);
''');
  }

  void test_nested_styler_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered(BoxStyler().width(2));
''');
  }

  void test_explicit_type_arguments_no_diagnostic() async {
    // `.linear()` would drop the explicit type argument.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().gradient(GradientMix<Object>.linear());
''');
  }

  void test_generic_method_parameter_no_diagnostic() async {
    // T is inferred from the argument, so `.w600` would have no context type.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
extension on BoxStyler {
  BoxStyler tagged<T>(T value) => this;
}
final s = BoxStyler().tagged(FontWeight.w600);
''');
  }

  void test_language_before_dot_shorthands_no_diagnostic() async {
    await assertNoDiagnostics(r'''
// @dart=3.9
import 'package:mix/mix.dart';
final s = BoxStyler().padding(EdgeInsetsGeometryMix.all(10));
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(UnnecessaryTypeNameTest);
  });
}
