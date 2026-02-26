/// Invalid payload: not a map.
const invalidNotAMap = 'not a map';

/// Invalid payload: missing root.
const invalidMissingRoot = <String, dynamic>{
  'id': 'test_missing_root',
  'version': '0.9',
  'trust': 'standard',
};

/// Invalid payload: unknown node type.
const invalidUnknownNodeType = <String, dynamic>{
  'id': 'test_unknown_type',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'carousel',
    'nodeId': 'bad_node',
  },
};

/// Invalid payload: node missing type field.
const invalidMissingType = <String, dynamic>{
  'id': 'test_missing_type',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'nodeId': 'no_type_node',
    'style': {'color': '#FF0000'},
  },
};

/// Invalid payload: excessive depth (for minimal trust).
Map<String, dynamic> buildDeepTree(int depth) {
  Map<String, dynamic> node = {
    'type': 'text',
    'nodeId': 'leaf',
    'content': 'leaf',
  };

  for (var i = depth - 1; i >= 0; i--) {
    node = {
      'type': 'box',
      'nodeId': 'box_$i',
      'child': node,
    };
  }

  return <String, dynamic>{
    'id': 'test_deep',
    'version': '0.9',
    'trust': 'minimal',
    'root': node,
  };
}

/// Invalid: too many nodes for minimal trust (>50).
Map<String, dynamic> buildWideTree(int count) {
  final children = <Map<String, dynamic>>[];
  for (var i = 0; i < count; i++) {
    children.add({
      'type': 'text',
      'nodeId': 'text_$i',
      'content': 'Text $i',
    });
  }

  return <String, dynamic>{
    'id': 'test_wide',
    'version': '0.9',
    'trust': 'minimal',
    'root': {
      'type': 'flex',
      'nodeId': 'root_flex',
      'direction': 'column',
      'children': children,
    },
  };
}

/// Invalid: pressable without semantics (warning).
const invalidPressableNoSemantics = <String, dynamic>{
  'id': 'test_pressable_no_semantics',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'pressable',
    'nodeId': 'bare_pressable',
    'child': {
      'type': 'text',
      'nodeId': 'press_text',
      'content': 'Click me',
    },
  },
};

/// Invalid: image without alt text (warning).
const invalidImageNoAlt = <String, dynamic>{
  'id': 'test_image_no_alt',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'image',
    'nodeId': 'bare_image',
    'src': 'https://example.com/img.png',
  },
};

/// Invalid: scrollable without child.
const invalidScrollableNoChild = <String, dynamic>{
  'id': 'test_scrollable_no_child',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'scrollable',
    'nodeId': 'bad_scrollable',
  },
};
