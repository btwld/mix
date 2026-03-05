import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

import '../rules/mix_prefer_dot_shorthands.dart';

/// Quick fix for [MixPreferDotShorthands]: replace `TypeName.member` with `.member`.
class MixPreferDotShorthandsFix extends CorrectionProducerWithDiagnostic {
  static const _fixKind = FixKind(
    'mix_prefer_dot_shorthands.useDotShorthand',
    DartFixKindPriority.standard,
    "Use dot shorthand",
  );

  MixPreferDotShorthandsFix({required super.context});

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = coveringNode;
    if (node == null) return;

    final SourceRange replacementRange;
    if (node is MethodInvocation) {
      replacementRange = range.startStart(node, node.methodName);
    } else if (node is PropertyAccess) {
      replacementRange = range.startStart(node, node.propertyName);
    } else if (node is PrefixedIdentifier) {
      replacementRange = range.startStart(node, node.identifier);
    } else if (node is InstanceCreationExpression) {
      final name = node.constructorName.name;
      if (name == null) return;
      replacementRange = range.startStart(node.constructorName, name);
    } else {
      return;
    }

    await builder.addDartFileEdit(file, (editBuilder) {
      editBuilder.addSimpleReplacement(replacementRange, '.');
    });
  }

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  FixKind get fixKind => _fixKind;
}
