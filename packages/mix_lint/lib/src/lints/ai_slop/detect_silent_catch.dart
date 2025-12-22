import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects empty or silent catch blocks that swallow exceptions.
///
/// AI-generated code often includes catch blocks that hide errors:
/// ```dart
/// try {
///   riskyOperation();
/// } catch (e) {
///   // empty - swallows all errors!
/// }
/// ```
///
/// This makes debugging extremely difficult as errors are silently ignored.
class DetectSilentCatch extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_silent_catch',
    problemMessage:
        'Empty or silent catch block swallows exceptions. Handle or rethrow the error.',
    correctionMessage:
        'Add error handling, logging, or rethrow the exception.',
  );

  const DetectSilentCatch() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTryStatement((node) {
      for (final catchClause in node.catchClauses) {
        if (_isSilentCatch(catchClause)) {
          reporter.atNode(catchClause, _code);
        }
      }
    });
  }

  bool _isSilentCatch(CatchClause catchClause) {
    final body = catchClause.body;

    // Check if the catch body is empty
    if (body.statements.isEmpty) {
      return true;
    }

    // Check if the catch body only has comments (effectively empty)
    // The AST doesn't include comments in statements, so empty statements list
    // with comments will still have isEmpty == true

    // Check if the catch body only has a pass-like statement
    if (body.statements.length == 1) {
      final statement = body.statements.first;

      // Check for `return;` with no value
      if (statement is ReturnStatement && statement.expression == null) {
        return true;
      }

      // Check for empty expression statement
      if (statement is EmptyStatement) {
        return true;
      }
    }

    return false;
  }
}
