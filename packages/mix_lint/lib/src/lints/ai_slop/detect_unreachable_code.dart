import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects unreachable code after return/throw statements.
///
/// AI-generated code often has statements after return that never execute:
/// ```dart
/// function process() {
///   return result;
///   cleanupResources();  // Never executes!
/// }
/// ```
///
/// This is dead code that clutters the codebase.
class DetectUnreachableCode extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_unreachable_code',
    problemMessage: 'Unreachable code after return/throw statement.',
    correctionMessage: 'Remove the unreachable code or restructure the logic.',
  );

  const DetectUnreachableCode() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check blocks for unreachable statements
    context.registry.addBlock((block) {
      _checkBlock(block, reporter);
    });
  }

  void _checkBlock(Block block, ErrorReporter reporter) {
    bool foundTerminator = false;
    int terminatorIndex = -1;

    for (int i = 0; i < block.statements.length; i++) {
      final statement = block.statements[i];

      if (foundTerminator) {
        // Everything after a terminator is unreachable
        reporter.atNode(statement, _code);
      } else if (_isTerminatingStatement(statement)) {
        foundTerminator = true;
        terminatorIndex = i;
      }
    }
  }

  bool _isTerminatingStatement(Statement statement) {
    // Return statement
    if (statement is ReturnStatement) {
      return true;
    }

    // Throw expression
    if (statement is ExpressionStatement) {
      if (statement.expression is ThrowExpression) {
        return true;
      }
      if (statement.expression is RethrowExpression) {
        return true;
      }
    }

    // Break and continue in loop context
    if (statement is BreakStatement) {
      return true;
    }
    if (statement is ContinueStatement) {
      return true;
    }

    // Check if it's an if-else where both branches terminate
    if (statement is IfStatement) {
      final elseStatement = statement.elseStatement;
      if (elseStatement != null) {
        final thenTerminates = _blockTerminates(statement.thenStatement);
        final elseTerminates = _blockTerminates(elseStatement);
        return thenTerminates && elseTerminates;
      }
    }

    return false;
  }

  bool _blockTerminates(Statement statement) {
    if (statement is Block) {
      if (statement.statements.isEmpty) return false;
      return _isTerminatingStatement(statement.statements.last);
    }
    return _isTerminatingStatement(statement);
  }
}
