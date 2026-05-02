/// Sugar → canonical normalization (spec.md §Canonical form vs accepted
/// input). Idempotent.
///
/// Owns Decisions #15 (leaf-expanded structured literals), #36 (FontWeight
/// aliases), #41 (empty-array omission). Single source of truth for sugar
/// grammar — Phase 4 validator stage 3 reuses this code.
///
/// Pipeline (5 sequential passes, each idempotent):
///   1. Alias normalization (input boundary, no structural changes).
///   2. Scalar → Value lift (bare scalar at a Value position becomes
///      `{value: x}`).
///   3. Structured-literal sugar expansion (`all`/`horizontal`/`vertical`,
///      Alignment presets, short-form colors, int → double).
///   4. Leaf-Value normalization (every sub-field of a structured literal
///      becomes a Value object).
///   5. Shape pruning (drop empty optional arrays, drop null-valued
///      optional fields).
///
/// After all passes, object keys are lex-sorted for deterministic byte
/// shape. (Equality is order-insensitive — see `_internal.dart`'s
/// `deepEquals`.)
library;

import '_internal.dart' show deepEquals;
import 'registry.dart';

class Canonicalizer {
  Canonicalizer(this._registry);

  final Registry _registry;

  /// Idempotent normalization. Accepts a parsed JSON object (the
  /// envelope), returns its canonical form.
  Map<String, Object?> normalize(Map<String, Object?> input) {
    final pass1 = _normalizeAliases(input);
    final pass2 = _liftScalars(pass1);
    final pass3 = _expandStructuredLiterals(pass2);
    final pass4 = _normalizeLeafValues(pass3);
    final pass5 = _pruneShape(pass4);
    return _lexSort(pass5);
  }

  /// True iff [input] is already in canonical form (i.e. running
  /// [normalize] again would not change it under structural equality).
  bool isCanonical(Map<String, Object?> input) {
    final normalized = normalize(input);
    return deepEquals(input, normalized);
  }

  // -------------------------------------------------------------------------
  // Pass 1 — Alias normalization (Decision #36).
  //
  // Walks the entire tree. Wherever a string scalar appears at a position
  // that the registry maps to an enum, we substitute the alias. Currently
  // the only registered aliases are FontWeight.normal → w400 and
  // FontWeight.bold → w700.

  Object? _normalizeAliases(Object? value) {
    if (value is Map<String, Object?>) {
      return {
        for (final entry in value.entries)
          entry.key: _normalizeAliasValue(entry.key, entry.value),
      };
    }
    if (value is List) {
      return [for (final v in value) _normalizeAliases(v)];
    }
    return value;
  }

  Object? _normalizeAliasValue(String key, Object? value) {
    if (value is String) {
      // Try every registered enumAlias. Cheap because there are few.
      for (final aliases in _registry.enumAliases.values) {
        final replacement = aliases[value];
        if (replacement != null) return replacement;
      }
    }
    return _normalizeAliases(value);
  }

  // -------------------------------------------------------------------------
  // Pass 2 — Bare scalar → Value lift.
  //
  // A bare scalar at a Value position (i.e. a position the validator
  // would feed to PropertyValue.fromJson) wraps to `{value: x}`.
  //
  // We can't know every Value position without registry-driven dispatch,
  // so we operate locally: if a Map's value looks like a leaf scalar at
  // a key that the validator/parser would parse as a Value, lift it.
  //
  // Heuristic: under any `props` object, every value gets lifted if it's
  // not already a Value/Map. Same for inside structured-literal sub-
  // fields (which is recursive).

  Object? _liftScalars(Object? value) {
    if (value is Map<String, Object?>) {
      // Detect "this is a Value object position" — at the document level
      // we look for known Value-bearing keys: `props` (StyleNode/Modifier
      // props), `tokens` (envelope token bundle), and the inside of any
      // already-detected Value-shaped object.
      return {
        for (final entry in value.entries)
          entry.key: _liftAt(entry.key, entry.value),
      };
    }
    if (value is List) {
      return [for (final v in value) _liftScalars(v)];
    }
    return value;
  }

  Object? _liftAt(String contextKey, Object? value) {
    if (contextKey == 'props' || contextKey == 'tokens') {
      // Each child of `props`/`tokens` is itself a Value-bearing slot.
      if (value is Map<String, Object?>) {
        return {
          for (final entry in value.entries)
            entry.key: _liftValueSlot(entry.value),
        };
      }
    }
    return _liftScalars(value);
  }

  /// Lift a single Value slot. Bare scalar → `{value: scalar}`. Bare
  /// literal-body Map (no `value`/`token`/`directives`) → wrapped under
  /// `value`. Otherwise recurse.
  Object? _liftValueSlot(Object? value) {
    if (value is num || value is String || value is bool) {
      return {'value': value};
    }
    if (value is Map<String, Object?>) {
      final isValueObject = value.containsKey('value') ||
          value.containsKey('token') ||
          value.containsKey('directives');
      if (!isValueObject) {
        // Bare literal-body shorthand (e.g. `padding: {all: 16}`).
        // Wrap under `value`.
        return {
          'value': {
            for (final sub in value.entries)
              sub.key: _liftValueSlotInLiteral(sub.value),
          },
        };
      }
      // Already a Value object. Recurse into the literal body if any.
      final out = <String, Object?>{};
      for (final entry in value.entries) {
        if (entry.key == 'value' && entry.value is Map<String, Object?>) {
          final lit = entry.value as Map<String, Object?>;
          out['value'] = {
            for (final sub in lit.entries)
              sub.key: _liftValueSlotInLiteral(sub.value),
          };
        } else {
          out[entry.key] = _liftScalars(entry.value);
        }
      }
      return out;
    }
    return _liftScalars(value);
  }

  Object? _liftValueSlotInLiteral(Object? value) {
    // Inside a structured-literal body (e.g. EdgeInsets's sub-fields),
    // every sub-field should itself be a Value object.
    if (value is num || value is String || value is bool) {
      return {'value': value};
    }
    if (value is Map<String, Object?>) {
      // Recurse — the sub-field is itself a Value, possibly with nested
      // structured literal as its `value`.
      return _liftValueSlot(value);
    }
    if (value is List) {
      return [for (final v in value) _liftScalars(v)];
    }
    return value;
  }

  // -------------------------------------------------------------------------
  // Pass 3 — Structured-literal sugar expansion.
  //
  // Operates on canonicalized Value slots (post pass 2). Recognized sugar:
  //   * EdgeInsets / BorderRadius / Border `{all: x}` → expand to all
  //     declared sub-fields.
  //   * EdgeInsets `{horizontal: x}` → `{left: x, right: x}`.
  //   * EdgeInsets `{vertical: x}` → `{top: x, bottom: x}`.
  //   * Alignment preset string → `{x, y}` per registry.
  //   * Short-form color `#rgb` / `#rgba` / `#rrggbb` → `#rrggbbaa`
  //     (lowercase).
  //   * int at a `double` position — coerced to double.
  //
  // Detection is heuristic, scoped to a Value's literal body.

  // Sugar that uses `all` is ambiguous without context. Pick the right
  // expansion based on the enclosing prop name. Defaults to EdgeInsets
  // for unrecognized parents (matches the broader spec sugar table).
  static const _borderRadiusKeys = <String>{'borderRadius'};
  static const _borderKeys = <String>{'border'};
  // EdgeInsets is the default for `all`/`horizontal`/`vertical`.

  Object? _expandStructuredLiterals(Object? value, {String? parentKey}) {
    if (value is Map<String, Object?>) {
      final out = <String, Object?>{};
      for (final entry in value.entries) {
        if (entry.key == 'value') {
          out[entry.key] = _expandLiteralBody(entry.value, parentKey: parentKey);
        } else {
          out[entry.key] = _expandStructuredLiterals(entry.value, parentKey: entry.key);
        }
      }
      return out;
    }
    if (value is List) {
      return [for (final v in value) _expandStructuredLiterals(v)];
    }
    return value;
  }

  Object? _expandLiteralBody(Object? body, {String? parentKey}) {
    if (body is String) {
      return _normalizeColorString(body) ?? _expandAlignmentPreset(body) ?? body;
    }
    if (body is Map<String, Object?>) {
      var working = body;
      if (_borderRadiusKeys.contains(parentKey)) {
        working = _expandBorderRadiusSugar(working);
      } else if (_borderKeys.contains(parentKey)) {
        working = _expandBorderSugar(working);
      } else {
        // Default sugar (EdgeInsets — `all`/`horizontal`/`vertical`).
        working = _expandEdgeInsetsSugar(working);
      }
      // Recurse into sub-fields (each is itself a Value), passing the
      // sub-field key as parent context for nested literals.
      return {
        for (final entry in working.entries)
          entry.key: _expandStructuredLiterals(entry.value, parentKey: entry.key),
      };
    }
    return _expandStructuredLiterals(body, parentKey: parentKey);
  }

  String? _normalizeColorString(String input) {
    final hex = input.startsWith('#') ? input.substring(1) : null;
    if (hex == null) return null;
    if (hex.length == 3) {
      final r = hex[0] * 2;
      final g = hex[1] * 2;
      final b = hex[2] * 2;
      return '#$r$g${b}ff'.toLowerCase();
    }
    if (hex.length == 4) {
      final r = hex[0] * 2;
      final g = hex[1] * 2;
      final b = hex[2] * 2;
      final a = hex[3] * 2;
      return '#$r$g$b$a'.toLowerCase();
    }
    if (hex.length == 6) {
      return '#${hex}ff'.toLowerCase();
    }
    if (hex.length == 8) {
      return '#$hex'.toLowerCase();
    }
    return null;
  }

  Map<String, Object?>? _expandAlignmentPreset(String preset) {
    const presets = <String, (double, double)>{
      'topLeft': (-1, -1),
      'topCenter': (0, -1),
      'topRight': (1, -1),
      'centerLeft': (-1, 0),
      'center': (0, 0),
      'centerRight': (1, 0),
      'bottomLeft': (-1, 1),
      'bottomCenter': (0, 1),
      'bottomRight': (1, 1),
    };
    final coords = presets[preset];
    if (coords == null) return null;
    return {
      'x': {'value': coords.$1},
      'y': {'value': coords.$2},
    };
  }

  Map<String, Object?> _expandEdgeInsetsSugar(Map<String, Object?> body) {
    if (!body.containsKey('all') &&
        !body.containsKey('horizontal') &&
        !body.containsKey('vertical')) {
      return body;
    }
    final out = <String, Object?>{...body};
    final all = out.remove('all');
    final horizontal = out.remove('horizontal');
    final vertical = out.remove('vertical');
    if (all != null) {
      out.putIfAbsent('top', () => all);
      out.putIfAbsent('left', () => all);
      out.putIfAbsent('right', () => all);
      out.putIfAbsent('bottom', () => all);
    }
    if (horizontal != null) {
      out.putIfAbsent('left', () => horizontal);
      out.putIfAbsent('right', () => horizontal);
    }
    if (vertical != null) {
      out.putIfAbsent('top', () => vertical);
      out.putIfAbsent('bottom', () => vertical);
    }
    return out;
  }

  Map<String, Object?> _expandBorderRadiusSugar(Map<String, Object?> body) {
    if (!body.containsKey('all')) return body;
    final out = <String, Object?>{...body};
    final all = out.remove('all');
    if (all != null) {
      out.putIfAbsent('topLeft', () => all);
      out.putIfAbsent('topRight', () => all);
      out.putIfAbsent('bottomLeft', () => all);
      out.putIfAbsent('bottomRight', () => all);
    }
    return out;
  }

  Map<String, Object?> _expandBorderSugar(Map<String, Object?> body) {
    if (!body.containsKey('all')) return body;
    final out = <String, Object?>{...body};
    final all = out.remove('all');
    if (all != null) {
      out.putIfAbsent('top', () => all);
      out.putIfAbsent('left', () => all);
      out.putIfAbsent('right', () => all);
      out.putIfAbsent('bottom', () => all);
    }
    return out;
  }

  // -------------------------------------------------------------------------
  // Pass 4 — Leaf Value normalization (Decision #15).
  //
  // After pass 3, structured literal bodies have all sub-field keys
  // populated as values. This pass ensures every sub-field is a Value
  // object (`{value: x}` or `{token: ...}` or with directives), not a
  // bare scalar. Pass 2 already lifted bare scalars; this is a defensive
  // sweep ensuring idempotency.

  Object? _normalizeLeafValues(Object? value) {
    if (value is Map<String, Object?>) {
      final out = <String, Object?>{};
      for (final entry in value.entries) {
        if (entry.key == 'value' && entry.value is Map<String, Object?>) {
          // Inside a literal body — every sub-field must be a Value
          // object.
          final lit = entry.value as Map<String, Object?>;
          out['value'] = {
            for (final sub in lit.entries)
              sub.key: _ensureValueObject(sub.value),
          };
        } else {
          out[entry.key] = _normalizeLeafValues(entry.value);
        }
      }
      return out;
    }
    if (value is List) {
      return [for (final v in value) _normalizeLeafValues(v)];
    }
    return value;
  }

  Object? _ensureValueObject(Object? value) {
    if (value is num || value is String || value is bool) {
      return {'value': value};
    }
    return _normalizeLeafValues(value);
  }

  // -------------------------------------------------------------------------
  // Pass 5 — Shape pruning (Decision #41 + null-omission).
  //
  // Drops:
  //   * Empty optional arrays at known positions (variants, modifiers,
  //     directives, textDirectives, children, ops, colors, stops).
  //   * Null-valued optional fields (anywhere).

  static const _omittableEmptyArrays = <String>{
    'variants',
    'modifiers',
    'directives',
    'textDirectives',
    'ops',
  };

  Object? _pruneShape(Object? value) {
    if (value is Map<String, Object?>) {
      final out = <String, Object?>{};
      for (final entry in value.entries) {
        if (entry.value == null) continue;
        if (entry.value is List &&
            (entry.value as List).isEmpty &&
            _omittableEmptyArrays.contains(entry.key)) {
          continue;
        }
        final pruned = _pruneShape(entry.value);
        if (pruned == null) continue;
        if (pruned is List &&
            pruned.isEmpty &&
            _omittableEmptyArrays.contains(entry.key)) {
          continue;
        }
        out[entry.key] = pruned;
      }
      return out;
    }
    if (value is List) {
      return [
        for (final v in value)
          if (v != null) _pruneShape(v),
      ];
    }
    return value;
  }

  // -------------------------------------------------------------------------
  // Lex-sort keys (deterministic byte shape).

  Map<String, Object?> _lexSort(Object? value) {
    if (value is! Map<String, Object?>) {
      throw StateError('Canonicalizer expected a Map at root, got $value');
    }
    return _lexSortMap(value);
  }

  Map<String, Object?> _lexSortMap(Map<String, Object?> value) {
    final entries = value.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return {
      for (final entry in entries) entry.key: _lexSortAny(entry.value),
    };
  }

  Object? _lexSortAny(Object? value) {
    if (value is Map<String, Object?>) return _lexSortMap(value);
    if (value is List) return [for (final v in value) _lexSortAny(v)];
    return value;
  }
}
