import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
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
    registry.addInstanceCreationExpression(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  /// Returns true if [styler] is the style passed to a variant or to
  /// `merge()`, such as the inner Styler in `.onDark(BoxStyler().onHovered(x))`.
  /// Such a Styler overrides another style, so it needs no base.
  bool _isNestedStyle(Expression styler) {
    final argumentList = styler.parent;
    if (argumentList is! ArgumentList) return false;
    final invocation = argumentList.parent;

    return invocation is MethodInvocation &&
        isMixStylerType(invocation.staticType) &&
        stylerCallKind(invocation) != .baseStyle;
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixStylerType(node.staticType)) return;

    final chain = collectDirectMethodChain(node);
    if (_isNestedStyle(chain.lastOrNull ?? node)) return;

    final kinds = chain.map(stylerCallKind).toSet();
    // onBuilder() builds the whole style from context, so it may stand alone.
    if (kinds.contains(StylerCallKind.builder)) return;

    if (kinds.contains(StylerCallKind.variant) &&
        !kinds.contains(StylerCallKind.baseStyle)) {
      rule.reportAtNode(node);
    }
  }
}
