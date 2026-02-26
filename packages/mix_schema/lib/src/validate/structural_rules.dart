import '../ast/schema_node.dart';
import '../ast/schema_values.dart';
import 'diagnostics.dart';

/// Structural validation rules (from executable plan §6.3).
///
/// Checks:
/// - Node type is a known AST node type
/// - Required fields present for each node type
/// - child vs children used correctly
/// - Value types are valid
class StructuralRules {
  const StructuralRules();

  List<SchemaDiagnostic> validate(SchemaNode node, [String path = 'root']) {
    final diagnostics = <SchemaDiagnostic>[];
    _validateNode(node, diagnostics, path);
    return diagnostics;
  }

  void _validateNode(
    SchemaNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    switch (node) {
      case TextNode():
        _validateTextNode(node, diagnostics, path);
      case ImageNode():
        _validateImageNode(node, diagnostics, path);
      case FlexNode():
        _validateFlexNode(node, diagnostics, path);
      case StackNode():
        _validateStackNode(node, diagnostics, path);
      case ScrollableNode():
        _validateScrollableNode(node, diagnostics, path);
      case WrapNode():
        _validateWrapNode(node, diagnostics, path);
      case PressableNode():
        _validatePressableNode(node, diagnostics, path);
      case InputNode():
        _validateInputNode(node, diagnostics, path);
      case RepeatNode():
        _validateRepeatNode(node, diagnostics, path);
      case BoxNode():
        _validateBoxNode(node, diagnostics, path);
      case IconNode():
        _validateIconNode(node, diagnostics, path);
    }
  }

  void _validateBoxNode(
    BoxNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    if (node.child != null) {
      _validateNode(node.child!, diagnostics, '$path.child');
    }
  }

  void _validateTextNode(
    TextNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    // Content is required and should be a string-producing value
    if (node.content case DirectValue(value: final v) when v == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.content',
          message: 'TextNode requires non-null content',
        ),
      );
    }
  }

  void _validateIconNode(
    IconNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    if (node.icon case DirectValue(value: final v) when v == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.icon',
          message: 'IconNode requires non-null icon',
        ),
      );
    }
  }

  void _validateImageNode(
    ImageNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    if (node.src case DirectValue(value: final v) when v == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: node.nodeId,
          path: '$path.src',
          message: 'ImageNode requires non-null src',
        ),
      );
    }
  }

  void _validateFlexNode(
    FlexNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    for (var i = 0; i < node.children.length; i++) {
      _validateNode(node.children[i], diagnostics, '$path.children[$i]');
    }
  }

  void _validateStackNode(
    StackNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    for (var i = 0; i < node.children.length; i++) {
      _validateNode(node.children[i], diagnostics, '$path.children[$i]');
    }
  }

  void _validateScrollableNode(
    ScrollableNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    _validateNode(node.child, diagnostics, '$path.child');
  }

  void _validateWrapNode(
    WrapNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    for (var i = 0; i < node.children.length; i++) {
      _validateNode(node.children[i], diagnostics, '$path.children[$i]');
    }
  }

  void _validatePressableNode(
    PressableNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    _validateNode(node.child, diagnostics, '$path.child');
  }

  void _validateInputNode(
    InputNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    final validTypes = {'text', 'toggle', 'slider', 'select', 'date'};
    if (!validTypes.contains(node.inputType)) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.invalidValueType,
          severity: DiagnosticSeverity.warning,
          nodeId: node.nodeId,
          path: '$path.inputType',
          message:
              'Unknown input type "${node.inputType}", expected one of: $validTypes',
        ),
      );
    }
  }

  void _validateRepeatNode(
    RepeatNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    // items should be a binding or direct list value
    if (node.items is DirectValue<String>) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.invalidValueType,
          severity: DiagnosticSeverity.warning,
          nodeId: node.nodeId,
          path: '$path.items',
          message:
              'RepeatNode items should be a BindingValue or DirectValue<List>, '
              'got a string direct value',
        ),
      );
    }
    _validateNode(node.template, diagnostics, '$path.template');
  }
}
