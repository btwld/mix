import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/token_reference_outside_mix.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class TokenReferenceOutsideMixTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => TokenReferenceOutsideMix();

  // Reports.

  void test_call_into_flutter_widget_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final w = Container(color: [!$primary()!]);
''');
  }

  void test_explicit_call_into_flutter_widget_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final w = Container(color: [!$primary.call()!]);
''');
  }

  void test_mix_method_into_non_mix_function_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
const $body = TextStyleToken('body');
void f() {
  print([!$body.mix()!]);
}
''');
  }

  void test_call_into_top_level_function_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
void f() {
  print([!$primary()!]);
}
''');
  }

  void test_call_inside_collection_into_non_mix_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
void f() {
  print([[!$primary()!]]);
}
''');
  }

  // No diagnostics.

  void test_call_into_styler_method_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final s = BoxStyler().color($primary()).color($primary.call());
''');
  }

  void test_call_into_mix_static_method_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final s = BoxStyler().shadow(BoxShadowMix(color: $primary()));
''');
  }

  void test_call_into_plain_mix_class_no_diagnostic() async {
    // GridTrack is not a Mix value, but Mix declares it and resolves refs.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $gap = SpaceToken('gap');
final t = GridTrack.fixed($gap());
''');
  }

  void test_call_into_local_helper_no_diagnostic() async {
    // A helper in the analyzed package may forward the value into Mix.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
BoxStyler filled({required Color fill}) => BoxStyler().color(fill);
final s = filled(fill: $primary());
''');
  }

  void test_closure_return_value_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $body = TextStyleToken('body');
final refs = List.generate(3, (i) => $body.mix());
''');
  }

  void test_resolve_is_not_a_reference_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
Widget build(BuildContext context) =>
    Container(color: $primary.resolve(context));
''');
  }

  void test_call_assigned_to_variable_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
void f() {
  final color = $primary();
  print(color);
}
''');
  }

  void test_call_in_return_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
Color f() {
  return $primary();
}
''');
  }

  void test_call_into_dynamic_receiver_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
void f(dynamic d) {
  d.foo($primary());
}
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(TokenReferenceOutsideMixTest);
  });
}
