import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

class MixMaxNumberOfAttributesPerStyle extends AnalysisRule {
  static const int defaultMaxNumber = 15;

  static const LintCode code = LintCode(
    'mix_max_number_of_attributes_per_style',
    'Styler chain has too many attributes.',
    correctionMessage:
        'Extract some attributes into separate Styler variables and compose them with merge().',
  );

  final int maxNumber;

  MixMaxNumberOfAttributesPerStyle({this.maxNumber = defaultMaxNumber})
    : super(
        name: 'mix_max_number_of_attributes_per_style',
        description:
            'Limits the number of method calls in a single Styler chain. '
            'Large styles are harder to read and maintain; '
            'prefer composing smaller Stylers with merge().',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, maxNumber);
    registry.addInstanceCreationExpression(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final int maxNumber;

  const _Visitor(this.rule, this.maxNumber);

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

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!isMixStylerType(node.staticType)) return;

    final chain = _collectChain(node);
    if (chain.length > maxNumber) {
      rule.reportAtNode(node);
    }
  }
}
