import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/rules/mix_avoid_defining_tokens_within_scope.dart';
import 'src/rules/mix_avoid_defining_tokens_within_style.dart';
import 'src/rules/mix_avoid_empty_variants.dart';
import 'src/rules/mix_max_number_of_attributes_per_style.dart';
import 'src/rules/mix_mixable_styler_has_create.dart';
import 'src/rules/mix_prefer_dot_shorthands.dart';
import 'src/rules/mix_variants_last.dart';

/// The top-level plugin variable that the Analysis Server looks for
/// when importing `lib/main.dart`.
final plugin = MixLintPlugin();

class MixLintPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry.registerLintRule(MixAvoidDefiningTokensWithinStyle());
    registry.registerLintRule(MixAvoidDefiningTokensWithinScope());
    registry.registerLintRule(MixAvoidEmptyVariants());
    registry.registerLintRule(MixMaxNumberOfAttributesPerStyle());
    registry.registerLintRule(MixVariantsLast());
    registry.registerLintRule(MixMixableStylerHasCreate());
    registry.registerLintRule(MixPreferDotShorthands());
  }

  @override
  String get name => 'mix_lint';
}
