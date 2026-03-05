import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/type_checker.dart';

class AvoidEmptyVariants extends DartLintRule {
  static const _code = LintCode(
    name: 'mix_avoid_empty_variants',
    problemMessage:
        'Ensure that all Variants are applying attributes when used.',
  );

  const AvoidEmptyVariants() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionExpressionInvocation((expression) {
      final type = expression.staticType;
      if (type == null) return;

      if (!variantAttributeChecker.isAssignableFromType(type)) return;

      if (expression.argumentList.arguments.isEmpty) {
        reporter.atOffset(
          errorCode: _code,
          offset: expression.offset,
          length: expression.length,
        );
      }
    });
  }
}
