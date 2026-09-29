import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:mix_lint/src/rules/long_styler_chain.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class LongStylerChainTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => LongStylerChain();

  void test_over_default_limit_reports() async {
    // The default limit is 15.
    final chain = List.generate(16, (i) => '.width($i)').join();
    await assertLints(
      '''
import 'package:mix/mix.dart';
final s = [!BoxStyler()!]$chain;
''',
      messageContains: ['16 calls', 'limit of 15'],
    );
  }

  void test_at_default_limit_no_diagnostic() async {
    final chain = List.generate(15, (i) => '.width($i)').join();
    await assertNoDiagnostics('''
import 'package:mix/mix.dart';
final s = BoxStyler()$chain;
''');
  }
}

@reflectiveTest
class LongStylerChainConfiguredTest extends MixRuleTest {
  @override
  AbstractAnalysisRule createRule() => LongStylerChain(maxLength: 2);

  void test_over_configured_limit_reports() async {
    await assertLints(
      r'''
import 'package:mix/mix.dart';
final s = [!BoxStyler()!].width(1).height(2).width(3);
''',
      messageContains: ['limit of 2'],
    );
  }

  void test_dot_shorthand_root_reports() async {
    await assertLints(r'''
import 'package:mix/mix.dart';
final BoxStyler s = [!.new()!].width(1).height(2).width(3);
''');
  }

  void test_at_configured_limit_no_diagnostic() async {
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).height(2);
''');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(LongStylerChainTest);
    defineReflectiveTests(LongStylerChainConfiguredTest);
  });
}
