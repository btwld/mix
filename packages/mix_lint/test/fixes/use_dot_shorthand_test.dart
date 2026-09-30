import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/fixes/use_dot_shorthand.dart';
import 'package:mix_lint/src/rules/unnecessary_styler_constructor.dart';
import 'package:mix_lint/src/rules/unnecessary_type_name.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';
import '../helpers/quick_fix.dart';

@reflectiveTest
class UseDotShorthandTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => UnnecessaryTypeName();

  void test_fix_kind() {
    final producer = UseDotShorthand(
      context: StubCorrectionProducerContext.instance,
    );
    expect(producer.fixKind.id, 'mix_lint.fix.useDotShorthand');
    expect(producer.fixKind.message, 'Use dot shorthand');
    expect(producer.multiFixKind.id, 'mix_lint.fix.useDotShorthand.multi');
    expect(producer.applicability, CorrectionApplicability.acrossSingleFile);
  }

  void test_replaces_static_method() async {
    await _assertFix(
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler().padding([!EdgeInsetsGeometryMix.all(10)!]);
''',
      r'''
import 'package:mix/mix.dart';
final s = BoxStyler().padding(.all(10));
''',
    );
  }

  void test_replaces_static_field() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight([!FontWeight.w600!]);
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight(.w600);
''',
    );
  }

  void test_replaces_named_constructor() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().shadow([!BoxShadowMix.color(Colors.blue)!]);
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().shadow(.color(Colors.blue));
''',
    );
  }

  void test_replaces_enum_in_nested_mix_call() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().onNot(.widgetState([!WidgetState.hovered!]), BoxStyler());
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().onNot(.widgetState(.hovered), BoxStyler());
''',
    );
  }

  void test_replaces_named_argument() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().border(BorderSideMix(style: [!BorderStyle.solid!]));
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().border(BorderSideMix(style: .solid));
''',
    );
  }

  void test_replaces_import_prefix_and_type_name() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart' as ui;
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight([!ui.FontWeight.w600!]);
''',
      r'''
import 'package:flutter/widgets.dart' as ui;
import 'package:mix/mix.dart';
final s = TextStyler().fontWeight(.w600);
''',
    );
  }

  Future<void> _assertFix(String markedCode, String expected) async {
    await assertLints(markedCode);

    final fixed = await applyFix(
      result,
      UnnecessaryTypeName.code,
      UseDotShorthand.new,
    );

    expect(fixed, expected);
  }
}

@reflectiveTest
class UseDotShorthandForStylerConstructorTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => UnnecessaryStylerConstructor();

  void test_replaces_nested_constructor_with_factory() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered([!BoxStyler().color!](Colors.blue));
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).onHovered(.color(Colors.blue));
''',
    );
  }

  void test_replaces_new_with_factory() async {
    await _assertFix(
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final BoxStyler s = [!.new().color!](Colors.blue).width(2);
''',
      r'''
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
final BoxStyler s = .color(Colors.blue).width(2);
''',
    );
  }

  Future<void> _assertFix(String markedCode, String expected) async {
    await assertLints(markedCode);

    final fixed = await applyFix(
      result,
      UnnecessaryStylerConstructor.code,
      UseDotShorthand.new,
    );

    expect(fixed, expected);
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(UseDotShorthandTest);
    defineReflectiveTests(UseDotShorthandForStylerConstructorTest);
  });
}
