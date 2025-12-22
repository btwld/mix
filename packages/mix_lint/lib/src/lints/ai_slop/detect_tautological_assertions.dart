import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects tautological assertions that always pass.
///
/// AI-generated tests often include assertions that verify nothing:
/// - `expect(true, isTrue);`
/// - `expect(1, equals(1));`
/// - `expect(result, isNotNull);` // Only checks existence
/// - `assert(true);`
///
/// These assertions pass regardless of the actual code behavior.
class DetectTautologicalAssertions extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_tautological_assertion',
    problemMessage:
        'This assertion always passes and verifies nothing meaningful.',
    correctionMessage: 'Replace with an assertion that tests actual behavior.',
  );

  const DetectTautologicalAssertions() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check expect() calls
    context.registry.addMethodInvocation((node) {
      final methodName = node.methodName.name;

      if (methodName == 'expect') {
        _checkExpectCall(node, reporter);
      }
    });

    // Check assert statements
    context.registry.addAssertStatement((node) {
      _checkAssertStatement(node, reporter);
    });
  }

  void _checkExpectCall(MethodInvocation node, ErrorReporter reporter) {
    final arguments = node.argumentList.arguments;
    if (arguments.isEmpty) return;

    final firstArg = arguments.first;

    // Check for expect(true, ...)
    if (firstArg is BooleanLiteral && firstArg.value == true) {
      if (arguments.length >= 2) {
        final matcher = arguments[1];
        // expect(true, isTrue) or expect(true, equals(true))
        if (_isAlwaysTrueMatcher(matcher)) {
          reporter.atNode(node, _code);
          return;
        }
      }
    }

    // Check for expect(false, isFalse)
    if (firstArg is BooleanLiteral && firstArg.value == false) {
      if (arguments.length >= 2) {
        final matcher = arguments[1];
        if (_isAlwaysFalseMatcher(matcher)) {
          reporter.atNode(node, _code);
          return;
        }
      }
    }

    // Check for expect(literal, equals(sameLiteral))
    if (arguments.length >= 2) {
      final matcher = arguments[1];
      if (_isIdenticalLiteralMatcher(firstArg, matcher)) {
        reporter.atNode(node, _code);
        return;
      }
    }

    // Check for expect(anything, isNotNull) where 'anything' is obviously not null
    if (arguments.length >= 2) {
      final matcher = arguments[1];
      if (_isNotNullMatcherWithObviousValue(firstArg, matcher)) {
        reporter.atNode(node, _code);
        return;
      }
    }
  }

  void _checkAssertStatement(AssertStatement node, ErrorReporter reporter) {
    final condition = node.condition;

    // Check for assert(true)
    if (condition is BooleanLiteral && condition.value == true) {
      reporter.atNode(node, _code);
      return;
    }

    // Check for assert(1 == 1) or similar obvious tautologies
    if (condition is BinaryExpression) {
      if (_isObviousTautology(condition)) {
        reporter.atNode(node, _code);
        return;
      }
    }
  }

  bool _isAlwaysTrueMatcher(Expression matcher) {
    // Check for isTrue
    if (matcher is Identifier && matcher.name == 'isTrue') {
      return true;
    }

    // Check for equals(true)
    if (matcher is MethodInvocation && matcher.methodName.name == 'equals') {
      final args = matcher.argumentList.arguments;
      if (args.isNotEmpty && args.first is BooleanLiteral) {
        return (args.first as BooleanLiteral).value == true;
      }
    }

    return false;
  }

  bool _isAlwaysFalseMatcher(Expression matcher) {
    // Check for isFalse
    if (matcher is Identifier && matcher.name == 'isFalse') {
      return true;
    }

    // Check for equals(false)
    if (matcher is MethodInvocation && matcher.methodName.name == 'equals') {
      final args = matcher.argumentList.arguments;
      if (args.isNotEmpty && args.first is BooleanLiteral) {
        return (args.first as BooleanLiteral).value == false;
      }
    }

    return false;
  }

  bool _isIdenticalLiteralMatcher(Expression actual, Expression matcher) {
    if (matcher is! MethodInvocation) return false;
    if (matcher.methodName.name != 'equals') return false;

    final matcherArgs = matcher.argumentList.arguments;
    if (matcherArgs.isEmpty) return false;

    final expected = matcherArgs.first;

    // Check if both are the same integer literal
    if (actual is IntegerLiteral && expected is IntegerLiteral) {
      return actual.value == expected.value;
    }

    // Check if both are the same double literal
    if (actual is DoubleLiteral && expected is DoubleLiteral) {
      return actual.value == expected.value;
    }

    // Check if both are the same string literal
    if (actual is SimpleStringLiteral && expected is SimpleStringLiteral) {
      return actual.value == expected.value;
    }

    // Check if both are the same boolean literal
    if (actual is BooleanLiteral && expected is BooleanLiteral) {
      return actual.value == expected.value;
    }

    return false;
  }

  bool _isNotNullMatcherWithObviousValue(Expression actual, Expression matcher) {
    // Check for isNotNull matcher
    if (matcher is! Identifier || matcher.name != 'isNotNull') {
      return false;
    }

    // These are obviously not null
    if (actual is IntegerLiteral) return true;
    if (actual is DoubleLiteral) return true;
    if (actual is StringLiteral) return true;
    if (actual is BooleanLiteral) return true;
    if (actual is ListLiteral) return true;
    if (actual is SetOrMapLiteral) return true;
    if (actual is InstanceCreationExpression) return true;

    return false;
  }

  bool _isObviousTautology(BinaryExpression expr) {
    final left = expr.leftOperand;
    final right = expr.rightOperand;
    final op = expr.operator.lexeme;

    // Check for == comparison of identical literals
    if (op == '==') {
      if (left is IntegerLiteral &&
          right is IntegerLiteral &&
          left.value == right.value) {
        return true;
      }
      if (left is DoubleLiteral &&
          right is DoubleLiteral &&
          left.value == right.value) {
        return true;
      }
      if (left is SimpleStringLiteral &&
          right is SimpleStringLiteral &&
          left.value == right.value) {
        return true;
      }
      if (left is BooleanLiteral &&
          right is BooleanLiteral &&
          left.value == right.value) {
        return true;
      }
    }

    return false;
  }
}
