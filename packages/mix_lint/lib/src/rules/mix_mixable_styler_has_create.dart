import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class MixMixableStylerHasCreate extends AnalysisRule {
  static const LintCode code = LintCode(
    'mix_mixable_styler_has_create',
    "Classes annotated with @MixableStyler must define a named constructor '.create'.",
    correctionMessage:
        "Add 'const MyStyler.create({...})' to the class. "
        "The Mix framework expects this constructor for const instantiation and merging.",
  );

  MixMixableStylerHasCreate()
    : super(
        name: 'mix_mixable_styler_has_create',
        description:
            'Ensures every class annotated with @MixableStyler defines a .create '
            'named constructor. The generated mixin and the rest of the Mix API '
            'rely on this constructor for const instantiation, merging, and default styles.',
      );

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addClassDeclaration(this, visitor);
  }

  @override
  LintCode get diagnosticCode => code;
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  bool _isMixableStylerAnnotation(Annotation annotation) {
    // Use toSource() on the name to handle both simple and prefixed identifiers.
    final nameSource = annotation.name.toSource();
    final baseName = nameSource.contains('.')
        ? nameSource.split('.').last
        : nameSource;

    return baseName == 'MixableStyler';
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final hasMixableStyler = node.metadata.any(_isMixableStylerAnnotation);
    if (!hasMixableStyler) return;

    final body = node.body;
    final hasCreateConstructor =
        body is BlockClassBody &&
        body.members.any((member) {
          return member is ConstructorDeclaration &&
              member.name?.lexeme == 'create';
        });

    if (!hasCreateConstructor) {
      rule.reportAtNode(node.namePart);
    }
  }
}
