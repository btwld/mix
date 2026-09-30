import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/inline_token_definition.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class InlineTokenDefinitionTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => InlineTokenDefinition();

  void test_token_in_styler_method_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler().color([!ColorToken('primary')!]());
''',
      messageContains: ['Styler chain'],
    );
  }

  void test_token_in_dot_shorthand_styler_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final BoxStyler s = .color([!ColorToken('primary')!]());
''');
  }

  void test_token_in_mix_scope_reports() async {
    await assertLints(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final w = MixScope(colors: {[!ColorToken('primary')!]: Colors.blue});
''',
      messageContains: ['MixScope'],
    );
  }

  void test_token_in_mix_scope_static_method_reports() async {
    await assertLints(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final w = MixScope.inherit(colors: {[!ColorToken('primary')!]: Colors.blue});
''',
      messageContains: ['MixScope'],
    );
  }

  void test_token_in_mix_scope_child_no_diagnostic() async {
    // The child is the widget tree below the scope, not a token definition.
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final $primary = ColorToken('primary');
final w = MixScope(
  colors: {$primary: Colors.blue},
  child: Container(color: ColorToken('accent')()),
);
''');
  }

  void test_token_defined_outside_styler_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final s = BoxStyler().color($primary());
''');
  }

  void test_token_defined_outside_scope_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
const $primary = ColorToken('primary');
final w = MixScope(colors: {$primary: Colors.blue});
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(InlineTokenDefinitionTest);
  });
}
