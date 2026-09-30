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

/// Reports `TypeName.member` in a Styler expression when the dot shorthand
/// `.member` resolves to the same member.
///
/// A Styler expression is an argument of a Styler call, or of a Mix call
/// nested inside one, such as `.widgetState(...)` in
/// `.onNot(.widgetState(WidgetState.hovered), ...)`. Mix code outside Styler
/// expressions, such as the framework's own implementation, is not checked.
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
            'Prefer dot shorthands over type names in Styler expressions.',
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

  /// Reports [node] when it is an argument to a Mix API and [member] is a
  /// static member or named constructor of the parameter's type.
  void _check(
    Expression node, {
    required Element? member,
    required Expression? typeName,
  }) {
    final parent = node.parent;
    final Argument argument = parent is NamedArgument ? parent : node;
    if (!_isMixApiArgument(argument)) return;
    if (typeName != null && _referencedType(typeName) == null) return;
    if (!_isStaticOrNamedConstructor(member)) return;

    final parameter = argument.correspondingParameter;
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

  /// Returns true if [argument] is passed to a call that builds a Styler, or
  /// to a Mix call nested inside one. Mix calls are calls that `package:mix`
  /// declares and calls that build Mix values, including generated types.
  bool _isMixApiArgument(Argument argument) {
    final argumentList = argument.parent;
    if (argumentList is! ArgumentList) return false;

    final (invocation, callee) = switch (argumentList.parent) {
      final MethodInvocation node => (node, node.methodName.element),
      final InstanceCreationExpression node => (
        node,
        node.constructorName.element,
      ),
      final DotShorthandInvocation node => (node, node.memberName.element),
      final DotShorthandConstructorInvocation node => (
        node,
        node.constructorName.element,
      ),
      _ => (null, null),
    };
    if (invocation == null) return false;
    if (_buildsStyler(invocation)) return true;
    if (!isFromMix(callee) && !isMixType(invocation.staticType)) return false;

    return _isInsideStylerCall(invocation);
  }

  bool _buildsStyler(AstNode? call) =>
      (call is MethodInvocation ||
          call is InstanceCreationExpression ||
          call is DotShorthandInvocation ||
          call is DotShorthandConstructorInvocation) &&
      isMixStylerType((call as Expression).staticType);

  /// Returns true if [node] is nested in an argument of a Styler call, such
  /// as `.widgetState(...)` in `.onNot(.widgetState(...), ...)`.
  bool _isInsideStylerCall(AstNode node) {
    for (
      AstNode? current = node.parent;
      current != null &&
          current is! Statement &&
          current is! Declaration &&
          current is! FunctionBody;
      current = current.parent
    ) {
      if (current is ArgumentList && _buildsStyler(current.parent)) return true;
    }

    return false;
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
