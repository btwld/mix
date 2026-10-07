import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// Reports a base style call that comes after a variant in a Styler chain.
class BaseStyleAfterVariant extends AnalysisRule {
  static const LintCode code = LintCode(
    'base_style_after_variant',
    "The base style call '{0}' comes after the variant '{1}'.",
    correctionMessage:
        'Try moving the base style calls before the first variant.',
  );

  BaseStyleAfterVariant()
    : super(
        name: 'base_style_after_variant',
        description:
            'Do put base style calls before variants in a Styler chain.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addMethodInvocation(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (!isMixStylerType(node.staticType)) return;
    if (stylerCallKind(node) != .baseStyle) return;

    // Walk back through the chain. Structural calls such as animate() and
    // wrap() may sit anywhere, so skip them.
    var target = node.target;
    while (target is MethodInvocation && isMixStylerType(target.staticType)) {
      switch (stylerCallKind(target)) {
        case .variant:
        case .builder:
          rule.reportAtNode(
            node.methodName,
            arguments: [node.methodName.name, target.methodName.name],
          );

          return;
        case .baseStyle:
          // Only the first base call after a variant is reported.
          return;
        case .structural:
          target = target.target;
      }
    }
  }
}
