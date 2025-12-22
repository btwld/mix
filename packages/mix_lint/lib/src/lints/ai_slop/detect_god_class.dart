import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/rule_config.dart';

/// Parameters for configuring the god class detection.
class GodClassParameters {
  /// Maximum number of methods before flagging as potential god class.
  final int maxMethods;

  /// Maximum number of fields before flagging.
  final int maxFields;

  const GodClassParameters({
    this.maxMethods = 20,
    this.maxFields = 15,
  });

  factory GodClassParameters.fromJson(Map<String, Object?> json) {
    return GodClassParameters(
      maxMethods: json['max_methods'] as int? ?? 20,
      maxFields: json['max_fields'] as int? ?? 15,
    );
  }
}

/// Detects classes with too many members (god classes).
///
/// AI-generated code often creates massive classes with many responsibilities:
/// - Classes with 20+ methods indicate multiple concerns
/// - Classes with 15+ fields indicate excessive state
///
/// These violate Single Responsibility Principle and are hard to maintain.
class DetectGodClass extends DartLintRule {
  final GodClassParameters parameters;

  const DetectGodClass._(this.parameters, {required super.code});

  factory DetectGodClass.fromConfig(CustomLintConfigs configs) {
    final rule = RuleConfig<GodClassParameters>(
      name: 'ai_slop_god_class',
      configs: configs,
      problemMessage: (value) =>
          'Class exceeds recommended size (max ${value.maxMethods} methods, ${value.maxFields} fields). Consider splitting into smaller classes.',
      errorSeverity: ErrorSeverity.WARNING,
      paramsParser: GodClassParameters.fromJson,
    );

    return DetectGodClass._(
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
    context.registry.addClassDeclaration((node) {
      final methodCount = _countMethods(node);
      final fieldCount = _countFields(node);

      if (methodCount > parameters.maxMethods ||
          fieldCount > parameters.maxFields) {
        reporter.atNode(
          node.name,
          code,
        );
      }
    });
  }

  int _countMethods(ClassDeclaration node) {
    int count = 0;
    for (final member in node.members) {
      if (member is MethodDeclaration) {
        count++;
      }
      if (member is ConstructorDeclaration) {
        count++;
      }
    }
    return count;
  }

  int _countFields(ClassDeclaration node) {
    int count = 0;
    for (final member in node.members) {
      if (member is FieldDeclaration) {
        count += member.fields.variables.length;
      }
    }
    return count;
  }
}
