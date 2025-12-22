import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects overly broad exception handling that catches everything.
///
/// AI-generated code often uses overly broad catches:
/// ```dart
/// try {
///   specificOperation();
/// } catch (e) {
///   // Catches EVERYTHING including programmer errors
///   return defaultValue;
/// }
/// ```
///
/// This pattern hides real bugs by catching exceptions that should propagate.
class DetectOverbroadCatch extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_overbroad_catch',
    problemMessage:
        'Catch-all exception handling hides bugs. Catch specific exception types or rethrow.',
    correctionMessage:
        'Specify the exception type to catch, or rethrow unexpected exceptions.',
  );

  const DetectOverbroadCatch() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTryStatement((node) {
      for (final catchClause in node.catchClauses) {
        if (_isOverbroadCatch(catchClause)) {
          reporter.atNode(catchClause, _code);
        }
      }
    });
  }

  bool _isOverbroadCatch(CatchClause catchClause) {
    // Check if the catch has no type specified (catches everything)
    final exceptionType = catchClause.exceptionType;

    // `catch (e)` - no type specified
    if (exceptionType == null) {
      // Check if it doesn't rethrow
      return !_doesRethrow(catchClause.body);
    }

    // `on Object catch (e)` or `on dynamic catch (e)` - explicitly catches all
    final typeName = exceptionType.name2.lexeme;
    if (typeName == 'Object' || typeName == 'dynamic') {
      return !_doesRethrow(catchClause.body);
    }

    // `on Exception catch (e)` - catches too broad in most cases
    // Only flag if it doesn't rethrow and has catch-and-ignore pattern
    if (typeName == 'Exception') {
      return _isCatchAndDefault(catchClause.body);
    }

    return false;
  }

  bool _doesRethrow(Block body) {
    for (final statement in body.statements) {
      if (_containsRethrow(statement)) {
        return true;
      }
    }
    return false;
  }

  bool _containsRethrow(AstNode node) {
    // Check for rethrow statement
    if (node is ExpressionStatement) {
      if (node.expression is RethrowExpression) {
        return true;
      }
      // Check for `throw e;` where e is the caught exception
      if (node.expression is ThrowExpression) {
        return true;
      }
    }

    // Check if statements
    if (node is IfStatement) {
      if (_containsRethrow(node.thenStatement)) return true;
      final elseStatement = node.elseStatement;
      if (elseStatement != null && _containsRethrow(elseStatement)) return true;
    }

    // Check blocks
    if (node is Block) {
      for (final statement in node.statements) {
        if (_containsRethrow(statement)) return true;
      }
    }

    return false;
  }

  bool _isCatchAndDefault(Block body) {
    // Check if the catch body just returns a default value or ignores the error
    if (body.statements.isEmpty) return true;

    if (body.statements.length == 1) {
      final statement = body.statements.first;

      // Return with some default value
      if (statement is ReturnStatement) {
        final expr = statement.expression;
        // Returning null, empty list, empty map, or a literal
        if (expr == null) return true; // return;
        if (expr is NullLiteral) return true;
        if (expr is ListLiteral && expr.elements.isEmpty) return true;
        if (expr is SetOrMapLiteral && expr.elements.isEmpty) return true;
        if (expr is IntegerLiteral && expr.value == 0) return true;
        if (expr is BooleanLiteral) return true;
        if (expr is SimpleStringLiteral && expr.value.isEmpty) return true;
      }
    }

    return false;
  }
}
