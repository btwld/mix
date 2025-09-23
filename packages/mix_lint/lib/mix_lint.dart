import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/lints/max_number_of_attributes_per_style/max_number_of_attributes_per_style.dart';

import 'src/assists/extract_attributes.dart';
import 'src/lints/attributes_ordering.dart';
import 'src/lints/avoid_defining_tokens_or_variants_within_style.dart';
import 'src/lints/avoid_defining_tokens_within_theme_data.dart';
import 'src/lints/avoid_empty_variants.dart';
import 'src/lints/avoid_variant_inside_context_variant.dart';

PluginBase createPlugin() => _MixLint();

class _MixLint extends PluginBase {
  @override
  List<Assist> getAssists() {
    return [ExtractAttributes()];
  }

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AttributesOrdering(),
        const AvoidDefiningTokensOrVariantsWithinStyle(),
        const AvoidDefiningTokensWithinThemeData(),
        const AvoidVariantInsideContextVariant(),
        const AvoidEmptyVariants(),
        MaxNumberOfAttributesPerStyle.fromConfig(configs),
      ];
}
