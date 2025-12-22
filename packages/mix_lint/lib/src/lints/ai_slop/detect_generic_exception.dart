import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects generic exception messages that don't help with debugging.
///
/// AI-generated code often throws exceptions with unhelpful messages:
/// - `throw Exception("An error occurred");`
/// - `throw Exception("Something went wrong");`
/// - `throw Exception("Error");`
///
/// These messages provide no context for debugging the actual issue.
class DetectGenericException extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_generic_exception',
    problemMessage:
        'Generic exception message provides no debugging context. Include specific error details.',
    correctionMessage:
        'Provide a specific message describing what failed and why.',
  );

  const DetectGenericException() : super(code: _code);

  /// Generic error messages that indicate lazy error handling.
  static final _genericPatterns = [
    RegExp(r'^["\']an?\s+error\s+(has\s+)?occur', caseSensitive: false),
    RegExp(r'^["\']something\s+went\s+wrong', caseSensitive: false),
    RegExp(r'^["\']error["\']?$', caseSensitive: false),
    RegExp(r'^["\']unknown\s+error', caseSensitive: false),
    RegExp(r'^["\']unexpected\s+error', caseSensitive: false),
    RegExp(r'^["\']failed["\']?$', caseSensitive: false),
    RegExp(r'^["\']failure["\']?$', caseSensitive: false),
    RegExp(r'^["\']operation\s+failed', caseSensitive: false),
    RegExp(r'^["\']exception["\']?$', caseSensitive: false),
    RegExp(r'^["\']invalid["\']?$', caseSensitive: false),
    RegExp(r'^["\']invalid\s+(input|data|value|argument|parameter)["\']?$',
        caseSensitive: false),
    RegExp(r'^["\']oops', caseSensitive: false),
    RegExp(r'^["\']whoops', caseSensitive: false),
    RegExp(r'^["\']uh\s*oh', caseSensitive: false),
  ];

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addThrowExpression((node) {
      _checkThrowExpression(node, reporter);
    });
  }

  void _checkThrowExpression(ThrowExpression node, ErrorReporter reporter) {
    final expression = node.expression;

    // Check for `throw Exception("message")`
    if (expression is InstanceCreationExpression) {
      final typeName = expression.constructorName.type.name2.lexeme;

      // Only check common exception types
      if (!_isExceptionType(typeName)) return;

      final arguments = expression.argumentList.arguments;
      if (arguments.isEmpty) {
        // throw Exception() with no message at all
        reporter.atNode(node, _code);
        return;
      }

      final firstArg = arguments.first;
      if (firstArg is SimpleStringLiteral) {
        if (_isGenericMessage(firstArg.literal.lexeme)) {
          reporter.atNode(node, _code);
          return;
        }
      }
    }

    // Check for `throw "message"` (throwing raw strings)
    if (expression is SimpleStringLiteral) {
      if (_isGenericMessage(expression.literal.lexeme)) {
        reporter.atNode(node, _code);
        return;
      }
    }

    // Check for `throw Error()` or `throw StateError("message")`
    if (expression is MethodInvocation) {
      final methodName = expression.methodName.name;
      if (_isExceptionType(methodName)) {
        final arguments = expression.argumentList.arguments;
        if (arguments.isEmpty) {
          reporter.atNode(node, _code);
          return;
        }

        final firstArg = arguments.first;
        if (firstArg is SimpleStringLiteral) {
          if (_isGenericMessage(firstArg.literal.lexeme)) {
            reporter.atNode(node, _code);
            return;
          }
        }
      }
    }
  }

  bool _isExceptionType(String typeName) {
    return typeName == 'Exception' ||
        typeName == 'Error' ||
        typeName == 'StateError' ||
        typeName == 'ArgumentError' ||
        typeName == 'RangeError' ||
        typeName == 'FormatException' ||
        typeName == 'UnsupportedError' ||
        typeName == 'UnimplementedError';
  }

  bool _isGenericMessage(String message) {
    for (final pattern in _genericPatterns) {
      if (pattern.hasMatch(message)) {
        return true;
      }
    }
    return false;
  }
}
