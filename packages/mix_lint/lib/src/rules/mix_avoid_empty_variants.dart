import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

class MixAvoidEmptyVariants extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_avoid_empty_variants',
    'Styler chains should include at least one base styling method, not only variant methods.',
    correctionMessage:
        'Add base style properties (e.g. .color(), .paddingAll()) before the variant methods.',
  );

  MixAvoidEmptyVariants()
      : super(
          name: 'mix_avoid_empty_variants',
          description:
              'Ensures Styler chains include at least one non-variant method. '
              'A style with only variant overrides (onHovered, onDark, etc.) has no default appearance.',
        );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixStylerType(node.staticType)) return;

    final chain = _collectChain(node);
    if (chain.isEmpty) return;

    final allVariants =
        chain.every((mi) => isVariantMethodName(mi.methodName.name));
    if (allVariants) {
      rule.reportAtNode(node);
    }
  }

  /// Collects the linear chain of [MethodInvocation]s directly following [ice].
  /// Stops when the chain branches into non-target contexts (e.g. argument lists).
  List<MethodInvocation> _collectChain(InstanceCreationExpression ice) {
    final chain = <MethodInvocation>[];
    AstNode? current = ice;

    while (true) {
      final parent = current!.parent;
      if (parent is MethodInvocation && parent.target == current) {
        chain.add(parent);
        current = parent;
      } else {
        break;
      }
    }

    return chain;
  }
}
