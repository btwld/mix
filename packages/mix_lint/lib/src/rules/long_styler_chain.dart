import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../../config.dart';
import '../utils/styler_calls.dart';
import '../utils/type_helpers.dart';

/// Reports a Styler chain with more calls than [maxLength].
class LongStylerChain extends AnalysisRule {
  static const LintCode code = LintCode(
    'long_styler_chain',
    'This Styler chain has {0} calls, more than the limit of {1}.',
    correctionMessage:
        'Try splitting it into smaller Stylers and combining them with '
        'merge().',
  );

  /// The maximum number of calls allowed in one chain.
  final int maxLength;

  LongStylerChain({this.maxLength = MixLintConfig.defaultMaxStylerChainLength})
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
    registry.addInstanceCreationExpression(this, _Visitor(this, maxLength));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final int maxLength;

  const _Visitor(this.rule, this.maxLength);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixStylerType(node.staticType)) return;

    final length = collectDirectMethodChain(node).length;
    if (length > maxLength) {
      rule.reportAtNode(node, arguments: [length, maxLength]);
    }
  }
}
