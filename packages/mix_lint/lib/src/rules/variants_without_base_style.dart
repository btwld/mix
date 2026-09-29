import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// Reports a Styler chain that adds variants but sets no base style.
class VariantsWithoutBaseStyle extends AnalysisRule {
  static const LintCode code = LintCode(
    'variants_without_base_style',
    'This Styler chain has variants but no base style.',
    correctionMessage:
        'Try adding base style calls, such as color() or padding(), before '
        'the variants.',
  );

  VariantsWithoutBaseStyle()
    : super(
        name: 'variants_without_base_style',
        description:
            'Do give a Styler base style values before adding variants.',
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

    final kinds = chain.map(stylerCallKind).toSet();
    // onBuilder() builds the whole style from context, and merge() may bring
    // in a base style, so either one may stand in for base style calls.
    if (kinds.contains(StylerCallKind.builder)) return;
    if (chain.any((call) => call.methodName.name == 'merge')) return;

    if (kinds.contains(StylerCallKind.variant) &&
        !kinds.contains(StylerCallKind.baseStyle)) {
      rule.reportAtNode(root);
    }
  }

  /// Returns true if [styler] overrides another style: it is passed to a
  /// variant or to `merge()`, returned from an `onBuilder` callback, or
  /// wrapped in a `VariantStyle`. Such a Styler needs no base of its own.
  bool _isNestedStyle(Expression styler) {
    for (
      AstNode? node = styler.parent;
      node != null && node is! Declaration;
      node = node.parent
    ) {
      if (node is ArgumentList) {
        final invocation = node.parent;
        if (invocation is MethodInvocation &&
            isMixStylerType(invocation.staticType)) {
          return stylerCallKind(invocation) != .baseStyle;
        }
      }
      if (node is InstanceCreationExpression) {
        final type = node.staticType;
        if (type is InterfaceType && isMixClass(type.element, 'VariantStyle')) {
          return true;
        }
      }
    }

    return false;
  }

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
