import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// A rule that reports a Styler chain that adds variants but no base style.
class VariantsWithoutBaseStyle extends AnalysisRule {
  static const LintCode code = LintCode(
    'variants_without_base_style',
    'This Styler chain has variants but no base style.',
    correctionMessage:
        "Try adding base style calls, such as 'color()' or 'padding()', "
        'before the variants.',
  );

  VariantsWithoutBaseStyle()
    : super(
        name: 'variants_without_base_style',
        description: 'Do set a base style before adding variants.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry
      ..addDotShorthandConstructorInvocation(this, visitor)
      ..addDotShorthandInvocation(this, visitor)
      ..addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  void _check(Expression root) {
    if (!isMixStylerType(root.staticType)) return;
    if (rootSetsBaseStyle(root)) return;

    final chain = collectDirectMethodChain(root);
    if (_isNestedStyle(chain.lastOrNull ?? root)) return;

    final kinds = {
      ?rootFactoryKind(root),
      if (rootVariantsArgument(root) != null) StylerCallKind.variant,
      ...chain.map(stylerCallKind),
    };
    // onBuilder() builds the whole style from context, and merge() may bring
    // in a base style, so either one may stand in for base style calls.
    // merge(null) brings in nothing.
    if (kinds.contains(StylerCallKind.builder)) return;
    if (chain.any(_mergesStyle)) return;

    if (kinds.contains(StylerCallKind.variant) &&
        !kinds.contains(StylerCallKind.baseStyle)) {
      rule.reportAtNode(root);
    }
  }

  /// Whether [styler] overrides another style, so it needs no base style of
  /// its own.
  ///
  /// It does when it is passed to a variant or to `merge()`, returned from an
  /// `onBuilder` callback, or wrapped in a `VariantStyle`. The walk continues
  /// past local variables, such as one that an `onBuilder` callback returns.
  bool _isNestedStyle(Expression styler) {
    for (
      AstNode? node = styler.parent;
      node != null && (node is! Declaration || _isLocalVariable(node));
      node = node.parent
    ) {
      if (node is ArgumentList) {
        final kind = switch (node.parent) {
          final MethodInvocation call when isMixStylerType(call.staticType) =>
            stylerCallKind(call),
          // A Styler factory, such as `.onConstraints(breakpoint, patch)`.
          final Expression call when isStylerCall(call) => rootFactoryKind(
            call,
          ),
          _ => null,
        };
        if (kind != null) return kind != .baseStyle;
      }
      if (node is InstanceCreationExpression ||
          node is DotShorthandConstructorInvocation) {
        final type = (node as Expression).staticType;
        if (type is InterfaceType && isMixClass(type.element, 'VariantStyle')) {
          return true;
        }
      }
    }

    return false;
  }

  /// Whether [call] is a `merge()` call with an argument other than `null`.
  bool _mergesStyle(MethodInvocation call) =>
      call.methodName.name == 'merge' &&
      call.argumentList.arguments.firstOrNull is! NullLiteral;

  /// Whether [node] declares a local variable.
  bool _isLocalVariable(AstNode node) =>
      node is VariableDeclaration &&
      node.parent?.parent is VariableDeclarationStatement;

  @override
  void visitDotShorthandConstructorInvocation(
    DotShorthandConstructorInvocation node,
  ) => _check(node);

  @override
  void visitDotShorthandInvocation(DotShorthandInvocation node) => _check(node);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) =>
      _check(node);
}
