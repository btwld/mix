import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// Reports a design token created inside a Styler chain or a `MixScope`.
class InlineTokenDefinition extends MultiAnalysisRule {
  static const LintCode inStyler = LintCode(
    'inline_token_definition',
    'A design token is created inside a Styler chain.',
    correctionMessage:
        'Try defining the token once, outside the style, and referencing it.',
    uniqueName: 'LintCode.inline_token_definition_in_styler',
  );

  static const LintCode inScope = LintCode(
    'inline_token_definition',
    'A design token is created inside a MixScope.',
    correctionMessage:
        'Try defining the token once, outside the scope, and using it as the '
        'map key.',
    uniqueName: 'LintCode.inline_token_definition_in_scope',
  );

  InlineTokenDefinition()
    : super(
        name: 'inline_token_definition',
        description:
            'Avoid creating design tokens inside Styler chains and MixScope. '
            'Define each token once so it can be shared.',
      );

  @override
  List<DiagnosticCode> get diagnosticCodes => [inStyler, inScope];

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final MultiAnalysisRule rule;

  const _Visitor(this.rule);

  bool _isStylerCall(AstNode node) =>
      (node is MethodInvocation || node is InstanceCreationExpression) &&
      isMixStylerType((node as Expression).staticType);

  bool _isMixScopeCall(AstNode node) => switch (node) {
    InstanceCreationExpression() => isMixScopeType(node.staticType),
    // MixScope.inherit(), MixScope.withMaterial(), and similar.
    MethodInvocation() => isMixClass(
      node.methodName.element?.enclosingElement,
      'MixScope',
    ),
    _ => false,
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixTokenType(node.staticType)) return;

    for (final ancestor in ancestorsBeforeStatementOrDeclaration(node)) {
      if (_isStylerCall(ancestor)) {
        rule.reportAtNode(node, diagnosticCode: InlineTokenDefinition.inStyler);

        return;
      }
      if (_isMixScopeCall(ancestor)) {
        rule.reportAtNode(node, diagnosticCode: InlineTokenDefinition.inScope);

        return;
      }
    }
  }
}
