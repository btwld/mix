import 'package:analysis_server_plugin/registry.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/error/error.dart';
import 'package:mix_lint/main.dart' as entry_point;
import 'package:mix_lint/mix_lint.dart';
import 'package:mix_lint/src/rules/long_styler_chain.dart';
import 'package:mix_lint/src/rules/unnecessary_type_name.dart';
import 'package:test/test.dart';

void main() {
  _RecordingRegistry register([MixLintConfig config = const MixLintConfig()]) {
    final registry = _RecordingRegistry();
    MixLintPlugin(config: config).register(registry);

    return registry;
  }

  test('lib/main.dart exposes the plugin that the analysis server loads', () {
    expect(entry_point.plugin, isA<MixLintPlugin>());
    expect(entry_point.plugin.name, 'mix_lint');
  });

  test('registers bug rules as warnings and style rules as lints', () {
    final registry = register();

    expect(registry.warnings.map((rule) => rule.name), [
      'missing_create_constructor',
      'token_reference_outside_mix',
    ]);
    expect(registry.lints.map((rule) => rule.name), [
      'base_style_after_variant',
      'inline_token_definition',
      'long_styler_chain',
      'unnecessary_type_name',
      'variants_without_base_style',
    ]);
    expect(registry.fixedCodes, [UnnecessaryTypeName.code]);
  });

  test('warning codes have warning severity; lint codes have info', () {
    final registry = register();

    for (final rule in registry.warnings) {
      for (final code in rule.diagnosticCodes) {
        expect(code.severity, DiagnosticSeverity.WARNING, reason: rule.name);
      }
    }
    for (final rule in registry.lints) {
      for (final code in rule.diagnosticCodes) {
        expect(code.severity, DiagnosticSeverity.INFO, reason: rule.name);
      }
    }
  });

  test('rules follow the Dart naming and description conventions', () {
    final registry = register();

    for (final rule in [...registry.warnings, ...registry.lints]) {
      // Plugin rules are already namespaced as `mix_lint/<rule>`.
      expect(rule.name, isNot(startsWith('mix_')));
      // Name the problem, not the advice.
      expect(rule.name, isNot(matches(r'^(avoid|prefer|always)_')));
      expect(rule.description, matches(r"^(Do|Don't|Prefer|Avoid|Consider) "));
      for (final code in rule.diagnosticCodes) {
        expect(code.lowerCaseName, rule.name);
        expect(code.correctionMessage, startsWith('Try '));
      }
    }
  });

  test('passes the config to long_styler_chain', () {
    final registry = register(const MixLintConfig(maxStylerChainLength: 3));

    expect(registry.lints.whereType<LongStylerChain>().single.maxLength, 3);
  });
}

class _RecordingRegistry implements PluginRegistry {
  final warnings = <AbstractAnalysisRule>[];
  final lints = <AbstractAnalysisRule>[];
  final fixedCodes = <DiagnosticCode>[];

  @override
  void registerWarningRule(AbstractAnalysisRule rule) => warnings.add(rule);

  @override
  void registerLintRule(AbstractAnalysisRule rule) => lints.add(rule);

  @override
  void registerFixForRule(DiagnosticCode code, Object generator) =>
      fixedCodes.add(code);

  @override
  Object? noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
