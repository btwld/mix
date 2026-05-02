/// Mix Schema prop registry.
///
/// Mirrors `registry.json` — per-spec, per-modifier, per-directive,
/// per-literal typing. Used by the canonicalizer (sugar rules), validator
/// (semantic checks), and parser (typed dispatch).
///
/// Pure value model. No mutation API after `fromJson`.
library;

import 'package:meta/meta.dart';

/// Root registry view. Build via `Registry.fromJson(parsedJson)`.
@immutable
class Registry {
  const Registry({
    required this.tokenNamespaces,
    required this.enums,
    required this.enumAliases,
    required this.literals,
    required this.specs,
    required this.modifiers,
    required this.directives,
  });

  /// 8 built-in token namespaces (color, radius, space, double, breakpoint,
  /// text, borderSide, shadow). Maps each name to its target type.
  final Map<String, TokenNamespaceDef> tokenNamespaces;

  /// Closed set of enum values per enum type (e.g. `FontWeight` →
  /// `[w100, w200, ..., w900]`).
  final Map<String, List<String>> enums;

  /// Input-boundary aliases. e.g. `enumAliases['FontWeight']['normal']` =
  /// `'w400'`. Resolved by the canonicalizer's first pass.
  final Map<String, Map<String, String>> enumAliases;

  /// 19 structured literals (EdgeInsets, BorderRadius, etc.) keyed by name.
  final Map<String, LiteralDef> literals;

  /// 8 specs (box, flex, text, icon, image, stack, flexbox, stackbox).
  final Map<String, SpecDef> specs;

  /// 30 modifiers, keyed by name.
  final Map<String, ModifierDef> modifiers;

  /// Directives grouped by target type — `directives['color']['darken']` =
  /// the `darken` op definition. Three groups: `color`, `string`, `number`.
  final Map<String, Map<String, DirectiveDef>> directives;

  /// Build from a parsed `registry.json` document.
  factory Registry.fromJson(Map<String, Object?> json) {
    return Registry(
      tokenNamespaces: _readTokenNamespaces(json['tokenNamespaces']),
      enums: _readEnums(json['enums']),
      enumAliases: _readEnumAliases(json['enumAliases']),
      literals: _readLiterals(json['literals']),
      specs: _readSpecs(json['specs']),
      modifiers: _readModifiers(json['modifiers']),
      directives: _readDirectives(json['directives']),
    );
  }
}

/// Definition for one of the 8 built-in token namespaces.
@immutable
class TokenNamespaceDef {
  const TokenNamespaceDef({required this.type});

  /// Target type the namespace resolves to (e.g. `Color`, `double`).
  final String type;
}

/// Definition for a structured literal (EdgeInsets, TextStyle, ...).
///
/// Some literals (Gradient, TextScaler, Icon, Image, Matrix4) are
/// discriminated; in that case [discriminator] and [kinds] are non-null
/// and [fields] is empty (the per-kind shape lives in [kinds]).
@immutable
class LiteralDef {
  const LiteralDef({
    required this.fields,
    required this.sugar,
    required this.presets,
    required this.discriminator,
    required this.kinds,
    required this.shape,
    required this.note,
  });

  /// Sub-fields keyed by name. Empty for discriminated literals.
  final Map<String, FieldDef> fields;

  /// Shorthand keys accepted at the input boundary (e.g. `all`,
  /// `horizontal`, `vertical`). Maps shorthand → human description.
  final Map<String, String> sugar;

  /// Preset names accepted as sugar (Alignment-only at present).
  final List<String> presets;

  /// Discriminator field name when the literal is a tagged union (e.g.
  /// `kind` for Gradient, `source` for Icon/Image). `null` for non-tagged
  /// literals.
  final String? discriminator;

  /// Per-discriminator-value field maps. `null` for non-tagged literals.
  final Map<String, Map<String, FieldDef>>? kinds;

  /// Free-form shape descriptor (e.g. `"ordered-ops"` for Matrix4).
  final String? shape;

  /// Free-form descriptive note carried over from the source.
  final String? note;

  bool get isDiscriminated => discriminator != null;
}

/// Definition for one prop on a spec, modifier, directive, or sub-field on
/// a literal.
@immutable
class FieldDef {
  const FieldDef({
    required this.kind,
    required this.type,
    required this.literal,
    required this.enumName,
    required this.tokens,
    required this.optional,
    required this.constraint,
    required this.merge,
    required this.spec,
    required this.items,
    required this.note,
  });

  /// `scalar` (default), `literal`, `enum`, `array`, `host`, `styleNode`.
  final String? kind;

  /// Target Dart-ish type (e.g. `double`, `int`, `string`, `bool`,
  /// `color`, `num`). Only meaningful for `kind: scalar` and array items.
  final String? type;

  /// For `kind: literal`, the literal name (e.g. `EdgeInsets`).
  final String? literal;

  /// For `kind: enum`, the enum name (e.g. `FontWeight`).
  final String? enumName;

  /// Token namespaces this field can accept (e.g. `["color"]`).
  /// Empty when the field doesn't accept token references.
  final List<String> tokens;

  /// `true` when the field is optional. Default `false`.
  final bool optional;

  /// Constraint hint (e.g. `"!= 0"`, `">= min"`). Free-form descriptor.
  final String? constraint;

  /// Merge strategy declared on a few literal-valued props
  /// (e.g. `"structured"`).
  final String? merge;

  /// For `kind: styleNode` (modifiers `box.style` and
  /// `defaultTextStyler.style`), the spec name nested here.
  final String? spec;

  /// For `kind: array`, the per-item field definition.
  final FieldDef? items;

  /// Free-form note carried from the source.
  final String? note;
}

/// Definition for one of the 8 specs.
///
/// Composite specs (flexbox, stackbox) carry [composite] non-null and
/// have empty [props] / [specLevel].
@immutable
class SpecDef {
  const SpecDef({
    required this.widget,
    required this.composite,
    required this.props,
    required this.specLevel,
    required this.note,
  });

  /// Authoring widget name (e.g. `Box`, `FlexBox`). `null` for leaf specs
  /// that have no direct widget (`flex`, `stack`).
  final String? widget;

  /// For composites, the names of the sub-styles (`["box", "flex"]`).
  /// Empty for leaf specs.
  final List<String> composite;

  /// Per-prop typing.
  final Map<String, FieldDef> props;

  /// Spec-level (non-prop) fields, e.g. `text.textDirectives`.
  final Map<String, FieldDef> specLevel;

  /// Free-form note.
  final String? note;

  bool get isComposite => composite.isNotEmpty;
}

/// Definition for one of the 30 modifiers.
@immutable
class ModifierDef {
  const ModifierDef({required this.props, required this.note});

  final Map<String, FieldDef> props;
  final String? note;
}

/// Definition for one of the 27 directives.
@immutable
class DirectiveDef {
  const DirectiveDef({required this.props});

  final Map<String, FieldDef> props;
}

// ---------------------------------------------------------------------------
// Parsing helpers — internal to this file.

Map<String, TokenNamespaceDef> _readTokenNamespaces(Object? src) {
  if (src is! Map) return const {};
  final result = <String, TokenNamespaceDef>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! Map) continue;
    final type = value['type'];
    if (type is! String) continue;
    result[key] = TokenNamespaceDef(type: type);
  }
  return Map.unmodifiable(result);
}

Map<String, List<String>> _readEnums(Object? src) {
  if (src is! Map) return const {};
  final result = <String, List<String>>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! List) continue;
    result[key] = List<String>.unmodifiable(value.cast<String>());
  }
  return Map.unmodifiable(result);
}

Map<String, Map<String, String>> _readEnumAliases(Object? src) {
  if (src is! Map) return const {};
  final result = <String, Map<String, String>>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! Map) continue;
    final inner = <String, String>{};
    for (final aliasEntry in value.entries) {
      final aliasKey = aliasEntry.key;
      final aliasValue = aliasEntry.value;
      if (aliasKey is! String || aliasValue is! String) continue;
      inner[aliasKey] = aliasValue;
    }
    result[key] = Map.unmodifiable(inner);
  }
  return Map.unmodifiable(result);
}

Map<String, LiteralDef> _readLiterals(Object? src) {
  if (src is! Map) return const {};
  final result = <String, LiteralDef>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! Map) continue;

    final discriminator = value['discriminator'];
    // Some literals expose their tagged-union variants under `kinds`
    // (Gradient, TextScaler, Icon, Image), others under `ops` (Matrix4 —
    // ordered-ops shape). Both are tagged unions for our purposes; fold
    // them into the same map.
    final kinds = value['kinds'] is Map
        ? value['kinds'] as Map
        : value['ops'] is Map
            ? value['ops'] as Map
            : null;

    Map<String, Map<String, FieldDef>>? kindMap;
    if (discriminator is String && kinds != null) {
      final perKind = <String, Map<String, FieldDef>>{};
      for (final kindEntry in kinds.entries) {
        final kindKey = kindEntry.key;
        final kindValue = kindEntry.value;
        if (kindKey is! String || kindValue is! Map) continue;
        perKind[kindKey] = _readFieldMap(kindValue['fields']);
      }
      kindMap = Map.unmodifiable(perKind);
    }

    result[key] = LiteralDef(
      fields: _readFieldMap(value['fields']),
      sugar: _readStringMap(value['sugar']),
      presets: _readStringList(value['presets']),
      discriminator: discriminator is String ? discriminator : null,
      kinds: kindMap,
      shape: value['shape'] is String ? value['shape'] as String : null,
      note: value['note'] is String ? value['note'] as String : null,
    );
  }
  return Map.unmodifiable(result);
}

Map<String, SpecDef> _readSpecs(Object? src) {
  if (src is! Map) return const {};
  final result = <String, SpecDef>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! Map) continue;
    result[key] = SpecDef(
      widget: value['widget'] is String ? value['widget'] as String : null,
      composite: _readStringList(value['composite']),
      props: _readFieldMap(value['props']),
      specLevel: _readFieldMap(value['specLevel']),
      note: value['note'] is String ? value['note'] as String : null,
    );
  }
  return Map.unmodifiable(result);
}

Map<String, ModifierDef> _readModifiers(Object? src) {
  if (src is! Map) return const {};
  final result = <String, ModifierDef>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! Map) continue;
    result[key] = ModifierDef(
      props: _readFieldMap(value['props']),
      note: value['note'] is String ? value['note'] as String : null,
    );
  }
  return Map.unmodifiable(result);
}

Map<String, Map<String, DirectiveDef>> _readDirectives(Object? src) {
  if (src is! Map) return const {};
  final result = <String, Map<String, DirectiveDef>>{};
  for (final entry in src.entries) {
    final group = entry.key;
    final value = entry.value;
    if (group is! String || value is! Map) continue;
    final inner = <String, DirectiveDef>{};
    for (final opEntry in value.entries) {
      final opKey = opEntry.key;
      final opValue = opEntry.value;
      if (opKey is! String || opValue is! Map) continue;
      inner[opKey] = DirectiveDef(props: _readFieldMap(opValue['props']));
    }
    result[group] = Map.unmodifiable(inner);
  }
  return Map.unmodifiable(result);
}

Map<String, FieldDef> _readFieldMap(Object? src) {
  if (src is! Map) return const {};
  final result = <String, FieldDef>{};
  for (final entry in src.entries) {
    final key = entry.key;
    if (key is! String) continue;
    final value = entry.value;
    if (value is String) {
      // Bare-string shorthand (e.g. text.specLevel.textDirectives:
      // "StringDirective"). Interpret as a free-form note pointer.
      result[key] = FieldDef(
        kind: null,
        type: null,
        literal: null,
        enumName: null,
        tokens: const [],
        optional: false,
        constraint: null,
        merge: null,
        spec: null,
        items: null,
        note: value,
      );
      continue;
    }
    if (value is! Map) continue;
    result[key] = _readFieldDef(value);
  }
  return Map.unmodifiable(result);
}

FieldDef _readFieldDef(Map src) {
  final itemsSrc = src['items'];
  FieldDef? items;
  if (itemsSrc is Map) {
    items = _readFieldDef(itemsSrc);
  }
  return FieldDef(
    kind: src['kind'] is String ? src['kind'] as String : null,
    type: src['type'] is String ? src['type'] as String : null,
    literal: src['literal'] is String ? src['literal'] as String : null,
    enumName: src['enum'] is String ? src['enum'] as String : null,
    tokens: _readStringList(src['tokens']),
    optional: src['optional'] == true,
    constraint:
        src['constraint'] is String ? src['constraint'] as String : null,
    merge: src['merge'] is String ? src['merge'] as String : null,
    spec: src['spec'] is String ? src['spec'] as String : null,
    items: items,
    note: src['note'] is String ? src['note'] as String : null,
  );
}

Map<String, String> _readStringMap(Object? src) {
  if (src is! Map) return const {};
  final result = <String, String>{};
  for (final entry in src.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String || value is! String) continue;
    result[key] = value;
  }
  return Map.unmodifiable(result);
}

List<String> _readStringList(Object? src) {
  if (src is! List) return const [];
  return List<String>.unmodifiable(src.whereType<String>());
}
