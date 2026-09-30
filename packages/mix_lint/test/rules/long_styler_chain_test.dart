import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer_testing/utilities/utilities.dart';
import 'package:mix_lint/src/rules/long_styler_chain.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../helpers/rule_test_base.dart';

@reflectiveTest
class LongStylerChainTest extends MixRuleTest {
  // Three calls: over a limit of 2.
  static const overTwo = r'''
import 'package:mix/mix.dart';
final s = [!BoxStyler()!].width(1).height(2).width(3);
''';

  @override
  AbstractAnalysisRule createRule() => LongStylerChain();

  /// Rewrites the test package's `analysis_options.yaml` with the rule
  /// enabled, the given [includes], and [section] appended.
  void configure(String section, {List<String> includes = const []}) {
    newAnalysisOptionsYamlFile(
      testPackageRootPath,
      '${analysisOptionsContent(includes: includes, rules: [rule.name])}\n'
      '$section',
    );
  }

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

  void test_dot_shorthand_root_reports() async {
    final chain = List.generate(16, (i) => '.width($i)').join();
    await assertLints('''
import 'package:mix/mix.dart';
final BoxStyler s = [!.new()!]$chain;
''');
  }

  // Options.

  void test_configured_max_calls_reports() async {
    configure('''
mix_lint:
  long_styler_chain:
    max_calls: 2
''');
    await assertLints(overTwo, messageContains: ['3 calls', 'limit of 2']);
  }

  void test_at_configured_max_calls_no_diagnostic() async {
    configure('''
mix_lint:
  long_styler_chain:
    max_calls: 2
''');
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).height(2);
''');
  }

  void test_missing_section_uses_default() async {
    configure('''
mix_lint:
  other_rule:
    max_calls: 2
''');
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).height(2).width(3);
''');
  }

  void test_invalid_max_calls_uses_default() async {
    configure('''
mix_lint:
  long_styler_chain:
    max_calls: none
''');
    await assertNoDiagnostics(r'''
import 'package:mix/mix.dart';
final s = BoxStyler().width(1).height(2).width(3);
''');
  }

  void test_max_calls_from_relative_include() async {
    newFile('$testPackageRootPath/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 2
''');
    configure('', includes: ['shared.yaml']);
    await assertLints(overTwo, messageContains: ['limit of 2']);
  }

  void test_max_calls_from_package_include() async {
    newPackage('shared_options').addFile('lib/options.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 2
''');
    // setUp wrote the package config; write it again with the new package.
    writeTestPackageConfig2();
    configure('', includes: ['package:shared_options/options.yaml']);
    await assertLints(overTwo, messageContains: ['limit of 2']);
  }

  void test_local_value_overrides_include() async {
    newFile('$testPackageRootPath/shared.yaml', '''
mix_lint:
  long_styler_chain:
    max_calls: 20
''');
    configure(
      '''
mix_lint:
  long_styler_chain:
    max_calls: 2
''',
      includes: ['shared.yaml'],
    );
    await assertLints(overTwo, messageContains: ['limit of 2']);
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(LongStylerChainTest);
  });
}
