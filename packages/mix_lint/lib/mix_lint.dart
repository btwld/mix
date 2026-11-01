import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/fixes/use_dot_shorthand.dart';
import 'src/rules/base_style_after_variant.dart';
import 'src/rules/inline_token_definition.dart';
import 'src/rules/long_styler_chain.dart';
import 'src/rules/missing_create_constructor.dart';
import 'src/rules/token_reference_outside_mix.dart';
import 'src/rules/unnecessary_styler_constructor.dart';
import 'src/rules/unnecessary_type_name.dart';
import 'src/rules/variants_without_base_style.dart';

/// The `mix_lint` analyzer plugin.
final class MixLintPlugin extends Plugin {
  @override
  String get name => 'mix_lint';

  @override
  void register(PluginRegistry registry) {
    // Warnings: on by default.
    registry
      ..registerWarningRule(MissingCreateConstructor())
      ..registerWarningRule(TokenReferenceOutsideMix());

    // Lints: off until enabled in analysis_options.yaml.
    registry
      ..registerLintRule(BaseStyleAfterVariant())
      ..registerLintRule(InlineTokenDefinition())
      ..registerLintRule(LongStylerChain())
      ..registerLintRule(UnnecessaryStylerConstructor())
      ..registerLintRule(UnnecessaryTypeName())
      ..registerLintRule(VariantsWithoutBaseStyle());

    registry
      ..registerFixForRule(
        UnnecessaryStylerConstructor.code,
        UseDotShorthand.new,
      )
      ..registerFixForRule(UnnecessaryTypeName.code, UseDotShorthand.new);
  }
}
