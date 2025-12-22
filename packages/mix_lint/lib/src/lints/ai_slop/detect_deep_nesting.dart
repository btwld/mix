import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../utils/rule_config.dart';

/// Parameters for configuring the deep nesting detection.
class DeepNestingParameters {
  /// Maximum nesting depth before warning.
  final int maxDepth;

  const DeepNestingParameters({
    this.maxDepth = 4,
  });

  factory DeepNestingParameters.fromJson(Map<String, Object?> json) {
    return DeepNestingParameters(
      maxDepth: json['max_depth'] as int? ?? 4,
    );
  }
}

/// Detects code with excessive nesting depth.
///
/// AI-generated code often creates deeply nested structures:
/// ```dart
/// if (a) {
///   if (b) {
///     if (c) {
///       if (d) {
///         if (e) {
///           // Way too deep!
///         }
///       }
///     }
///   }
/// }
/// ```
///
/// More than 3-4 levels of nesting indicates logic that should be extracted.
class DetectDeepNesting extends DartLintRule {
  final DeepNestingParameters parameters;

  const DetectDeepNesting._(this.parameters, {required super.code});

  factory DetectDeepNesting.fromConfig(CustomLintConfigs configs) {
    final rule = RuleConfig<DeepNestingParameters>(
      name: 'ai_slop_deep_nesting',
      configs: configs,
      problemMessage: (value) =>
          'Code nesting exceeds ${value.maxDepth} levels. Extract logic into separate functions.',
      errorSeverity: ErrorSeverity.WARNING,
      paramsParser: DeepNestingParameters.fromJson,
    );

    return DetectDeepNesting._(
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
      if (body is BlockFunctionBody) {
        _checkNesting(body.block, 0, reporter);
      }
    });

    // Check function declarations
    context.registry.addFunctionDeclaration((node) {
      final body = node.functionExpression.body;
      if (body is BlockFunctionBody) {
        _checkNesting(body.block, 0, reporter);
      }
    });
  }

  void _checkNesting(Block block, int currentDepth, ErrorReporter reporter) {
    for (final statement in block.statements) {
      _checkStatementNesting(statement, currentDepth, reporter);
    }
  }

  void _checkStatementNesting(
    Statement statement,
    int currentDepth,
    ErrorReporter reporter,
  ) {
    // Check if statement
    if (statement is IfStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.ifKeyword.offset,
          length: statement.ifKeyword.length,
          errorCode: code,
        );
        return; // Don't check children, already flagged
      }

      // Check then branch
      final thenStatement = statement.thenStatement;
      if (thenStatement is Block) {
        _checkNesting(thenStatement, newDepth, reporter);
      } else {
        _checkStatementNesting(thenStatement, newDepth, reporter);
      }

      // Check else branch
      final elseStatement = statement.elseStatement;
      if (elseStatement != null) {
        if (elseStatement is Block) {
          _checkNesting(elseStatement, newDepth, reporter);
        } else {
          _checkStatementNesting(elseStatement, newDepth, reporter);
        }
      }
    }

    // Check for loop
    if (statement is ForStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.forKeyword.offset,
          length: statement.forKeyword.length,
          errorCode: code,
        );
        return;
      }

      final body = statement.body;
      if (body is Block) {
        _checkNesting(body, newDepth, reporter);
      } else {
        _checkStatementNesting(body, newDepth, reporter);
      }
    }

    // Check while loop
    if (statement is WhileStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.whileKeyword.offset,
          length: statement.whileKeyword.length,
          errorCode: code,
        );
        return;
      }

      final body = statement.body;
      if (body is Block) {
        _checkNesting(body, newDepth, reporter);
      } else {
        _checkStatementNesting(body, newDepth, reporter);
      }
    }

    // Check do-while loop
    if (statement is DoStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.doKeyword.offset,
          length: statement.doKeyword.length,
          errorCode: code,
        );
        return;
      }

      final body = statement.body;
      if (body is Block) {
        _checkNesting(body, newDepth, reporter);
      } else {
        _checkStatementNesting(body, newDepth, reporter);
      }
    }

    // Check switch statement
    if (statement is SwitchStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.switchKeyword.offset,
          length: statement.switchKeyword.length,
          errorCode: code,
        );
        return;
      }

      for (final member in statement.members) {
        for (final memberStatement in member.statements) {
          _checkStatementNesting(memberStatement, newDepth, reporter);
        }
      }
    }

    // Check try-catch
    if (statement is TryStatement) {
      final newDepth = currentDepth + 1;

      if (newDepth > parameters.maxDepth) {
        reporter.atOffset(
          offset: statement.tryKeyword.offset,
          length: statement.tryKeyword.length,
          errorCode: code,
        );
        return;
      }

      _checkNesting(statement.body, newDepth, reporter);

      for (final catchClause in statement.catchClauses) {
        _checkNesting(catchClause.body, newDepth, reporter);
      }

      final finallyBlock = statement.finallyBlock;
      if (finallyBlock != null) {
        _checkNesting(finallyBlock, newDepth, reporter);
      }
    }
  }
}
