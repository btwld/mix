import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

class MixPreferDotShorthands extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_prefer_dot_shorthands',
    'Prefer dot shorthands when the type is inferred from context.',
    correctionMessage:
        "Use the dot shorthand (e.g. .all(10), .w600, .color(...)) instead of the full type name.",
  );

  MixPreferDotShorthands()
    : super(
        name: code.lowerCaseName,
        description:
            'Prefers using dot shorthands (e.g. .all(10) instead of '
            'EdgeInsetsGeometryMix.all(10), .w600 instead of FontWeight.w600, '
            '.color(Colors.red) instead of TextStyler.color(Colors.red)) when '
            'the type is inferred from context.',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addMethodInvocation(this, visitor);
    registry.addPropertyAccess(this, visitor);
    registry.addPrefixedIdentifier(this, visitor);
    registry.addInstanceCreationExpression(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  bool _isPartOfStylerDeclaration(AstNode node) {
    final parent = node.parent;
    if (parent is! ArgumentList) return false;
    final grandparent = parent.parent;
    if (grandparent is! MethodInvocation) return false;

    return isMixStylerType(grandparent.staticType);
  }

  /// True when [target] looks like a type name (Identifier or PrefixedIdentifier
  /// whose name starts with an uppercase letter).
  bool _isTypeLikeTarget(Expression? target) {
    if (target == null) return false;

    if (target is SimpleIdentifier) {
      return target.name.isNotEmpty;
    }

    if (target is PrefixedIdentifier) {
      return target.identifier.name.isNotEmpty;
    }

    return false;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (!_isPartOfStylerDeclaration(node)) return;
    if (!_isTypeLikeTarget(node.target)) return;

    rule.reportAtNode(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (!_isPartOfStylerDeclaration(node)) return;
    if (!_isTypeLikeTarget(node.target)) return;

    rule.reportAtNode(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (!_isPartOfStylerDeclaration(node)) return;

    final name = node.prefix.name;
    if (name.isEmpty || name[0] != name[0].toUpperCase()) return;

    rule.reportAtNode(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!_isPartOfStylerDeclaration(node)) return;

    final type = node.constructorName.type;
    final token = type.name;
    if (token.lexeme.isEmpty ||
        token.lexeme[0] != token.lexeme[0].toUpperCase()) {
      return;
    }

    rule.reportAtNode(node);
  }
}
