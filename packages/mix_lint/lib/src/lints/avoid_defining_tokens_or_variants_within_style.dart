import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mix_lint/src/utils/type_checker.dart';

import '../utils/extensions/lint_rule_node_registry.dart';

class AvoidDefiningTokensOrVariantsWithinStyle extends DartLintRule {
  AvoidDefiningTokensOrVariantsWithinStyle() : super(code: _code);

  static const _code = LintCode(
    name: 'mix_avoid_defining_tokens_or_variants_within_style',
    problemMessage:
        'Ensure that Variant and MixToken instances are not created directly inside Style constructors.',
    correctionMessage:
        'Instantiate Variant and MixToken outside of Style constructors.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.checkTypeHierarchyCompliance(
      parent: styleChecker,
      child: variantChecker,
      reporter: reporter,
      code: _code,
    );

    context.checkTypeHierarchyCompliance(
      parent: styleChecker,
      child: mixTokenChecker,
      reporter: reporter,
      code: _code,
    );
  }
}
