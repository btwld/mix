import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/ast_helpers.dart';
import '../utils/type_helpers.dart';

class MixAvoidDefiningTokensWithinStyle extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_avoid_defining_tokens_within_style',
    'MixToken instances should not be created directly inside Styler method calls.',
    correctionMessage:
        'Define the token outside the style as a top-level or local constant, then pass it in.',
  );

  MixAvoidDefiningTokensWithinStyle()
    : super(
        name: 'mix_avoid_defining_tokens_within_style',
        description:
            'Ensures MixToken instances are not created inline within Styler method chains. '
            'Tokens are meant to be shared; creating them inline makes them local and hard to reuse.',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addInstanceCreationExpression(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixTokenType(node.staticType)) return;

    for (final ancestor in ancestorsBeforeStatementOrDeclaration(node)) {
      if (ancestor is MethodInvocation &&
          isMixStylerType(ancestor.staticType)) {
        rule.reportAtNode(node);

        return;
      }
      if (ancestor is InstanceCreationExpression &&
          isMixStylerType(ancestor.staticType)) {
        rule.reportAtNode(node);

        return;
      }
    }
  }
}
