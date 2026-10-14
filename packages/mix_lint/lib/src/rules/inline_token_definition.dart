import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// A rule that reports a design token created inside a Styler chain or a
/// `MixScope`.
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
    final visitor = _Visitor(this);
    registry
      ..addDotShorthandConstructorInvocation(this, visitor)
      ..addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final MultiAnalysisRule rule;

  const _Visitor(this.rule);

  /// Whether [node] creates a `MixScope`.
  bool _isMixScopeCall(AstNode node) => switch (node) {
    InstanceCreationExpression() || DotShorthandConstructorInvocation() =>
      isMixScopeType((node as Expression).staticType),
    // MixScope.inherit(), MixScope.withMaterial(), and similar.
    MethodInvocation() => isMixClass(
      node.methodName.element?.enclosingElement,
      'MixScope',
    ),
    _ => false,
  };

  void _check(Expression node) {
    if (!isMixTokenType(node.staticType)) return;

    // The argument of the innermost call that the walk has passed through.
    Argument? argument;
    AstNode previous = node;
    for (final ancestor in ancestorsBeforeStatementOrDeclaration(node)) {
      if (ancestor is ArgumentList && previous is Argument) {
        argument = previous;
      }
      if (isStylerCall(ancestor)) {
        rule.reportAtNode(node, diagnosticCode: InlineTokenDefinition.inStyler);

        return;
      }
      if (_isMixScopeCall(ancestor)) {
        // Only the token maps define tokens. A token under `child:` belongs
        // to the widget tree below the scope.
        if (argument?.correspondingParameter?.type.isDartCoreMap ?? false) {
          rule.reportAtNode(
            node,
            diagnosticCode: InlineTokenDefinition.inScope,
          );
        }

        return;
      }
      previous = ancestor;
    }
  }

  @override
  void visitDotShorthandConstructorInvocation(
    DotShorthandConstructorInvocation node,
  ) => _check(node);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) =>
      _check(node);
}
