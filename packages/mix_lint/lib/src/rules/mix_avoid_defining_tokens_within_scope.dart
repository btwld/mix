import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

class MixAvoidDefiningTokensWithinScope extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_avoid_defining_tokens_within_scope',
    'MixToken instances should not be created directly inside MixScope constructors.',
    correctionMessage:
        'Define the token as a top-level or local constant and use it as a key in the scope map.',
  );

  MixAvoidDefiningTokensWithinScope()
    : super(
        name: 'mix_avoid_defining_tokens_within_scope',
        description:
            'Ensures MixToken instances are not created inline within MixScope. '
            'The scope maps existing tokens to values; creating tokens inline makes them '
            'unreferenceable elsewhere and can lead to duplication.',
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

    // Walk up the AST to find a MixScope ancestor.
    // Stop at statement/declaration boundaries.
    AstNode? current = node.parent;
    while (current != null &&
        current is! Statement &&
        current is! Declaration) {
      if (current is InstanceCreationExpression &&
          isMixScopeType(current.staticType)) {
        rule.reportAtNode(node);

        return;
      }
      current = current.parent;
    }
  }
}
