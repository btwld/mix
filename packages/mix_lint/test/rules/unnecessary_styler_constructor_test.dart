import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/unnecessary_styler_constructor.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class UnnecessaryStylerConstructorTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => UnnecessaryStylerConstructor();

  // Reports.

  void test_constructor_in_variant_reports() async {
    await assertLints(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onHovered([!BoxStyler().color!](Colors.blue).width(2));
''',
      messageContains: ["'.color'"],
    );
  }

  void test_new_in_typed_initializer_reports() async {
    await assertLints(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final BoxStyler s = [!.new().color!](Colors.blue);
''');
  }

  // No diagnostics.

  void test_top_level_constructor_no_diagnostic() async {
    // Top-level declarations start with the Styler constructor.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().color(Colors.blue);
''');
  }

  void test_constructor_in_widget_argument_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final w = Box(style: BoxStyler().color(Colors.blue));
''');
  }

  void test_first_call_without_factory_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered(BoxStyler().width(2));
final BoxStyler t = .new().width(1);
''');
  }

  void test_factory_rejects_arguments_no_diagnostic() async {
    // The factory takes a non-nullable Color; the setter also accepts null.
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered(BoxStyler().color(null));
''');
  }

  void test_constructor_with_arguments_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler()
    .width(1)
    .onHovered(BoxStyler(color: Colors.blue).width(2));
''');
  }

  void test_new_without_chain_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final BoxStyler s = .new();
''');
  }

  void test_generic_method_parameter_no_diagnostic() async {
    // T is inferred from the argument, so `.color(...)` would have no
    // context type.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
extension on BoxStyler {
  BoxStyler pick<T extends BoxStyler>(T style) => this;
}
final s = BoxStyler().width(1).pick(BoxStyler().color(Colors.blue));
''');
  }

  void test_language_before_dot_shorthands_no_diagnostic() async {
    await assertNoDiagnostics(r'''
// @dart=3.9
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered(BoxStyler().color(Colors.blue));
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(UnnecessaryStylerConstructorTest);
  });
}
