/// v0.8 payload with deprecated field names.
const v08Payload = <String, dynamic>{
  'id': 'test_v08',
  'schema_version': '0.8',
  'trust_level': 'standard',
  'ui': {
    'type': 'box',
    'node_id': 'v08_box',
    'styles': {
      'color': '#FF0000',
      'padding': 16.0,
    },
    'a11y': {
      'role': 'region',
      'label': 'Main content',
    },
    'child': {
      'type': 'text',
      'node_id': 'v08_text',
      'content': 'Hello from v0.8',
      'styles': {
        'fontSize': 16.0,
      },
    },
  },
};

/// v0.8 payload with nested children.
const v08NestedPayload = <String, dynamic>{
  'id': 'test_v08_nested',
  'schema_version': '0.8',
  'trust_level': 'standard',
  'ui': {
    'type': 'flex',
    'node_id': 'v08_flex',
    'direction': 'column',
    'children': [
      {
        'type': 'text',
        'node_id': 'v08_child_1',
        'content': 'Child 1',
        'styles': {'fontSize': 14.0},
      },
      {
        'type': 'text',
        'node_id': 'v08_child_2',
        'content': 'Child 2',
      },
    ],
  },
};
