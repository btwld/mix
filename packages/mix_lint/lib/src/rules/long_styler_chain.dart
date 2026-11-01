import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../config.dart';
import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// A rule that reports a Styler chain with more calls than `max_calls`.
///
/// It reads `max_calls` from the `mix_lint:` section of
/// `analysis_options.yaml`.
class LongStylerChain extends AnalysisRule {
  static const LintCode code = LintCode(
    'long_styler_chain',
    'This Styler chain has {0} calls, more than the limit of {1}.',
    correctionMessage:
        'Try splitting it into smaller Stylers and combining them with '
        "'merge()'.",
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

    // A factory root, such as `.color(...)`, is a call too.
    final length =
        collectDirectMethodChain(root).length +
        (rootFactoryName(root) == null ? 0 : 1);
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
