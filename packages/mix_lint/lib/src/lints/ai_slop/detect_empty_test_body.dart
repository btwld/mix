import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects test functions with no assertions or meaningful verification.
///
/// AI-generated tests often have empty bodies or only call the function
/// without asserting on the result:
/// ```dart
/// test('should process data', () {
///   processData(input);
///   // No assertion!
/// });
/// ```
///
/// This provides false confidence as the test passes without verifying anything.
class DetectEmptyTestBody extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_empty_test_body',
    problemMessage:
        'Test body has no assertions. Add expect(), assert, or other verification.',
    correctionMessage: 'Add meaningful assertions to verify the expected behavior.',
  );

  const DetectEmptyTestBody() : super(code: _code);

  /// Names that indicate a test function.
  static const _testFunctionNames = {'test', 'testWidgets', 'testGoldens'};

  /// Names that indicate an assertion.
  static const _assertionFunctions = {
    'expect',
    'expectLater',
    'expectAsync',
    'expectAsync0',
    'expectAsync1',
    'expectAsync2',
    'verify',
    'verifyNever',
    'verifyInOrder',
    'verifyZeroInteractions',
    'verifyNoMoreInteractions',
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final methodName = node.methodName.name;

      // Check if this is a test function call
      if (!_testFunctionNames.contains(methodName)) return;

      // Get the callback argument (usually the last argument)
      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;

      // Find the function expression argument
      FunctionExpression? testBody;
      for (final arg in arguments) {
        if (arg is FunctionExpression) {
          testBody = arg;
          break;
        }
      }

      if (testBody == null) return;

      // Check if the test body has any assertions
      final body = testBody.body;
      if (body is! BlockFunctionBody) return;

      final block = body.block;
      if (_hasNoAssertions(block)) {
        reporter.atNode(node, _code);
      }
    });
  }

  bool _hasNoAssertions(Block block) {
    // Check if the block is empty
    if (block.statements.isEmpty) {
      return true;
    }

    // Check if any statement contains an assertion
    for (final statement in block.statements) {
      if (_containsAssertion(statement)) {
        return false;
      }
    }

    return true;
  }

  bool _containsAssertion(AstNode node) {
    // Check for expect() and similar calls
    if (node is ExpressionStatement) {
      return _expressionContainsAssertion(node.expression);
    }

    // Check for assert statements
    if (node is AssertStatement) {
      return true;
    }

    // Check blocks recursively
    if (node is Block) {
      for (final statement in node.statements) {
        if (_containsAssertion(statement)) {
          return true;
        }
      }
    }

    // Check if/else statements
    if (node is IfStatement) {
      if (_containsAssertion(node.thenStatement)) return true;
      final elseStatement = node.elseStatement;
      if (elseStatement != null && _containsAssertion(elseStatement)) {
        return true;
      }
    }

    // Check try/catch
    if (node is TryStatement) {
      if (_containsAssertion(node.body)) return true;
      for (final catchClause in node.catchClauses) {
        if (_containsAssertion(catchClause.body)) return true;
      }
      final finallyBlock = node.finallyBlock;
      if (finallyBlock != null && _containsAssertion(finallyBlock)) return true;
    }

    // Check for loops
    if (node is ForStatement) {
      return _containsAssertion(node.body);
    }
    if (node is WhileStatement) {
      return _containsAssertion(node.body);
    }

    return false;
  }

  bool _expressionContainsAssertion(Expression expression) {
    if (expression is MethodInvocation) {
      final name = expression.methodName.name;
      if (_assertionFunctions.contains(name)) {
        return true;
      }
      // Check for chained assertions like expect(...).toEqual(...)
      final target = expression.target;
      if (target != null && _expressionContainsAssertion(target)) {
        return true;
      }
    }

    if (expression is FunctionExpressionInvocation) {
      // Check the function being invoked
      final function = expression.function;
      if (function is Identifier) {
        if (_assertionFunctions.contains(function.name)) {
          return true;
        }
      }
    }

    // Check await expressions
    if (expression is AwaitExpression) {
      return _expressionContainsAssertion(expression.expression);
    }

    return false;
  }
}
