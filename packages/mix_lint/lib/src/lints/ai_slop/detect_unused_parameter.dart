import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Detects function parameters that are never used in the function body.
///
/// AI-generated code often includes parameters that aren't actually used:
/// ```dart
/// void processData(String data, int unused, bool alsoUnused) {
///   print(data);
///   // unused and alsoUnused are never referenced!
/// }
/// ```
///
/// Unused parameters add confusion and suggest incomplete implementation.
class DetectUnusedParameter extends DartLintRule {
  static const _code = LintCode(
    name: 'ai_slop_unused_parameter',
    problemMessage: 'Parameter is never used in the function body.',
    correctionMessage:
        'Remove the unused parameter or prefix with underscore if intentional.',
  );

  const DetectUnusedParameter() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check function declarations
    context.registry.addFunctionDeclaration((node) {
      _checkParameters(
        node.functionExpression.parameters,
        node.functionExpression.body,
        reporter,
      );
    });

    // Check method declarations
    context.registry.addMethodDeclaration((node) {
      _checkParameters(
        node.parameters,
        node.body,
        reporter,
      );
    });
  }

  void _checkParameters(
    FormalParameterList? parameters,
    FunctionBody body,
    ErrorReporter reporter,
  ) {
    if (parameters == null) return;

    // Get the body as a block
    Block? block;
    if (body is BlockFunctionBody) {
      block = body.block;
    } else if (body is ExpressionFunctionBody) {
      // For arrow functions, collect identifiers from the expression
      final usedNames = <String>{};
      body.expression.accept(_IdentifierCollector(usedNames));

      for (final param in parameters.parameters) {
        final paramName = _getParameterName(param);
        if (paramName == null) continue;

        // Skip parameters that start with underscore (intentionally unused)
        if (paramName.startsWith('_')) continue;

        if (!usedNames.contains(paramName)) {
          reporter.atNode(param, _code);
        }
      }
      return;
    } else {
      return; // Empty body or other type
    }

    // Collect all used identifiers in the body
    final usedNames = <String>{};
    block.accept(_IdentifierCollector(usedNames));

    for (final param in parameters.parameters) {
      final paramName = _getParameterName(param);
      if (paramName == null) continue;

      // Skip parameters that start with underscore (intentionally unused)
      if (paramName.startsWith('_')) continue;

      if (!usedNames.contains(paramName)) {
        reporter.atNode(param, _code);
      }
    }
  }

  String? _getParameterName(FormalParameter param) {
    if (param is SimpleFormalParameter) {
      return param.name?.lexeme;
    }
    if (param is DefaultFormalParameter) {
      return _getParameterName(param.parameter);
    }
    if (param is FieldFormalParameter) {
      return param.name.lexeme;
    }
    if (param is SuperFormalParameter) {
      return param.name.lexeme;
    }
    if (param is FunctionTypedFormalParameter) {
      return param.name.lexeme;
    }
    return null;
  }
}

class _IdentifierCollector extends RecursiveAstVisitor<void> {
  final Set<String> usedNames;

  _IdentifierCollector(this.usedNames);

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    usedNames.add(node.name);
    super.visitSimpleIdentifier(node);
  }
}
