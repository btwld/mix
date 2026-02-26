import '../validate/diagnostics.dart';
import 'a2ui_v09_adapter.dart';
import 'wire_adapter.dart';

/// A2UI v0.8 stable compatibility adapter.
///
/// Reuses the v0.9 adapter logic, but:
/// - Handles v0.8-specific field names
/// - Emits lossyAdaptation diagnostics for deprecated/unsupported features
/// - Maps deprecated field locations to current positions
class A2uiV08Adapter implements WireAdapter {
  const A2uiV08Adapter();

  @override
  String get id => 'a2ui_v0_8_stable';

  @override
  List<String> get supportedVersions => const ['0.8'];

  @override
  AdaptResult adapt(Object wirePayload, AdaptContext context) {
    if (wirePayload is! Map<String, dynamic>) {
      return const AdaptResult(
        diagnostics: [
          SchemaDiagnostic(
            code: DiagnosticCode.invalidValueType,
            severity: DiagnosticSeverity.error,
            message: 'Wire payload must be a Map<String, dynamic>',
          ),
        ],
      );
    }

    final diagnostics = <SchemaDiagnostic>[];

    // Normalize v0.8 payload to v0.9 shape
    final normalized = _normalizeV08ToV09(
      Map<String, dynamic>.from(wirePayload),
      diagnostics,
    );

    // Delegate to v0.9 adapter
    final v09 = const A2uiV09Adapter();
    final result = v09.adapt(normalized, context);

    // Combine diagnostics
    return AdaptResult(
      root: result.root,
      diagnostics: [...diagnostics, ...result.diagnostics],
    );
  }

  Map<String, dynamic> _normalizeV08ToV09(
    Map<String, dynamic> payload,
    List<SchemaDiagnostic> diagnostics,
  ) {
    // v0.8 uses "schema_version" instead of "version"
    if (payload.containsKey('schema_version') &&
        !payload.containsKey('version')) {
      payload['version'] = payload.remove('schema_version');
      diagnostics.add(
        const SchemaDiagnostic(
          code: DiagnosticCode.lossyAdaptation,
          severity: DiagnosticSeverity.info,
          message:
              'Mapped v0.8 "schema_version" to v0.9 "version"',
        ),
      );
    }

    // v0.8 uses "ui" instead of "root" for the root node
    if (payload.containsKey('ui') && !payload.containsKey('root')) {
      payload['root'] = payload.remove('ui');
      diagnostics.add(
        const SchemaDiagnostic(
          code: DiagnosticCode.lossyAdaptation,
          severity: DiagnosticSeverity.info,
          message: 'Mapped v0.8 "ui" to v0.9 "root"',
        ),
      );
    }

    // v0.8 uses "trust_level" instead of "trust"
    if (payload.containsKey('trust_level') &&
        !payload.containsKey('trust')) {
      payload['trust'] = payload.remove('trust_level');
      diagnostics.add(
        const SchemaDiagnostic(
          code: DiagnosticCode.lossyAdaptation,
          severity: DiagnosticSeverity.info,
          message: 'Mapped v0.8 "trust_level" to v0.9 "trust"',
        ),
      );
    }

    // Recursively normalize nodes
    if (payload['root'] is Map<String, dynamic>) {
      _normalizeNode(
          payload['root'] as Map<String, dynamic>, diagnostics, 'root');
    }

    // Override version to 0.9 for downstream processing
    payload['version'] = '0.9';

    return payload;
  }

  void _normalizeNode(
    Map<String, dynamic> node,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    // v0.8 uses "node_id" instead of "nodeId"
    if (node.containsKey('node_id') && !node.containsKey('nodeId')) {
      node['nodeId'] = node.remove('node_id');
    }

    // v0.8 uses "styles" (plural) instead of "style"
    if (node.containsKey('styles') && !node.containsKey('style')) {
      node['style'] = node.remove('styles');
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.lossyAdaptation,
          severity: DiagnosticSeverity.info,
          path: path,
          message: 'Mapped v0.8 "styles" to v0.9 "style"',
        ),
      );
    }

    // v0.8 uses "a11y" instead of "semantics"
    if (node.containsKey('a11y') && !node.containsKey('semantics')) {
      node['semantics'] = node.remove('a11y');
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.lossyAdaptation,
          severity: DiagnosticSeverity.info,
          path: path,
          message: 'Mapped v0.8 "a11y" to v0.9 "semantics"',
        ),
      );
    }

    // Recursively normalize child/children
    if (node['child'] is Map<String, dynamic>) {
      _normalizeNode(
          node['child'] as Map<String, dynamic>, diagnostics, '$path.child');
    }
    if (node['children'] is List) {
      final children = node['children'] as List;
      for (var i = 0; i < children.length; i++) {
        if (children[i] is Map<String, dynamic>) {
          _normalizeNode(children[i] as Map<String, dynamic>, diagnostics,
              '$path.children[$i]');
        }
      }
    }
    if (node['template'] is Map<String, dynamic>) {
      _normalizeNode(node['template'] as Map<String, dynamic>, diagnostics,
          '$path.template');
    }
  }
}
