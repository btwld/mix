import '../ast/schema_node.dart';
import '../ast/schema_semantics.dart';
import '../ast/schema_values.dart';
import '../ast/ui_schema_root.dart';
import '../trust/schema_trust.dart';
import '../validate/diagnostics.dart';
import 'wire_adapter.dart';

/// Known token type prefixes for shorthand detection.
const _tokenTypes = {
  'color',
  'space',
  'radius',
  'textStyle',
  'borderSide',
  'shadow',
  'boxShadow',
  'fontWeight',
  'duration',
  'breakpoint',
  'double',
};

bool _isTokenType(String prefix) => _tokenTypes.contains(prefix);

/// A2UI v0.9 draft adapter — primary adapter for mix_schema.
///
/// Implementation approach (from executable plan §5.2):
/// 1. Parse JSON Map<String, dynamic> wire payload
/// 2. Extract envelope: id, version, trust, root
/// 3. Walk root node tree recursively
/// 4. Emit lossy-mapping diagnostics
/// 5. Return UiSchemaRoot
class A2uiV09Adapter implements WireAdapter {
  const A2uiV09Adapter();

  @override
  String get id => 'a2ui_v0_9_draft_latest';

  @override
  List<String> get supportedVersions => const ['0.9'];

  @override
  AdaptResult adapt(Object wirePayload, AdaptContext context) {
    final diagnostics = <SchemaDiagnostic>[];

    if (wirePayload is! Map<String, dynamic>) {
      return AdaptResult(
        diagnostics: [
          const SchemaDiagnostic(
            code: DiagnosticCode.invalidValueType,
            severity: DiagnosticSeverity.error,
            message: 'Wire payload must be a Map<String, dynamic>',
          ),
        ],
      );
    }

    final payload = wirePayload;

    // Extract envelope
    final schemaId = payload['id'] as String? ?? 'unknown';
    final version = payload['version'] as String? ?? '0.9';
    final trustStr = payload['trust'] as String? ?? 'standard';
    final trust = _parseTrust(trustStr);

    // Check version compatibility
    if (version != '0.9') {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.unsupportedWireVersion,
          severity: DiagnosticSeverity.warning,
          message: 'Expected wire version 0.9, got $version',
          suggestion: 'Use the appropriate adapter for version $version',
        ),
      );
    }

    // Parse root node
    final rootData = payload['root'];
    if (rootData is! Map<String, dynamic>) {
      return AdaptResult(
        diagnostics: [
          const SchemaDiagnostic(
            code: DiagnosticCode.missingRequiredField,
            severity: DiagnosticSeverity.error,
            message: 'Wire payload missing "root" field',
          ),
          ...diagnostics,
        ],
      );
    }

    final rootNode = _adaptNode(rootData, diagnostics, 'root');
    if (rootNode == null) {
      return AdaptResult(diagnostics: diagnostics);
    }

    // Extract environment
    final envData = payload['environment'] as Map<String, dynamic>?;
    SchemaEnvironment? environment;
    if (envData != null) {
      environment = SchemaEnvironment(
        data: envData['data'] as Map<String, dynamic>?,
        state: envData['state'] as Map<String, dynamic>?,
        breakpoints: (envData['breakpoints'] as List?)?.cast<String>(),
      );
    }

    final root = UiSchemaRoot(
      id: schemaId,
      schemaVersion: '0.1',
      root: rootNode,
      trust: trust,
      environment: environment,
    );

    return AdaptResult(root: root, diagnostics: diagnostics);
  }

  SchemaNode? _adaptNode(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    final type = data['type'] as String?;
    final nodeId = data['nodeId'] as String? ?? '${path}_auto';
    final style = _adaptStyle(data['style'], diagnostics, '$path.style');
    final semantics = _adaptSemantics(data['semantics']);
    final animation = _adaptAnimation(data['animation']);
    final variants = _adaptVariants(data['variants'], diagnostics, '$path.variants');

    return switch (type) {
      'box' => BoxNode(
          nodeId: nodeId,
          child: _adaptChild(data, diagnostics, path),
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'text' => TextNode(
          nodeId: nodeId,
          content: _normalizeValue(data['content'] ?? ''),
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'icon' => IconNode(
          nodeId: nodeId,
          icon: _normalizeValue(data['icon'] ?? ''),
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'image' => ImageNode(
          nodeId: nodeId,
          src: _normalizeValue(data['src'] ?? ''),
          alt: data['alt'] as String?,
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'flex' => FlexNode(
          nodeId: nodeId,
          children: _adaptChildren(data, diagnostics, path),
          direction: data['direction'] != null
              ? _normalizeValue(data['direction'])
              : null,
          spacing:
              data['spacing'] != null ? _normalizeValue(data['spacing']) : null,
          crossAxisAlignment: data['crossAxisAlignment'] != null
              ? _normalizeValue(data['crossAxisAlignment'])
              : null,
          mainAxisAlignment: data['mainAxisAlignment'] != null
              ? _normalizeValue(data['mainAxisAlignment'])
              : null,
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'stack' => StackNode(
          nodeId: nodeId,
          children: _adaptChildren(data, diagnostics, path),
          alignment: data['alignment'] != null
              ? _normalizeValue(data['alignment'])
              : null,
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'scrollable' => _adaptScrollable(data, diagnostics, path, nodeId,
          semantics, style, animation, variants),
      'wrap' => WrapNode(
          nodeId: nodeId,
          children: _adaptChildren(data, diagnostics, path),
          spacing:
              data['spacing'] != null ? _normalizeValue(data['spacing']) : null,
          runSpacing: data['runSpacing'] != null
              ? _normalizeValue(data['runSpacing'])
              : null,
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'pressable' => _adaptPressable(data, diagnostics, path, nodeId,
          semantics, style, animation, variants),
      'input' => InputNode(
          nodeId: nodeId,
          inputType: data['inputType'] as String? ?? 'text',
          fieldId: data['fieldId'] as String? ?? nodeId,
          label:
              data['label'] != null ? _normalizeValue(data['label']) : null,
          hint: data['hint'] != null ? _normalizeValue(data['hint']) : null,
          value:
              data['value'] != null ? _normalizeValue(data['value']) : null,
          inputProps: _adaptStyle(
              data['inputProps'], diagnostics, '$path.inputProps'),
          semantics: semantics,
          style: style,
          animation: animation,
          variants: variants,
        ),
      'repeat' => _adaptRepeat(data, diagnostics, path, nodeId, semantics,
          style, animation, variants),
      null => () {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.missingRequiredField,
              severity: DiagnosticSeverity.error,
              nodeId: nodeId,
              path: path,
              message: 'Node missing required "type" field',
            ),
          );
          return null;
        }(),
      _ => () {
          diagnostics.add(
            SchemaDiagnostic(
              code: DiagnosticCode.unknownNodeType,
              severity: DiagnosticSeverity.error,
              nodeId: nodeId,
              path: path,
              message: 'Unknown node type "$type"',
              suggestion:
                  'Supported types: box, text, icon, image, flex, stack, '
                  'scrollable, wrap, pressable, input, repeat',
            ),
          );
          return null;
        }(),
    };
  }

  SchemaNode? _adaptScrollable(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
    String nodeId,
    SchemaSemantics? semantics,
    Map<String, SchemaValue>? style,
    SchemaAnimation? animation,
    Map<String, SchemaValue>? variants,
  ) {
    final childNode = _adaptChild(data, diagnostics, path);
    if (childNode == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: nodeId,
          path: path,
          message: 'scrollable node requires a "child"',
        ),
      );
      return null;
    }
    return ScrollableNode(
      nodeId: nodeId,
      child: childNode,
      direction: data['direction'] != null
          ? _normalizeValue(data['direction'])
          : null,
      semantics: semantics,
      style: style,
      animation: animation,
      variants: variants,
    );
  }

  SchemaNode? _adaptPressable(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
    String nodeId,
    SchemaSemantics? semantics,
    Map<String, SchemaValue>? style,
    SchemaAnimation? animation,
    Map<String, SchemaValue>? variants,
  ) {
    final childNode = _adaptChild(data, diagnostics, path);
    if (childNode == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: nodeId,
          path: path,
          message: 'pressable node requires a "child"',
        ),
      );
      return null;
    }
    return PressableNode(
      nodeId: nodeId,
      child: childNode,
      actionId: data['actionId'] as String?,
      semantics: semantics,
      style: style,
      animation: animation,
      variants: variants,
    );
  }

  SchemaNode? _adaptRepeat(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
    String nodeId,
    SchemaSemantics? semantics,
    Map<String, SchemaValue>? style,
    SchemaAnimation? animation,
    Map<String, SchemaValue>? variants,
  ) {
    final items = data['items'];
    final templateData = data['template'] as Map<String, dynamic>?;

    if (items == null || templateData == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.missingRequiredField,
          severity: DiagnosticSeverity.error,
          nodeId: nodeId,
          path: path,
          message: 'repeat node requires "items" and "template" fields',
        ),
      );
      return null;
    }

    final templateNode =
        _adaptNode(templateData, diagnostics, '$path.template');
    if (templateNode == null) return null;

    return RepeatNode(
      nodeId: nodeId,
      items: _normalizeValue(items),
      template: templateNode,
      itemAlias: data['itemAlias'] as String? ?? 'item',
      semantics: semantics,
      style: style,
      animation: animation,
      variants: variants,
    );
  }

  SchemaNode? _adaptChild(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    final childData = data['child'] as Map<String, dynamic>?;
    if (childData == null) return null;
    return _adaptNode(childData, diagnostics, '$path.child');
  }

  List<SchemaNode> _adaptChildren(
    Map<String, dynamic> data,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    final childrenData = data['children'] as List?;
    if (childrenData == null) return const [];

    final children = <SchemaNode>[];
    for (var i = 0; i < childrenData.length; i++) {
      final childData = childrenData[i];
      if (childData is Map<String, dynamic>) {
        final node = _adaptNode(childData, diagnostics, '$path.children[$i]');
        if (node != null) children.add(node);
      }
    }
    return children;
  }

  Map<String, SchemaValue>? _adaptStyle(
    dynamic styleData,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    if (styleData is! Map<String, dynamic>) return null;

    final style = <String, SchemaValue>{};
    for (final entry in styleData.entries) {
      style[entry.key] = _normalizeValue(entry.value);
    }
    return style.isEmpty ? null : style;
  }

  Map<String, SchemaValue>? _adaptVariants(
    dynamic variantsData,
    List<SchemaDiagnostic> diagnostics,
    String path,
  ) {
    if (variantsData is! Map<String, dynamic>) return null;

    final variants = <String, SchemaValue>{};
    for (final entry in variantsData.entries) {
      if (entry.value is Map<String, dynamic>) {
        // Variant block: convert inner style map to SchemaValue map,
        // then wrap as DirectValue<Map<String, SchemaValue>>
        final innerStyle =
            _adaptStyle(entry.value, diagnostics, '$path.${entry.key}');
        if (innerStyle != null) {
          variants[entry.key] = DirectValue<Map<String, SchemaValue>>(innerStyle);
        }
      }
    }
    return variants.isEmpty ? null : variants;
  }

  SchemaSemantics? _adaptSemantics(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    return SchemaSemantics(
      role: data['role'] as String?,
      label: data['label'] as String?,
      hint: data['hint'] as String?,
      value: data['value'] as String?,
      enabled: data['enabled'] as bool?,
      selected: data['selected'] as bool?,
      checked: data['checked'] as bool?,
      expanded: data['expanded'] as bool?,
      focusOrder: data['focusOrder'] as int?,
      labelledBy: data['labelledBy'] as String?,
      describedBy: data['describedBy'] as String?,
      liveRegionMode: data['liveRegionMode'] as String?,
      liveRegionAtomic: data['liveRegionAtomic'] as bool?,
      liveRegionRelevant: data['liveRegionRelevant'] as String?,
      liveRegionBusy: data['liveRegionBusy'] as bool?,
    );
  }

  SchemaAnimation? _adaptAnimation(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final durationMs = data['durationMs'];
    if (durationMs is! int) return null;

    return SchemaAnimation(
      durationMs: durationMs,
      curve: data['curve'] as String?,
      delayMs: data['delayMs'] as int?,
    );
  }

  SchemaTrust _parseTrust(String trust) => switch (trust) {
        'minimal' => SchemaTrust.minimal,
        'elevated' => SchemaTrust.elevated,
        _ => SchemaTrust.standard,
      };
}

/// Normalize a raw wire value into a SchemaValue.
///
/// Token normalization rules (from executable plan §5.2):
/// - Strings matching "type.name" where type is a known token type → TokenRef
/// - Maps with "token" key → explicit TokenRef
/// - Maps with "adaptive" key → AdaptiveValue
/// - Maps with "responsive" key → ResponsiveValue
/// - Maps with "bind" key → BindingValue or TransformValue
/// - Everything else → DirectValue
SchemaValue normalizeValue(dynamic raw) => _normalizeValue(raw);

SchemaValue _normalizeValue(dynamic raw) {
  if (raw == null) return const DirectValue(null);
  if (raw is num) return DirectValue(raw);
  if (raw is bool) return DirectValue(raw);

  if (raw is String) {
    // Check for token shorthand: "color.primary"
    final dotIndex = raw.indexOf('.');
    if (dotIndex > 0 && _isTokenType(raw.substring(0, dotIndex))) {
      return TokenRef(
        type: raw.substring(0, dotIndex),
        name: raw.substring(dotIndex + 1),
      );
    }
    return DirectValue(raw);
  }

  if (raw is Map<String, dynamic>) {
    // Explicit token object
    if (raw.containsKey('token')) {
      final tok = raw['token'] as Map<String, dynamic>;
      return TokenRef(
        type: tok['type'] as String? ?? '',
        name: tok['name'] as String? ?? '',
      );
    }

    // Adaptive value
    if (raw.containsKey('adaptive')) {
      final a = raw['adaptive'] as Map<String, dynamic>;
      return AdaptiveValue(
        light: _normalizeValue(a['light']),
        dark: _normalizeValue(a['dark']),
      );
    }

    // Responsive value
    if (raw.containsKey('responsive')) {
      final r = raw['responsive'] as Map<String, dynamic>;
      return ResponsiveValue(
        r.map((k, v) => MapEntry(k, _normalizeValue(v))),
      );
    }

    // Binding / Transform
    if (raw.containsKey('bind')) {
      if (raw.containsKey('transform')) {
        return TransformValue(
          path: raw['bind'] as String,
          transformKey: raw['transform'] as String,
        );
      }
      return BindingValue(raw['bind'] as String);
    }
  }

  // Fallback: wrap as direct value
  return DirectValue(raw);
}
