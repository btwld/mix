import '../ast/schema_node.dart';
import '../ast/schema_values.dart';

/// Expands a high-level component into a canonical AST subtree.
typedef ComponentExpander = SchemaNode Function(
  Map<String, dynamic> props,
  String nodeId,
);

/// Registry for component-to-AST expansion.
///
/// The Flutter GenUI Component Catalog v0 defines ~25 high-level components.
/// These are NOT part of the canonical AST — they sit above it as catalog
/// entries that expand into AST node trees.
///
/// See freeze §5.7 for the two-layer architecture:
/// - Catalog (developer-facing): what the agent requests
/// - AST (renderer-facing): what Mix actually renders
class ComponentRegistry {
  final Map<String, ComponentExpander> _expanders;

  ComponentRegistry(this._expanders);

  factory ComponentRegistry.defaults() => ComponentRegistry({
        'Card': _expandCard,
        'Button': _expandButton,
        'TextInput': _expandTextInput,
        'Table': _expandTable,
        'ActionGroup': _expandActionGroup,
      });

  /// Returns null if the component type is not registered.
  SchemaNode? expand(
    String componentType,
    Map<String, dynamic> props,
    String nodeId,
  ) {
    final expander = _expanders[componentType];
    return expander?.call(props, nodeId);
  }
}

// --- Top-5 Component Expansions ---

/// Card { title, subtitle, children }
SchemaNode _expandCard(Map<String, dynamic> props, String nodeId) {
  final title = props['title'] as String? ?? '';
  final subtitle = props['subtitle'] as String?;
  final children = props['children'] as List<SchemaNode>? ?? const [];

  return BoxNode(
    nodeId: '${nodeId}_card',
    style: const {
      'borderRadius': DirectValue(12.0),
      'padding': DirectValue(16.0),
    },
    child: FlexNode(
      nodeId: '${nodeId}_card_flex',
      direction: const DirectValue('column'),
      spacing: const DirectValue(8.0),
      children: [
        TextNode(
          nodeId: '${nodeId}_card_title',
          content: DirectValue(title),
          style: const {
            'fontSize': DirectValue(18.0),
            'fontWeight': DirectValue('bold'),
          },
        ),
        if (subtitle != null)
          TextNode(
            nodeId: '${nodeId}_card_subtitle',
            content: DirectValue(subtitle),
            style: const {
              'fontSize': DirectValue(14.0),
            },
          ),
        ...children,
      ],
    ),
  );
}

/// Button { label, actionId, variant }
SchemaNode _expandButton(Map<String, dynamic> props, String nodeId) {
  final label = props['label'] as String? ?? '';
  final actionId = props['actionId'] as String?;

  return PressableNode(
    nodeId: '${nodeId}_button',
    actionId: actionId,
    child: BoxNode(
      nodeId: '${nodeId}_button_box',
      style: const {
        'paddingX': DirectValue(16.0),
        'paddingY': DirectValue(8.0),
        'borderRadius': DirectValue(8.0),
      },
      child: TextNode(
        nodeId: '${nodeId}_button_label',
        content: DirectValue(label),
        style: const {
          'fontWeight': DirectValue('medium'),
        },
      ),
    ),
  );
}

/// TextInput { id, label, hint }
SchemaNode _expandTextInput(Map<String, dynamic> props, String nodeId) {
  final fieldId = props['id'] as String? ?? nodeId;
  final label = props['label'] as String?;
  final hint = props['hint'] as String?;

  return InputNode(
    nodeId: '${nodeId}_textInput',
    inputType: 'text',
    fieldId: fieldId,
    label: label != null ? DirectValue(label) : null,
    hint: hint != null ? DirectValue(hint) : null,
  );
}

/// Table { columns, rows }
SchemaNode _expandTable(Map<String, dynamic> props, String nodeId) {
  final columns = (props['columns'] as List?)?.cast<String>() ?? [];
  final rowsBinding = props['rows'] as String? ?? 'rows';

  return FlexNode(
    nodeId: '${nodeId}_table',
    direction: const DirectValue('column'),
    children: [
      // Header row
      FlexNode(
        nodeId: '${nodeId}_table_header',
        direction: const DirectValue('row'),
        spacing: const DirectValue(8.0),
        children: [
          for (var i = 0; i < columns.length; i++)
            TextNode(
              nodeId: '${nodeId}_table_header_$i',
              content: DirectValue(columns[i]),
              style: const {
                'fontWeight': DirectValue('bold'),
              },
            ),
        ],
      ),
      // Data rows via repeat
      RepeatNode(
        nodeId: '${nodeId}_table_rows',
        items: BindingValue(rowsBinding),
        template: FlexNode(
          nodeId: '${nodeId}_table_row',
          direction: const DirectValue('row'),
          spacing: const DirectValue(8.0),
          children: [
            for (var i = 0; i < columns.length; i++)
              TextNode(
                nodeId: '${nodeId}_table_cell_$i',
                content: BindingValue('item.${columns[i]}'),
              ),
          ],
        ),
      ),
    ],
  );
}

/// ActionGroup { children, alignment }
SchemaNode _expandActionGroup(Map<String, dynamic> props, String nodeId) {
  final children = props['children'] as List<SchemaNode>? ?? const [];
  final alignment = props['alignment'] as String? ?? 'end';

  return FlexNode(
    nodeId: '${nodeId}_actionGroup',
    direction: const DirectValue('row'),
    mainAxisAlignment: DirectValue(alignment),
    spacing: const DirectValue(8.0),
    children: children,
  );
}
