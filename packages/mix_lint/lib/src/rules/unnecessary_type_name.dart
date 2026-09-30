import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

/// Reports `TypeName.member` in a Styler argument when the dot shorthand
/// `.member` resolves to the same member.
///
/// Dot shorthands resolve against the parameter's type, so the rule only
/// reports a static member or named constructor declared by that exact type.
/// It never suggests `.new(...)` for unnamed constructors.
class UnnecessaryTypeName extends AnalysisRule {
  static const LintCode code = LintCode(
    'unnecessary_type_name',
    "The type name '{0}' can be inferred from the parameter type.",
    correctionMessage: "Try using the dot shorthand '.{1}'.",
  );

  UnnecessaryTypeName()
    : super(
        name: 'unnecessary_type_name',
        description:
            'Prefer dot shorthands over type names in Styler arguments.',
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

    final visitor = _Visitor(this);
    registry
      ..addInstanceCreationExpression(this, visitor)
      ..addMethodInvocation(this, visitor)
      ..addPrefixedIdentifier(this, visitor)
      ..addPropertyAccess(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  /// Reports [node] when it is an argument of a Styler method and [member]
  /// is a static member or named constructor of the parameter's type.
  void _check(
    Expression node, {
    required Element? member,
    required Expression? typeName,
  }) {
    if (!_isStylerArgument(node)) return;
    if (typeName != null && _referencedType(typeName) == null) return;
    if (!_isStaticOrNamedConstructor(member)) return;

    final parameter = node.correspondingParameter;
    if (_isMethodTypeParameter(parameter)) return;

    final declaringType = member?.enclosingElement;
    final parameterType = parameter?.type;
    if (declaringType is! InterfaceElement ||
        parameterType is! InterfaceType ||
        parameterType.element != declaringType) {
      return;
    }

    rule.reportAtNode(
      node,
      arguments: [declaringType.name ?? '', member?.name ?? ''],
    );
  }

  /// Returns true if [parameter] is declared with a type parameter of the
  /// invoked method, such as `T` in `foo<T>(T value)`. The argument infers
  /// that type, so a dot shorthand there has no context type.
  bool _isMethodTypeParameter(FormalParameterElement? parameter) {
    final declaredType = switch (parameter?.baseElement) {
      FormalParameterElement(:final type) => type,
      _ => null,
    };

    return declaredType is TypeParameterType &&
        declaredType.element.enclosingElement is ExecutableElement;
  }

  /// Returns true if [node] is a positional argument of a call that builds a
  /// Styler: a method such as `.padding(...)`, a factory such as
  /// `BoxStyler.padding(...)`, or a dot shorthand such as `.padding(...)`.
  bool _isStylerArgument(Expression node) {
    final argumentList = node.parent;
    if (argumentList is! ArgumentList) return false;
    final invocation = argumentList.parent;

    return (invocation is MethodInvocation ||
            invocation is InstanceCreationExpression ||
            invocation is DotShorthandInvocation ||
            invocation is DotShorthandConstructorInvocation) &&
        isMixStylerType((invocation as Expression).staticType);
  }

  /// Returns the type that [target] names, such as `FontWeight` in
  /// `FontWeight.w600` or `ui.FontWeight` with an import prefix.
  InterfaceElement? _referencedType(Expression target) {
    final element = switch (target) {
      SimpleIdentifier() => target.element,
      PrefixedIdentifier() => target.identifier.element,
      _ => null,
    };

    return element is InterfaceElement ? element : null;
  }

  bool _isStaticOrNamedConstructor(Element? member) => switch (member) {
    ConstructorElement() => member.name != 'new',
    ExecutableElement() => member.isStatic,
    FieldElement() => member.isStatic,
    _ => false,
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Only named constructors. Mix style does not use `.new(...)`.
    if (node.constructorName.name == null) return;
    // `Type<Args>.name()` would lose its explicit type arguments.
    if (node.constructorName.type.typeArguments != null) return;
    _check(node, member: node.constructorName.element, typeName: null);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target;
    if (target == null) return;
    _check(node, member: node.methodName.element, typeName: target);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _check(node, member: node.identifier.element, typeName: node.prefix);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final target = node.target;
    if (target == null) return;
    _check(node, member: node.propertyName.element, typeName: target);
  }
}
