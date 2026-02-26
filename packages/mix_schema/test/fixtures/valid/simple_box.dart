/// Simple valid box schema fixture for testing.
const simpleBoxPayload = <String, dynamic>{
  'id': 'test_simple_box',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'box',
    'nodeId': 'root_box',
    'style': {
      'color': '#FF0000',
      'padding': 16.0,
      'borderRadius': 8.0,
    },
    'child': {
      'type': 'text',
      'nodeId': 'hello_text',
      'content': 'Hello World',
      'style': {
        'fontSize': 18.0,
        'fontWeight': 'bold',
      },
    },
  },
};

/// Card-like layout with multiple children.
const cardLayoutPayload = <String, dynamic>{
  'id': 'test_card_layout',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'box',
    'nodeId': 'card',
    'style': {
      'borderRadius': 12.0,
      'padding': 16.0,
    },
    'child': {
      'type': 'flex',
      'nodeId': 'card_flex',
      'direction': 'column',
      'spacing': 8.0,
      'children': [
        {
          'type': 'text',
          'nodeId': 'title',
          'content': 'Card Title',
          'style': {'fontSize': 24.0, 'fontWeight': 'bold'},
        },
        {
          'type': 'text',
          'nodeId': 'subtitle',
          'content': 'Card subtitle',
          'style': {'fontSize': 14.0},
        },
        {
          'type': 'pressable',
          'nodeId': 'action_btn',
          'actionId': 'submit',
          'semantics': {'role': 'button', 'label': 'Submit'},
          'child': {
            'type': 'text',
            'nodeId': 'btn_label',
            'content': 'Submit',
          },
        },
      ],
    },
  },
};

/// Schema with token references.
const tokenRefPayload = <String, dynamic>{
  'id': 'test_tokens',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'box',
    'nodeId': 'token_box',
    'style': {
      'color': 'color.primary',
      'padding': 'space.md',
      'borderRadius': 'radius.md',
    },
    'child': {
      'type': 'text',
      'nodeId': 'token_text',
      'content': 'Themed text',
      'style': {
        'color': 'color.onPrimary',
      },
    },
  },
};

/// Schema with adaptive values.
const adaptivePayload = <String, dynamic>{
  'id': 'test_adaptive',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'box',
    'nodeId': 'adaptive_box',
    'style': {
      'color': {
        'adaptive': {'light': '#FFFFFF', 'dark': '#000000'},
      },
    },
    'child': {
      'type': 'text',
      'nodeId': 'adaptive_text',
      'content': 'Adaptive content',
    },
  },
};

/// Schema with responsive values.
const responsivePayload = <String, dynamic>{
  'id': 'test_responsive',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'flex',
    'nodeId': 'responsive_flex',
    'direction': {
      'responsive': {'mobile': 'column', 'tablet': 'row', 'desktop': 'row'},
    },
    'spacing': {
      'responsive': {'mobile': 8.0, 'tablet': 16.0, 'desktop': 24.0},
    },
    'children': [
      {
        'type': 'text',
        'nodeId': 'text1',
        'content': 'Item 1',
      },
      {
        'type': 'text',
        'nodeId': 'text2',
        'content': 'Item 2',
      },
    ],
  },
};

/// Schema with data binding.
const bindingPayload = <String, dynamic>{
  'id': 'test_binding',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'flex',
    'nodeId': 'binding_flex',
    'direction': 'column',
    'children': [
      {
        'type': 'text',
        'nodeId': 'name_text',
        'content': {'bind': 'user.name'},
      },
      {
        'type': 'text',
        'nodeId': 'email_text',
        'content': {'bind': 'user.email'},
      },
    ],
  },
  'environment': {
    'data': {
      'user': {'name': 'John', 'email': 'john@example.com'},
    },
  },
};

/// Schema with repeat node.
const repeatPayload = <String, dynamic>{
  'id': 'test_repeat',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'flex',
    'nodeId': 'list_flex',
    'direction': 'column',
    'children': [
      {
        'type': 'repeat',
        'nodeId': 'item_repeat',
        'items': {'bind': 'items'},
        'template': {
          'type': 'text',
          'nodeId': 'item_text',
          'content': {'bind': 'item.name'},
        },
      },
    ],
  },
  'environment': {
    'data': {
      'items': [
        {'name': 'Item 1'},
        {'name': 'Item 2'},
        {'name': 'Item 3'},
      ],
    },
  },
};

/// Schema with animation.
const animatedPayload = <String, dynamic>{
  'id': 'test_animated',
  'version': '0.9',
  'trust': 'standard',
  'root': {
    'type': 'box',
    'nodeId': 'animated_box',
    'style': {'color': '#FF0000', 'padding': 16.0},
    'animation': {
      'durationMs': 300,
      'curve': 'easeOut',
    },
    'child': {
      'type': 'text',
      'nodeId': 'animated_text',
      'content': 'Animated',
    },
  },
};

/// All node types in a single schema.
const allNodeTypesPayload = <String, dynamic>{
  'id': 'test_all_nodes',
  'version': '0.9',
  'trust': 'elevated',
  'root': {
    'type': 'scrollable',
    'nodeId': 'scroller',
    'direction': 'vertical',
    'child': {
      'type': 'flex',
      'nodeId': 'main_flex',
      'direction': 'column',
      'children': [
        {
          'type': 'box',
          'nodeId': 'box1',
          'style': {'padding': 8.0},
        },
        {
          'type': 'text',
          'nodeId': 'text1',
          'content': 'Hello',
        },
        {
          'type': 'icon',
          'nodeId': 'icon1',
          'icon': 'star',
        },
        {
          'type': 'image',
          'nodeId': 'img1',
          'src': 'https://example.com/img.png',
          'alt': 'Example image',
        },
        {
          'type': 'stack',
          'nodeId': 'stack1',
          'children': [
            {'type': 'box', 'nodeId': 'stack_child1'},
            {'type': 'box', 'nodeId': 'stack_child2'},
          ],
        },
        {
          'type': 'wrap',
          'nodeId': 'wrap1',
          'spacing': 4.0,
          'runSpacing': 4.0,
          'children': [
            {'type': 'text', 'nodeId': 'tag1', 'content': 'Tag1'},
            {'type': 'text', 'nodeId': 'tag2', 'content': 'Tag2'},
          ],
        },
        {
          'type': 'input',
          'nodeId': 'input1',
          'inputType': 'text',
          'fieldId': 'name',
          'label': 'Name',
          'hint': 'Enter name',
        },
      ],
    },
  },
};
