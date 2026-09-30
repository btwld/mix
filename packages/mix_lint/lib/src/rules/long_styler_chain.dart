import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../config.dart';
import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// Reports a Styler chain with more calls than the limit.
///
/// The limit is [defaultMaxCalls] unless the project's
/// `analysis_options.yaml` sets another positive number:
///
/// ```yaml
/// mix_lint:
///   long_styler_chain:
///     max_calls: 20
/// ```
class LongStylerChain extends AnalysisRule {
  static const LintCode code = LintCode(
    'long_styler_chain',
    'This Styler chain has {0} calls, more than the limit of {1}.',
    correctionMessage:
        'Try splitting it into smaller Stylers and combining them with '
        'merge().',
  );

  /// The limit when `max_calls` is missing, or is not a positive integer.
  static const defaultMaxCalls = 15;

  LongStylerChain()
    : super(
        name: 'long_styler_chain',
        description:
            'Avoid long Styler chains. Compose smaller Stylers with merge().',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final maxCalls = switch (RuleOptions.forRule(
      context.definingUnit.file,
      name,
    )?['max_calls']) {
      final int value when value > 0 => value,
      _ => defaultMaxCalls,
    };
    final visitor = _Visitor(this, maxCalls);
    registry
      ..addDotShorthandConstructorInvocation(this, visitor)
      ..addDotShorthandInvocation(this, visitor)
      ..addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final int maxCalls;

  const _Visitor(this.rule, this.maxCalls);

  void _check(Expression root) {
    if (!isMixStylerType(root.staticType)) return;

    final length = collectDirectMethodChain(root).length;
    if (length > maxCalls) {
      rule.reportAtNode(root, arguments: [length, maxCalls]);
    }
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
