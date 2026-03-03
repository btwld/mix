import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

class MixVariantsLast extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_variants_last',
    'Variant methods must come after all base styling methods in a Styler chain.',
    correctionMessage:
        "Move variant calls (e.g. onHovered, onDark) to the end of the Styler chain.",
  );

  MixVariantsLast()
    : super(
        name: 'mix_variants_last',
        description:
            'Ensures variant methods (onHovered, onPressed, onDark, etc.) are placed '
            'at the end of Styler chains, after all base styling methods. '
            'Interleaving variants with base properties makes styles harder to read.',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addMethodInvocation(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Only look at method calls that return a MixStyler (part of a Styler chain).
    if (!isMixStylerType(node.staticType)) return;

    final methodName = node.methodName.name;

    // Variant methods themselves are fine — we report the non-variant that follows one.
    if (isVariantMethodName(methodName)) return;

    // This is a base (non-variant) method. Check if its direct target is a variant method.
    final target = node.target;
    if (target is MethodInvocation &&
        isVariantMethodName(target.methodName.name) &&
        isMixStylerType(target.staticType)) {
      rule.reportAtNode(node.methodName);
    }
  }
}
