import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/extensions/lint_rule_node_registry.dart';
import '../../utils/rule_config.dart';
import '../../utils/type_checker.dart';
import 'max_number_of_attributes_per_style_parameters.dart';

class MaxNumberOfAttributesPerStyle extends DartLintRule {
  final MaxNumberOfAttributesPerStyleParameters parameters;

  const MaxNumberOfAttributesPerStyle._(this.parameters, {required super.code});

  factory MaxNumberOfAttributesPerStyle.fromConfig(CustomLintConfigs configs) {
    final rule = RuleConfig<MaxNumberOfAttributesPerStyleParameters>(
      name: 'mix_max_number_of_attributes_per_style',
      configs: configs,
      problemMessage: (value) =>
          'The maximum allowed attributes of a function is ${value.maxNumber}.',
      errorSeverity: ErrorSeverity.WARNING,
      paramsParser: MaxNumberOfAttributesPerStyleParameters.fromJson,
    );

    return MaxNumberOfAttributesPerStyle._(
      rule.parameters,
      code: rule.lintCode,
    );
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpressionFor(
      styleChecker,
      (node) {
        if (node.argumentList.arguments.length > parameters.maxNumber) {
          reporter.atNode(node, code);
        }
      },
    );

    context.registry.addFunctionExpressionInvocationFor(
      variantAttributeChecker,
      (node) {
        if (node.argumentList.arguments.length > parameters.maxNumber) {
          reporter.atNode(node, code);
        }
      },
    );
  }
}
