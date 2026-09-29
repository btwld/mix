import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'config.dart';
import 'src/fixes/use_dot_shorthand.dart';
import 'src/rules/base_style_after_variant.dart';
import 'src/rules/inline_token_definition.dart';
import 'src/rules/long_styler_chain.dart';
import 'src/rules/missing_create_constructor.dart';
import 'src/rules/token_reference_outside_mix.dart';
import 'src/rules/unnecessary_type_name.dart';
import 'src/rules/variants_without_base_style.dart';

export 'config.dart';

/// The `mix_lint` analyzer plugin.
///
/// Rules that catch bugs are registered as warnings, which are on by default.
/// Style rules are registered as lints, which you enable in
/// `analysis_options.yaml`.
///
/// Build this class in your own plugin package to pass a custom [config].
final class MixLintPlugin extends Plugin {
  /// Settings for the rules that take options.
  final MixLintConfig config;

  /// Creates the plugin with an optional [config].
  MixLintPlugin({this.config = const MixLintConfig()});

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
      ..registerLintRule(
        LongStylerChain(maxLength: config.maxStylerChainLength),
      )
      ..registerLintRule(UnnecessaryTypeName())
      ..registerLintRule(VariantsWithoutBaseStyle());

    registry.registerFixForRule(UnnecessaryTypeName.code, UseDotShorthand.new);
  }
}
