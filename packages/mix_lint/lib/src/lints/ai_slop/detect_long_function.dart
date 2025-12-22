import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/rule_config.dart';

/// Parameters for configuring the long function detection.
class LongFunctionParameters {
  /// Maximum number of lines before warning.
  final int maxLines;

  /// Maximum number of lines before error.
  final int maxLinesError;

  const LongFunctionParameters({
    this.maxLines = 100,
    this.maxLinesError = 200,
  });

  factory LongFunctionParameters.fromJson(Map<String, Object?> json) {
    return LongFunctionParameters(
      maxLines: json['max_lines'] as int? ?? 100,
      maxLinesError: json['max_lines_error'] as int? ?? 200,
    );
  }
}

/// Detects functions that are too long.
///
/// AI-generated code often creates excessively long functions:
/// - Functions over 100 lines should be examined closely
/// - Functions over 200 lines are almost certainly a problem
///
/// Long functions are hard to understand, test, and maintain.
class DetectLongFunction extends DartLintRule {
  final LongFunctionParameters parameters;

  const DetectLongFunction._(this.parameters, {required super.code});

  factory DetectLongFunction.fromConfig(CustomLintConfigs configs) {
    final rule = RuleConfig<LongFunctionParameters>(
      name: 'ai_slop_long_function',
      configs: configs,
      problemMessage: (value) =>
          'Function exceeds ${value.maxLines} lines. Consider breaking it into smaller functions.',
      errorSeverity: ErrorSeverity.WARNING,
      paramsParser: LongFunctionParameters.fromJson,
    );

    return DetectLongFunction._(
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
    // Check method declarations
    context.registry.addMethodDeclaration((node) {
      final body = node.body;
      _checkFunctionBody(body, node.name, reporter);
    });

    // Check function declarations
    context.registry.addFunctionDeclaration((node) {
      final body = node.functionExpression.body;
      _checkFunctionBody(body, node.name, reporter);
    });
  }

  void _checkFunctionBody(
    FunctionBody body,
    Token nameToken,
    ErrorReporter reporter,
  ) {
    if (body is! BlockFunctionBody) return;

    final lineInfo = body.root.lineInfo;
    if (lineInfo == null) return;

    final startLine = lineInfo.getLocation(body.block.offset).lineNumber;
    final endLine = lineInfo.getLocation(body.block.end).lineNumber;
    final lineCount = endLine - startLine + 1;

    if (lineCount > parameters.maxLines) {
      reporter.atOffset(
        offset: nameToken.offset,
        length: nameToken.length,
        errorCode: code,
      );
    }
  }
}
