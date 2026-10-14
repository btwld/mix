import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// A rule that reports a Styler constructor that the factory of its first
/// call can replace.
///
/// It reports `.new().color(x)` anywhere, and `BoxStyler().color(x)` passed to
/// a Styler method, when the factory `.color(x)` accepts the same arguments.
class UnnecessaryStylerConstructor extends AnalysisRule {
  static const LintCode code = LintCode(
    'unnecessary_styler_constructor',
    "The Styler constructor call can be replaced by the factory '.{0}'.",
    correctionMessage: "Try using the dot shorthand '.{0}(...)'.",
  );

  UnnecessaryStylerConstructor()
    : super(
        name: 'unnecessary_styler_constructor',
        description:
            'Prefer factory shorthands such as .color(...) over '
            'BoxStyler().color(...) and .new().color(...) where the Styler '
            'type is known.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    // Dot shorthands need language version 3.10 or later.
    if (!context.isFeatureEnabled(Feature.dot_shorthands)) return;

    final visitor = _Visitor(this, context.typeSystem);
    registry
      ..addDotShorthandConstructorInvocation(this, visitor)
      ..addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final TypeSystem typeSystem;

  const _Visitor(this.rule, this.typeSystem);

  void _check(Expression root, {required bool isDotShorthand}) {
    final type = root.staticType;
    if (type is! InterfaceType || !isMixStylerType(type)) return;

    final chain = collectDirectMethodChain(root);
    final first = chain.firstOrNull;
    if (first == null) return;

    // `.new()` already relies on a context type. A constructor needs one from
    // an enclosing Styler method.
    if (!isDotShorthand && !_isStylerArgument(chain.last, type.element)) {
      return;
    }
    if (!_hasMatchingFactory(type.element, first)) return;

    rule.reportAtSourceRange(
      SourceRange(root.offset, first.methodName.end - root.offset),
      arguments: [first.methodName.name],
    );
  }

  /// Whether [expression] is an argument of a Styler method whose parameter
  /// type is [styler], so a dot shorthand resolves against it.
  bool _isStylerArgument(Expression expression, InterfaceElement styler) {
    final argument = enclosingArgument(expression);
    final argumentList = argument.parent;
    if (argumentList is! ArgumentList) return false;
    if (!isStylerCall(argumentList.parent)) return false;

    final parameter = argument.correspondingParameter;
    if (isMethodTypeParameter(parameter)) return false;
    final parameterType = parameter?.type;

    return parameterType is InterfaceType && parameterType.element == styler;
  }

  /// Whether [styler] declares a factory or static method named like [call]
  /// that accepts the same arguments.
  bool _hasMatchingFactory(InterfaceElement styler, MethodInvocation call) {
    final name = call.methodName.name;
    final ExecutableElement? factory =
        styler.getNamedConstructor(name) ??
        switch (styler.getMethod(name)) {
          final method? when method.isStatic => method,
          _ => null,
        };
    if (factory == null) return false;

    return _acceptsArguments(factory, call.argumentList);
  }

  /// Whether [arguments] would type-check against [executable].
  bool _acceptsArguments(ExecutableElement executable, ArgumentList arguments) {
    final positional = executable.formalParameters
        .where((p) => p.isPositional)
        .toList();
    final named = {
      for (final p in executable.formalParameters.where((p) => p.isNamed))
        p.name: p,
    };
    final suppliedNames = <String>{};
    var index = 0;

    for (final argument in arguments.arguments) {
      final FormalParameterElement? parameter;
      if (argument is NamedArgument) {
        parameter = named[argument.name.lexeme];
        suppliedNames.add(argument.name.lexeme);
      } else {
        parameter = index < positional.length ? positional[index] : null;
        index++;
      }
      final valueType = argument.argumentExpression.staticType;
      if (parameter == null ||
          valueType == null ||
          !typeSystem.isAssignableTo(valueType, parameter.type)) {
        return false;
      }
    }

    final missingPositional = positional
        .skip(index)
        .any((p) => p.isRequiredPositional);
    final missingNamed = named.values.any(
      (p) => p.isRequiredNamed && !suppliedNames.contains(p.name),
    );

    return !missingPositional && !missingNamed;
  }

  @override
  void visitDotShorthandConstructorInvocation(
    DotShorthandConstructorInvocation node,
  ) {
    if (node.constructorName.name != 'new') return;
    if (node.argumentList.arguments.isNotEmpty) return;
    _check(node, isDotShorthand: true);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructorName = node.constructorName;
    if (constructorName.name != null ||
        constructorName.type.typeArguments != null ||
        node.argumentList.arguments.isNotEmpty) {
      return;
    }
    _check(node, isDotShorthand: false);
  }
}
