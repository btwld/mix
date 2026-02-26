import '../ast/schema_node.dart';
import '../trust/capability_matrix.dart';
import '../trust/schema_trust.dart';
import 'diagnostics.dart';

/// Trust-based validation rules (from executable plan §6.3).
///
/// Checks:
/// - Tree depth ≤ trust limit
/// - Total node count ≤ trust limit
/// - Animation complexity ≤ trust limit
class TrustRules {
  const TrustRules();

  List<SchemaDiagnostic> validate(
    SchemaNode root,
    SchemaTrust trust, {
    int? maxDepthOverride,
    int? maxNodeCountOverride,
  }) {
    final caps = TrustCapabilities.forTrust(trust);
    final maxDepth = maxDepthOverride ?? caps.maxDepth;
    final maxNodeCount = maxNodeCountOverride ?? caps.maxNodeCount;
    final maxAnimated = caps.maxAnimatedNodes;

    final diagnostics = <SchemaDiagnostic>[];
    var nodeCount = 0;
    var animatedCount = 0;

    void walk(SchemaNode node, int depth) {
      nodeCount++;

      if (depth > maxDepth) {
        diagnostics.add(
          SchemaDiagnostic(
            code: DiagnosticCode.depthLimitExceeded,
            severity: DiagnosticSeverity.error,
            nodeId: node.nodeId,
            message: 'Tree depth $depth exceeds limit $maxDepth '
                'for trust level ${trust.name}',
          ),
        );
        return; // Don't continue walking deeper
      }

      if (nodeCount > maxNodeCount) {
        diagnostics.add(
          SchemaDiagnostic(
            code: DiagnosticCode.nodeCountExceeded,
            severity: DiagnosticSeverity.error,
            nodeId: node.nodeId,
            message: 'Node count $nodeCount exceeds limit $maxNodeCount '
                'for trust level ${trust.name}',
          ),
        );
        return;
      }

      if (node.animation != null) {
        animatedCount++;
        if (animatedCount > maxAnimated) {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.animationComplexityExceeded,
              severity: DiagnosticSeverity.warning,
              nodeId: node.nodeId,
              message:
                  'Animated node count $animatedCount exceeds limit $maxAnimated '
                  'for trust level ${trust.name}',
            ),
          );
        }
      }

      // Recurse into children
      switch (node) {
        case BoxNode(:final child):
          if (child != null) walk(child, depth + 1);
        case FlexNode(:final children):
          for (final child in children) {
            walk(child, depth + 1);
          }
        case StackNode(:final children):
          for (final child in children) {
            walk(child, depth + 1);
          }
        case WrapNode(:final children):
          for (final child in children) {
            walk(child, depth + 1);
          }
        case ScrollableNode(:final child):
          walk(child, depth + 1);
        case PressableNode(:final child):
          walk(child, depth + 1);
        case RepeatNode(:final template):
          walk(template, depth + 1);
        case TextNode():
        case IconNode():
        case ImageNode():
        case InputNode():
          break; // Leaf nodes
      }
    }

    walk(root, 1);

    return diagnostics;
  }
}
