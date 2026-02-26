import '../ast/schema_node.dart';
import 'diagnostics.dart';

/// Semantic/a11y validation rules (from executable plan §6.3).
///
/// Checks:
/// - Interactive nodes must have a role in semantics
/// - PressableNode must have a semantic label
/// - ImageNode should have alt or semantic label (warning)
/// - Live regions must specify mode if present
class SemanticRules {
  const SemanticRules();

  List<SchemaDiagnostic> validate(SchemaNode root) {
    final diagnostics = <SchemaDiagnostic>[];
    _walk(root, diagnostics, 'root');
    return diagnostics;
  }

  void _walk(
    SchemaNode node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    switch (node) {
      case PressableNode():
        // Interactive nodes must have a role
        if (node.semantics?.role == null) {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.interactiveNodeMissingRole,
              severity: DiagnosticSeverity.warning,
              nodeId: node.nodeId,
              path: path,
              message: 'PressableNode should have a semantic role',
              suggestion: 'Add semantics.role = "button"',
            ),
          );
        }
        // Pressable must have a semantic label
        if (node.semantics?.label == null) {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.pressableMissingLabel,
              severity: DiagnosticSeverity.warning,
              nodeId: node.nodeId,
              path: path,
              message: 'PressableNode should have a semantic label',
              suggestion: 'Add semantics.label for accessibility',
            ),
          );
        }
        _walk(node.child, diagnostics, '$path.child');

      case InputNode():
        // Interactive nodes must have a role
        if (node.semantics?.role == null) {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.interactiveNodeMissingRole,
              severity: DiagnosticSeverity.warning,
              nodeId: node.nodeId,
              path: path,
              message: 'InputNode should have a semantic role',
              suggestion:
                  'Add semantics.role = "textField" or appropriate role',
            ),
          );
        }

      case ImageNode():
        // Image should have alt or semantic label
        if (node.alt == null && node.semantics?.label == null) {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.imageMissingAlt,
              severity: DiagnosticSeverity.warning,
              nodeId: node.nodeId,
              path: path,
              message:
                  'ImageNode should have alt text or semantic label',
              suggestion: 'Add alt or semantics.label for accessibility',
            ),
          );
        }

      case BoxNode(:final child):
        if (child != null) _walk(child, diagnostics, '$path.child');
      case FlexNode(:final children):
        for (var i = 0; i < children.length; i++) {
          _walk(children[i], diagnostics, '$path.children[$i]');
        }
      case StackNode(:final children):
        for (var i = 0; i < children.length; i++) {
          _walk(children[i], diagnostics, '$path.children[$i]');
        }
      case WrapNode(:final children):
        for (var i = 0; i < children.length; i++) {
          _walk(children[i], diagnostics, '$path.children[$i]');
        }
      case ScrollableNode(:final child):
        _walk(child, diagnostics, '$path.child');
      case RepeatNode(:final template):
        _walk(template, diagnostics, '$path.template');
      case TextNode():
      case IconNode():
        break; // Leaf nodes without special semantic rules
    }

    // Check live region consistency on any node
    if (node.semantics != null) {
      final sem = node.semantics!;
      if ((sem.liveRegionAtomic != null ||
              sem.liveRegionRelevant != null ||
              sem.liveRegionBusy != null) &&
          sem.liveRegionMode == null) {
        diagnostics.add(
          SchemaDiagnostic(
            code: DiagnosticCode.liveRegionMissingMode,
            severity: DiagnosticSeverity.warning,
            nodeId: node.nodeId,
            path: path,
            message:
                'Live region properties set but liveRegionMode is missing',
            suggestion: 'Add liveRegionMode = "polite" or "assertive"',
          ),
        );
      }
    }
  }
}
