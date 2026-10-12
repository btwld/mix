import 'package:mix_protocol/testing.dart';

/// Documents that pin the core style schema's acceptance boundary.
///
/// `schema_fixtures_test.dart` writes these to `schema/fixtures/style.json`
/// for the Ajv check, and the decoder tests replay the same documents so the
/// exported schema and the runtime decoder cannot drift apart.
final List<SchemaFixtureCase> styleAcceptCases = [
  ..._breakpointSelectorCases(valid: true),
  ..._canonicalPropertyTermCases,
  ..._nestedMergeCases,
  ..._tokenKindCases,
  ..._gridTrackCases,
  ..._directiveCases,
  const SchemaFixtureCase('flex.spacing merge with apply', {
    'v': 1,
    'type': 'flex',
    'spacing': {
      r'$merge': [4],
      'apply': [
        {'op': 'number_multiply', 'factor': 2},
      ],
    },
  }),
  const SchemaFixtureCase('flex.spacing merges token and literal', {
    'v': 1,
    'type': 'flex',
    'spacing': {
      r'$merge': [
        {r'$token': 'space.stack.sm', 'kind': 'space'},
        4,
      ],
    },
  }),
  const SchemaFixtureCase('text.style.color token with directive', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {
        r'$token': 'color.brand',
        'apply': [
          {'op': 'color_alpha', 'alpha': 128},
        ],
      },
    },
  }),
  const SchemaFixtureCase('text.semanticsLabel string directive', {
    'v': 1,
    'type': 'text',
    'semanticsLabel': {
      r'$merge': ['hello world'],
      'apply': [
        {'op': 'title_case'},
      ],
    },
  }),
  const SchemaFixtureCase('text.strutStyle.fontSize merge with directive', {
    'v': 1,
    'type': 'text',
    'strutStyle': {
      'fontSize': {
        r'$merge': [12],
        'apply': [
          {'op': 'number_multiply', 'factor': 1.5},
        ],
      },
    },
  }),
  const SchemaFixtureCase('box.decoration.boxShadow merge of lists', {
    'v': 1,
    'type': 'box',
    'decoration': {
      'boxShadow': {
        r'$merge': [
          [
            {
              'color': '#000000',
              'offset': {'x': 0, 'y': 1},
              'blurRadius': 2,
            },
          ],
          [
            {
              'color': '#FFFFFF',
              'offset': {'x': 2, 'y': 3},
              'blurRadius': 4,
            },
          ],
        ],
      },
    },
  }),
];

final List<SchemaFixtureCase> styleRejectCases = [
  ..._breakpointSelectorCases(valid: false),
  ..._invalidTermCases,
  ..._invalidLiteralTypeCases,
  const SchemaFixtureCase('box.padding token with non-string name', {
    'v': 1,
    'type': 'box',
    'padding': {r'$token': 7},
  }),
  const SchemaFixtureCase('box.padding token with unknown key', {
    'v': 1,
    'type': 'box',
    'padding': {r'$token': 'x', 'bad': 1},
  }),
  const SchemaFixtureCase('box.padding empty merge', {
    'v': 1,
    'type': 'box',
    'padding': {r'$merge': []},
  }),
  const SchemaFixtureCase('box.padding single-item merge without apply', {
    'v': 1,
    'type': 'box',
    'padding': {
      r'$merge': [4],
    },
  }),
  const SchemaFixtureCase('box.padding apply without source', {
    'v': 1,
    'type': 'box',
    'padding': {'apply': []},
  }),
  const SchemaFixtureCase('flex.spacing empty apply list', {
    'v': 1,
    'type': 'flex',
    'spacing': {
      r'$merge': [4],
      'apply': [],
    },
  }),
  const SchemaFixtureCase('text.style.color empty apply list', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {r'$token': 'color.brand', 'apply': []},
    },
  }),
  const SchemaFixtureCase('text.selectionColor token with space kind', {
    'v': 1,
    'type': 'text',
    'selectionColor': {r'$token': 'color.brand', 'kind': 'space'},
  }),
  const SchemaFixtureCase('text.style.color token with space kind', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {r'$token': 'color.brand', 'kind': 'space'},
    },
  }),
  const SchemaFixtureCase('color directive with extra parameter', {
    'v': 1,
    'type': 'box',
    'decoration': {
      'color': {
        r'$merge': ['#336699'],
        'apply': [
          {'op': 'color_opacity', 'opacity': 0.5, 'alpha': 0.7},
        ],
      },
    },
  }),
  const SchemaFixtureCase('color directive with unknown op', {
    'v': 1,
    'type': 'box',
    'decoration': {
      'color': {
        r'$merge': ['#336699'],
        'apply': [
          {'op': 'color_invert'},
        ],
      },
    },
  }),
];

/// Documents that pin the theme schema's acceptance boundary.
final List<SchemaFixtureCase> themeAcceptCases = [
  const SchemaFixtureCase('space literal and exact-kind alias', {
    'v': 1,
    'type': 'theme',
    'spaces': {
      'space.base': 8,
      'space.alias': {r'$token': 'space.base', 'kind': 'space'},
    },
  }),
];

final List<SchemaFixtureCase> themeRejectCases = [
  const SchemaFixtureCase('space alias with double kind', {
    'v': 1,
    'type': 'theme',
    'spaces': {
      'space.alias': {r'$token': 'space.base', 'kind': 'double'},
    },
  }),
];

/// Directive parameter tables shared with the grammar round-trip tests.
const Map<String, JsonMap> colorDirectiveCases = {
  'color_opacity': {'opacity': 0.5},
  'color_with_values': {
    'alpha': 0.7,
    'red': 0.2,
    'green': 0.3,
    'blue': 0.4,
    'colorSpace': 'sRGB',
  },
  'color_alpha': {'alpha': 128},
  'color_darken': {'amount': 10},
  'color_lighten': {'amount': 10},
  'color_saturate': {'amount': 10},
  'color_desaturate': {'amount': 10},
  'color_tint': {'amount': 10},
  'color_shade': {'amount': 10},
  'color_brighten': {'amount': 10},
  'color_with_red': {'red': 12},
  'color_with_green': {'green': 34},
  'color_with_blue': {'blue': 56},
};

const List<String> stringDirectiveOps = [
  'uppercase',
  'lowercase',
  'capitalize',
  'title_case',
  'sentence_case',
];

const Map<String, JsonMap> numberDirectiveCases = {
  'number_multiply': {'factor': 1.5},
  'number_add': {'addend': 2},
  'number_subtract': {'subtrahend': 1},
  'number_divide': {'divisor': 2},
  'number_clamp': {'min': 1, 'max': 8},
  'number_abs': {},
  'number_round': {},
  'number_floor': {},
  'number_ceil': {},
};

JsonMap colorDirectivePayload(String op) => {
  'v': 1,
  'type': 'box',
  'decoration': {
    'color': {
      r'$merge': ['#336699'],
      'apply': [
        {'op': op, ...colorDirectiveCases[op]!},
      ],
    },
  },
};

JsonMap stringDirectivePayload(String op) => {
  'v': 1,
  'type': 'text',
  'semanticsLabel': {
    r'$merge': ['hello world'],
    'apply': [
      {'op': op},
    ],
  },
};

JsonMap numberDirectivePayload(String op) => {
  'v': 1,
  'type': 'flex',
  'spacing': {
    r'$merge': [4],
    'apply': [
      {'op': op, ...numberDirectiveCases[op]!},
    ],
  },
};

/// Breakpoint selector field combinations with the expected verdict.
const List<(JsonMap, bool)> breakpointSelectorFields = [
  ({'token': 'breakpoint.desktop'}, true),
  ({'minWidth': 600}, true),
  ({'maxWidth': 1024}, true),
  ({'minWidth': 600, 'maxWidth': 1024}, true),
  ({}, false),
  ({'token': 'breakpoint.desktop', 'minWidth': 600}, false),
  ({'token': 'breakpoint.desktop', 'maxWidth': 1024}, false),
];

JsonMap breakpointSelectorPayload(JsonMap fields, {required bool nested}) {
  final selector = {'kind': 'context_breakpoint', ...fields};

  return {
    'v': 1,
    'type': 'box',
    'variants': [
      {
        if (nested) ...{
          'kind': 'context_not',
          'variant': selector,
        } else
          ...selector,
        'style': {'type': 'box', 'padding': 8},
      },
    ],
  };
}

/// Invalid property terms and directive families the decoder also rejects.
const List<JsonMap> invalidTermFields = [
  {'padding': null},
  {
    'padding': {
      r'$merge': [true, false],
    },
  },
  {
    'padding': {r'$token': 'space.pad', 'kind': 'color'},
  },
  {
    'padding': {r'$token': 'invalid token name'},
  },
  {
    'decoration': {
      'color': {
        r'$merge': ['#123456'],
        'apply': [
          {'op': 'number_add', 'addend': 1},
        ],
      },
    },
  },
  {
    'decoration': {
      'color': {
        r'$merge': ['#123456'],
        'apply': [
          {'op': 'color_opacity', 'opacity': 'half'},
        ],
      },
    },
  },
];

/// Wrong literal types the decoder also rejects.
const Map<String, Object> invalidLiteralTypeFields = {
  'padding': true,
  'clipBehavior': 17,
  'transform': [1, 2],
};

/// Canonical property terms the decoder also accepts.
const List<Object> canonicalPaddingTerms = [
  16,
  {'left': 8, 'top': 4},
  {r'$token': 'space.pad', 'kind': 'space'},
  {
    r'$merge': [
      4,
      {'left': 8},
    ],
  },
];

List<SchemaFixtureCase> _breakpointSelectorCases({required bool valid}) => [
  for (final (fields, expected) in breakpointSelectorFields)
    if (expected == valid)
      for (final nested in [false, true])
        SchemaFixtureCase(
          'breakpoint selector ${fields.keys.join('+')}'
          '${nested ? ' nested in context_not' : ''}',
          breakpointSelectorPayload(fields, nested: nested),
        ),
];

List<SchemaFixtureCase> get _invalidTermCases => [
  for (final (index, fields) in invalidTermFields.indexed)
    SchemaFixtureCase('invalid term $index ${fields.keys.single}', {
      'v': 1,
      'type': 'box',
      ...fields,
    }),
];

List<SchemaFixtureCase> get _invalidLiteralTypeCases => [
  for (final field in invalidLiteralTypeFields.entries)
    SchemaFixtureCase('box.${field.key} wrong literal type', {
      'v': 1,
      'type': 'box',
      field.key: field.value,
    }),
];

List<SchemaFixtureCase> get _canonicalPropertyTermCases => [
  for (final (index, value) in canonicalPaddingTerms.indexed)
    SchemaFixtureCase('box.padding canonical term $index', {
      'v': 1,
      'type': 'box',
      'padding': value,
    }),
  const SchemaFixtureCase('box.padding two-item merge', {
    'v': 1,
    'type': 'box',
    'padding': {
      r'$merge': [4, 8],
    },
  }),
  const SchemaFixtureCase('box.padding token without kind', {
    'v': 1,
    'type': 'box',
    'padding': {r'$token': 'space.stack.sm'},
  }),
];

/// Nested double-token merge positions across styler branches.
List<SchemaFixtureCase> get _nestedMergeCases => [
  const SchemaFixtureCase('text.style.color merge', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {
        r'$merge': ['#123456', '#123456'],
      },
    },
  }),
  const SchemaFixtureCase('text.strutStyle.fontSize merge', {
    'v': 1,
    'type': 'text',
    'strutStyle': {
      'fontSize': {
        r'$merge': [12, 12],
      },
    },
  }),
  const SchemaFixtureCase('box.decoration.boxShadow merge', {
    'v': 1,
    'type': 'box',
    'decoration': {
      'boxShadow': {
        r'$merge': [<Object>[], <Object>[]],
      },
    },
  }),
  const SchemaFixtureCase('wrap_box.decoration.boxShadow merge', {
    'v': 1,
    'type': 'wrap_box',
    'decoration': {
      'boxShadow': {
        r'$merge': [<Object>[], <Object>[]],
      },
    },
  }),
  const SchemaFixtureCase('wrap_box.foregroundDecoration.boxShadow merge', {
    'v': 1,
    'type': 'wrap_box',
    'foregroundDecoration': {
      'boxShadow': {
        r'$merge': [<Object>[], <Object>[]],
      },
    },
  }),
];

/// Token kinds accepted at numeric positions across styler branches.
List<SchemaFixtureCase> get _tokenKindCases => [
  const SchemaFixtureCase('flex.spacing space token', {
    'v': 1,
    'type': 'flex',
    'spacing': {r'$token': 'space.stack.sm', 'kind': 'space'},
  }),
  const SchemaFixtureCase('flex.spacing double token', {
    'v': 1,
    'type': 'flex',
    'spacing': {r'$token': 'double.gap', 'kind': 'double'},
  }),
  for (final field in ['spacing', 'runSpacing']) ...[
    SchemaFixtureCase('wrap.$field space token', {
      'v': 1,
      'type': 'wrap',
      field: {r'$token': 'space.wrap.gap', 'kind': 'space'},
    }),
    SchemaFixtureCase('wrap_box.$field double token', {
      'v': 1,
      'type': 'wrap_box',
      field: {r'$token': 'double.wrap.gap', 'kind': 'double'},
    }),
  ],
  for (final field in ['padding', 'margin'])
    SchemaFixtureCase('wrap_box.$field space token', {
      'v': 1,
      'type': 'wrap_box',
      field: {r'$token': 'space.wrap.$field', 'kind': 'space'},
    }),
  for (final field in ['columnGap', 'rowGap'])
    SchemaFixtureCase('grid_box.$field space token', {
      'v': 1,
      'type': 'grid_box',
      field: {r'$token': 'space.grid.gap', 'kind': 'space'},
    }),
  const SchemaFixtureCase('text.style.fontSize space token', {
    'v': 1,
    'type': 'text',
    'style': {
      'fontSize': {r'$token': 'space.font.md', 'kind': 'space'},
    },
  }),
  const SchemaFixtureCase('text.strutStyle.leading space token', {
    'v': 1,
    'type': 'text',
    'strutStyle': {
      'leading': {r'$token': 'space.leading.tight', 'kind': 'space'},
    },
  }),
];

List<SchemaFixtureCase> get _gridTrackCases => [
  const SchemaFixtureCase('grid_box.columns numeric tokens', {
    'v': 1,
    'type': 'grid_box',
    'columns': [
      {
        'type': 'fixed',
        'size': {r'$token': 'space.grid.track', 'kind': 'space'},
      },
      {
        'type': 'fr',
        'fraction': {r'$token': 'double.grid.weight', 'kind': 'double'},
      },
    ],
  }),
  const SchemaFixtureCase('grid_box.rows auto track', {
    'v': 1,
    'type': 'grid_box',
    'rows': [
      {'type': 'auto'},
    ],
  }),
  const SchemaFixtureCase('grid_box.autoRows auto track', {
    'v': 1,
    'type': 'grid_box',
    'autoRows': {'type': 'auto'},
  }),
  const SchemaFixtureCase('grid_box.constraintBranches numeric tokens', {
    'v': 1,
    'type': 'grid_box',
    'constraintBranches': [
      {
        'breakpoint': {'maxWidth': 600},
        'patch': {
          'autoRows': {
            'type': 'fixed',
            'size': {r'$token': 'space.grid.row', 'kind': 'space'},
          },
          'rowGap': {r'$token': 'space.grid.gap', 'kind': 'space'},
        },
      },
    ],
  }),
  const SchemaFixtureCase('grid_box.constraintBranches auto tracks', {
    'v': 1,
    'type': 'grid_box',
    'constraintBranches': [
      {
        'breakpoint': {'maxWidth': 600},
        'patch': {
          'autoRows': {'type': 'auto'},
          'rows': [
            {'type': 'auto'},
          ],
        },
      },
    ],
  }),
];

List<SchemaFixtureCase> get _directiveCases => [
  for (final op in colorDirectiveCases.keys)
    SchemaFixtureCase('color directive $op', colorDirectivePayload(op)),
  for (final op in stringDirectiveOps)
    SchemaFixtureCase('string directive $op', stringDirectivePayload(op)),
  for (final op in numberDirectiveCases.keys)
    SchemaFixtureCase('number directive $op', numberDirectivePayload(op)),
];
