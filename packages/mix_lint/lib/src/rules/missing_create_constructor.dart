import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/type_helpers.dart';

/// Reports a `@Mixable` or `@MixableStyler` class that has no `.create`
/// constructor while its generated `merge()` needs one.
class MissingCreateConstructor extends AnalysisRule {
  /// `GeneratedMixMethods.merge` from `package:mix_annotations`.
  static const mixableMergeFlag = 0x01;

  /// `GeneratedStylerMethods.merge` from `package:mix_annotations`.
  static const mixableStylerMergeFlag = 0x02;

  static const LintCode code = LintCode(
    'missing_create_constructor',
    "The class '{0}' is annotated with '@{1}' but has no '.create' "
        'constructor.',
    correctionMessage:
        "Try adding a 'const {0}.create(...)' constructor. The generated "
        'merge() method calls it.',
    severity: .WARNING,
  );

  MissingCreateConstructor()
    : super(
        name: 'missing_create_constructor',
        description:
            "Do add a '.create' constructor to classes annotated with "
            '@Mixable or @MixableStyler.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addClassDeclaration(this, _Visitor(this));
  }
}

/// A code-generation annotation whose generated `merge()` calls `.create`.
enum _GeneratorAnnotation {
  mixable('Mixable', mergeFlag: MissingCreateConstructor.mixableMergeFlag),
  mixableStyler(
    'MixableStyler',
    mergeFlag: MissingCreateConstructor.mixableStylerMergeFlag,
  );

  final String className;
  final int mergeFlag;

  const _GeneratorAnnotation(this.className, {required this.mergeFlag});
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  const _Visitor(this.rule);

  /// Returns the annotation kind when [annotation] asks the generator for a
  /// `merge()` method, or null otherwise.
  _GeneratorAnnotation? _annotationNeedingCreate(Annotation annotation) {
    final value = annotation.elementAnnotation?.computeConstantValue();
    final type = value?.type;
    if (value == null || type is! InterfaceType) return null;
    if (!isFromPackage(type.element, 'mix_annotations')) return null;

    for (final kind in _GeneratorAnnotation.values) {
      if (type.element.name != kind.className) continue;
      final methods = value.getField('methods')?.toIntValue();

      return methods == null || methods & kind.mergeFlag != 0 ? kind : null;
    }

    return null;
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final element = node.declaredFragment?.element;
    if (element == null || element.getNamedConstructor('create') != null) {
      return;
    }

    for (final annotation in node.metadata) {
      final kind = _annotationNeedingCreate(annotation);
      if (kind == null) continue;

      rule.reportAtToken(
        node.namePart.typeName,
        arguments: [node.namePart.typeName.lexeme, kind.className],
      );

      return;
    }
  }
}
