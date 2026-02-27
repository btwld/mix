import '../ast/schema_node.dart';
import '../ast/schema_values.dart';
import 'diagnostics.dart';

/// Structural validation rules.
///
/// Checks: required fields present, child/children used correctly,
/// value types valid. Uses a generic tree walker instead of per-node methods.
class StructuralRules {
  const StructuralRules();

  static const _validInputTypes = {'text', 'toggle', 'slider', 'select', 'date'};

  List<SchemaDiagnostic> validate(SchemaNode node, [String path = 'root']) {
    final diagnostics = <SchemaDiagnostic>[];
    _walk(node, diagnostics, path);
    return diagnostics;
  }

  void _walk(SchemaNode node, List<SchemaDiagnostic> diags, String path) {
    // Required-field checks and node-specific validation.
    switch (node) {
      case TextNode() when node.content is DirectValue && (node.content as DirectValue).value == null:
        diags.add(SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.content',
          message: 'TextNode requires non-null content',
        ));
      case IconNode() when node.icon is DirectValue && (node.icon as DirectValue).value == null:
        diags.add(SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.icon',
          message: 'IconNode requires non-null icon',
        ));
      case ImageNode() when node.src is DirectValue && (node.src as DirectValue).value == null:
        diags.add(SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.src',
          message: 'ImageNode requires non-null src',
        ));
      case InputNode() when !_validInputTypes.contains(node.inputType):
        diags.add(SchemaDiagnostic(
          code: DiagnosticCode.invalidValueType,
          severity: DiagnosticSeverity.warning,
          nodeId: node.nodeId,
          path: '$path.inputType',
          message:
              'Unknown input type "${node.inputType}", expected one of: $_validInputTypes',
        ));
      case RepeatNode() when node.items is DirectValue<String>:
        diags.add(SchemaDiagnostic(
          code: DiagnosticCode.invalidValueType,
          severity: DiagnosticSeverity.warning,
          nodeId: node.nodeId,
          path: '$path.items',
          message:
              'RepeatNode items should be a BindingValue or DirectValue<List>, '
              'got a string direct value',
        ));
      default:
        break;
    }

    // Recurse into children.
    final children = _childrenOf(node);
    for (var i = 0; i < children.length; i++) {
      _walk(children[i], diags, _childPath(node, path, i));
    }
  }

  /// Extract all child nodes from any node type.
  static List<SchemaNode> _childrenOf(SchemaNode node) => switch (node) {
        BoxNode(child: final c) => c != null ? [c] : const [],
        FlexNode(children: final cs) => cs,
        StackNode(children: final cs) => cs,
        WrapNode(children: final cs) => cs,
        ScrollableNode(child: final c) => [c],
        PressableNode(child: final c) => [c],
        RepeatNode(template: final t) => [t],
        TextNode() => const [],
        IconNode() => const [],
        ImageNode() => const [],
        InputNode() => const [],
      };

  /// Build the path string for a child.
  static String _childPath(SchemaNode parent, String path, int index) =>
      switch (parent) {
        BoxNode() => '$path.child',
        ScrollableNode() => '$path.child',
        PressableNode() => '$path.child',
        RepeatNode() => '$path.template',
        _ => '$path.children[$index]',
      };
}
