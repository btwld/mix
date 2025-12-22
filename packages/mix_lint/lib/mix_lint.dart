import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/extract_attributes.dart';
import 'src/lints/attributes_ordering.dart';
import 'src/lints/avoid_defining_tokens_or_variants_within_style.dart';
import 'src/lints/avoid_defining_tokens_within_theme_data.dart';
import 'src/lints/avoid_empty_variants.dart';
import 'src/lints/avoid_variant_inside_context_variant.dart';
import 'src/lints/max_number_of_attributes_per_style/max_number_of_attributes_per_style.dart';

// AI Slop Detector rules
import 'src/lints/ai_slop/detect_commented_code.dart';
import 'src/lints/ai_slop/detect_deep_nesting.dart';
import 'src/lints/ai_slop/detect_empty_test_body.dart';
import 'src/lints/ai_slop/detect_generic_exception.dart';
import 'src/lints/ai_slop/detect_god_class.dart';
import 'src/lints/ai_slop/detect_hedging_comments.dart';
import 'src/lints/ai_slop/detect_long_function.dart';
import 'src/lints/ai_slop/detect_obvious_comments.dart';
import 'src/lints/ai_slop/detect_overbroad_catch.dart';
import 'src/lints/ai_slop/detect_over_documentation.dart';
import 'src/lints/ai_slop/detect_placeholder_comments.dart';
import 'src/lints/ai_slop/detect_silent_catch.dart';
import 'src/lints/ai_slop/detect_tautological_assertions.dart';
import 'src/lints/ai_slop/detect_unreachable_code.dart';
import 'src/lints/ai_slop/detect_unused_parameter.dart';

PluginBase createPlugin() => _MixLint();

class _MixLint extends PluginBase {
  @override
  List<Assist> getAssists() {
    return [ExtractAttributes()];
  }

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    // Mix-specific rules
    const AttributesOrdering(),
    const AvoidDefiningTokensOrVariantsWithinStyle(),
    const AvoidDefiningTokensWithinThemeData(),
    const AvoidVariantInsideContextVariant(),
    const AvoidEmptyVariants(),
    MaxNumberOfAttributesPerStyle.fromConfig(configs),

    // AI Slop Detector - Comment Anti-patterns
    const DetectObviousComments(),
    const DetectHedgingComments(),
    const DetectPlaceholderComments(),
    const DetectOverDocumentation(),

    // AI Slop Detector - Test Theater
    const DetectEmptyTestBody(),
    const DetectTautologicalAssertions(),

    // AI Slop Detector - Error Handling Theater
    const DetectSilentCatch(),
    const DetectGenericException(),
    const DetectOverbroadCatch(),

    // AI Slop Detector - Dead Code
    const DetectUnreachableCode(),
    const DetectCommentedCode(),
    const DetectUnusedParameter(),

    // AI Slop Detector - Structural Issues
    DetectGodClass.fromConfig(configs),
    DetectLongFunction.fromConfig(configs),
    DetectDeepNesting.fromConfig(configs),
  ];
}
