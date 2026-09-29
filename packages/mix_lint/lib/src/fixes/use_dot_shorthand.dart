import 'package:analysis_server_plugin/edit/change_builder/change_builder.dart';
import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analysis_server_plugin/edit/fix/fix.dart';
import 'package:analysis_server_plugin/edit/range_factory.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';

/// Quick fix for `unnecessary_type_name` and `unnecessary_styler_constructor`:
/// replaces `TypeName.member(...)`, `BoxStyler().member(...)`, or
/// `.new().member(...)` with `.member(...)`.
class UseDotShorthand extends ResolvedCorrectionProducer {
  static const _fixKind = FixKind(
    'mix_lint.fix.useDotShorthand',
    DartFixKindPriority.standard,
    'Use dot shorthand',
  );

  static const _multiFixKind = FixKind(
    'mix_lint.fix.useDotShorthand.multi',
    DartFixKindPriority.inFile,
    'Use dot shorthands everywhere in file',
  );

  UseDotShorthand({required super.context});

  @override
  CorrectionApplicability get applicability => .acrossSingleFile;

  @override
  FixKind get fixKind => _fixKind;

  @override
  FixKind get multiFixKind => _multiFixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final diagnosticNode = coveringNode;
    if (diagnosticNode == null) return;
    final replacementRange = _typeNameRange(diagnosticNode);
    if (replacementRange == null) return;

    await builder.addDartFileEdit(file, (editBuilder) {
      editBuilder.addSimpleReplacement(replacementRange, '.');
    });
  }

  /// Returns the range of `TypeName.` (including any import prefix) in
  /// [node], or null when [node] is not a fixable shape.
  SourceRange? _typeNameRange(AstNode node) => switch (node) {
    MethodInvocation() => range.startStart(node, node.methodName),
    PropertyAccess() => range.startStart(node, node.propertyName),
    PrefixedIdentifier() => range.startStart(node, node.identifier),
    InstanceCreationExpression(:final constructorName) =>
      constructorName.name == null
          ? null
          : range.startStart(constructorName, constructorName.name!),
    _ => null,
  };
}
