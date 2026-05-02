/// `Value` primitive, structured literals, and the `HostRef` capability.
///
/// `PropertyValue` is the canonical container for every prop on a
/// `StyleNode` or `ModifierNode` (spec.md §Value primitive). It is a
/// sealed tagged union with three shapes:
///
///   * [ValueLiteral]          — `value` (and optional `directives`)
///   * [ValueToken]            — `token` (and optional `directives`)
///   * [ValueDirectivesOnly]   — `directives`-only, transforms an
///     inherited base
///
/// `HostRef` is **structurally distinct** from a `PropertyValue` (spec.md
/// §Host references). It only appears in positions registered as
/// `host`-typed by the registry (currently `shaderMask.shader`,
/// `clipPath.clipper`).
///
/// 19 typed structured-literal classes live here too. Each provides
/// `fromJson` / `toJson` against its canonical Map shape (every sub-field
/// is itself a `PropertyValue`, per Decision #15). Producer code uses
/// these for type-safe construction; the canonical Map shape is the
/// portable wire format.
library;

import 'package:meta/meta.dart';

import '../_internal.dart' show deepEquals;
import 'directives.dart';

// ---------------------------------------------------------------------------
// PropertyValue — canonical Value primitive

/// Sealed tagged-union for the canonical `Value` shape.
///
/// At least one of `value`, `token`, `directives` must be present.
/// `value` and `token` are mutually exclusive. The schema validator
/// enforces these invariants structurally; this type guarantees them at
/// the Dart level by virtue of being sealed.
@immutable
sealed class PropertyValue {
  const PropertyValue();

  /// Directives applied to this Value, left-to-right. Empty iff none.
  List<DirectiveNode> get directives;

  /// Canonical JSON for this Value. For [ValueLiteral.literal] that is
  /// itself a `Map<String, Object?>` (a structured literal), the Map is
  /// serialized as-is — sub-fields are already in canonical form.
  Map<String, Object?> toJson();

  /// Decode a canonical `Value` object. Returns `null` if the input is
  /// not a Map or violates the at-least-one / mutual-exclusion rules.
  /// Bare scalars are NOT accepted here — Phase 3 canonicalizer wraps
  /// them into `{value: x}` before this method runs.
  static PropertyValue? fromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    final hasValue = json.containsKey('value');
    final hasToken = json.containsKey('token');
    final hasDirectives = json.containsKey('directives');
    if (!hasValue && !hasToken && !hasDirectives) return null;
    if (hasValue && hasToken) return null;

    final List<DirectiveNode> directives;
    if (hasDirectives) {
      final decoded = decodeDirectives(json['directives']);
      if (decoded == null) return null;
      directives = decoded;
    } else {
      directives = const [];
    }

    if (hasValue) {
      final literal = json['value'];
      if (literal == null) return null; // Decision: null literal forbidden.
      return ValueLiteral(literal, directives: directives);
    }
    if (hasToken) {
      final token = json['token'];
      if (token is! String) return null;
      return ValueToken(token, directives: directives);
    }
    if (directives.isEmpty) return null;
    return ValueDirectivesOnly(directives);
  }
}

/// `Value` carrying a literal (primitive scalar, structured-literal Map,
/// or transform-ops list for Matrix4).
@immutable
final class ValueLiteral extends PropertyValue {
  const ValueLiteral(
    this.literal, {
    this.directives = const [],
  });

  /// The literal payload. One of:
  ///   * primitive: `int` / `double` / `num` / `String` / `bool`
  ///   * structured literal: `Map<String, Object?>` whose sub-fields are
  ///     themselves canonical Value objects
  ///   * Matrix4 ops list: `Map<String, Object?>` with an `ops` array
  final Object literal;

  @override
  final List<DirectiveNode> directives;

  @override
  Map<String, Object?> toJson() => {
        'value': literal,
        if (directives.isNotEmpty) 'directives': encodeDirectives(directives),
      };

  @override
  bool operator ==(Object other) =>
      other is ValueLiteral &&
      deepEquals(literal, other.literal) &&
      directivesEqual(directives, other.directives);

  @override
  int get hashCode => Object.hash(
        ValueLiteral,
        deepEqualsHash(literal),
        Object.hashAll(directives),
      );
}

/// `Value` carrying a token reference (`namespace.name`).
@immutable
final class ValueToken extends PropertyValue {
  const ValueToken(
    this.token, {
    this.directives = const [],
  });

  /// Fully qualified token path. The validator (semantic stage) checks
  /// the namespace against the 8 built-ins or `x:` extension grammar.
  final String token;

  @override
  final List<DirectiveNode> directives;

  @override
  Map<String, Object?> toJson() => {
        'token': token,
        if (directives.isNotEmpty) 'directives': encodeDirectives(directives),
      };

  @override
  bool operator ==(Object other) =>
      other is ValueToken &&
      other.token == token &&
      directivesEqual(directives, other.directives);

  @override
  int get hashCode =>
      Object.hash(ValueToken, token, Object.hashAll(directives));
}

/// `Value` carrying only directives — transforms an inherited base.
///
/// At resolution time, when no inherited base exists at the leaf
/// position, the validator/parser raises `directive.no-base`.
@immutable
final class ValueDirectivesOnly extends PropertyValue {
  const ValueDirectivesOnly(this.directives)
      : assert(directives.length > 0, 'directives must not be empty');

  @override
  final List<DirectiveNode> directives;

  @override
  Map<String, Object?> toJson() =>
      {'directives': encodeDirectives(directives)};

  @override
  bool operator ==(Object other) =>
      other is ValueDirectivesOnly &&
      directivesEqual(directives, other.directives);

  @override
  int get hashCode =>
      Object.hash(ValueDirectivesOnly, Object.hashAll(directives));
}

// ---------------------------------------------------------------------------
// HostRef — structurally distinct capability

/// Runtime-resolved indirection for non-serializable surface (custom
/// shaders, clippers). Legal only in positions registered as `host`-typed
/// (`Modifier_clipPath.clipper`, `Modifier_shaderMask.shader`).
@immutable
class HostRef {
  const HostRef(this.id);

  factory HostRef.fromJson(Map<String, Object?> json) {
    final id = json['host'];
    if (id is! String || id.isEmpty) {
      throw FormatException('HostRef requires a non-empty `host` field', json);
    }
    return HostRef(id);
  }

  /// Opaque host identifier. Resolved by the consumer's host registry.
  final String id;

  Map<String, Object?> toJson() => {'host': id};

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is HostRef && other.id == id);

  @override
  int get hashCode => Object.hash(HostRef, id);
}

// ---------------------------------------------------------------------------
// Helper for hashing structured literal Maps via deepEquals semantics.

/// Hash an arbitrary canonical-form value compatibly with [deepEquals].
///
/// Used by `ValueLiteral.hashCode` because the literal field is `Object`
/// (could be a primitive or a Map representing a structured literal).
@visibleForTesting
int deepEqualsHash(Object value) {
  if (value is num) return value.hashCode;
  if (value is String) return value.hashCode;
  if (value is bool) return value.hashCode;
  if (value is Map) {
    final entries = value.entries.toList()
      ..sort((a, b) => '${a.key}'.compareTo('${b.key}'));
    return Object.hashAll([
      for (final e in entries) ...[e.key, deepEqualsHash(e.value as Object)],
    ]);
  }
  if (value is List) {
    return Object.hashAll([for (final v in value) deepEqualsHash(v as Object)]);
  }
  return value.hashCode;
}

// ---------------------------------------------------------------------------
// Structured literals (19 v1.0 shapes).
//
// Each class stores its sub-fields as PropertyValue instances and
// exposes `fromJson` / `toJson` against the canonical leaf-expanded Map
// shape (Decision #15). The Map is what gets stored inside a
// `ValueLiteral.literal`.

/// Helpers to read/write a `Map<String, PropertyValue>` sub-field set.
PropertyValue? _readSub(Object? raw) {
  if (raw == null) return null;
  return PropertyValue.fromJson(raw);
}

PropertyValue _readSubRequired(Object? raw, String field) {
  final pv = _readSub(raw);
  if (pv == null) {
    throw FormatException('Structured literal missing required sub-field "$field"');
  }
  return pv;
}

void _writeSub(Map<String, Object?> out, String field, PropertyValue? value) {
  if (value != null) out[field] = value.toJson();
}

bool _subsEqual(Map<String, PropertyValue?> a, Map<String, PropertyValue?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (entry.value != b[entry.key]) return false;
  }
  return true;
}

@immutable
class EdgeInsetsLiteral {
  const EdgeInsetsLiteral({this.top, this.left, this.right, this.bottom});
  factory EdgeInsetsLiteral.fromJson(Map<String, Object?> json) =>
      EdgeInsetsLiteral(
        top: _readSub(json['top']),
        left: _readSub(json['left']),
        right: _readSub(json['right']),
        bottom: _readSub(json['bottom']),
      );
  final PropertyValue? top;
  final PropertyValue? left;
  final PropertyValue? right;
  final PropertyValue? bottom;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'top', top);
    _writeSub(out, 'left', left);
    _writeSub(out, 'right', right);
    _writeSub(out, 'bottom', bottom);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is EdgeInsetsLiteral &&
      top == other.top &&
      left == other.left &&
      right == other.right &&
      bottom == other.bottom;
  @override
  int get hashCode => Object.hash(EdgeInsetsLiteral, top, left, right, bottom);
}

@immutable
class BorderRadiusLiteral {
  const BorderRadiusLiteral(
      {this.topLeft, this.topRight, this.bottomLeft, this.bottomRight});
  factory BorderRadiusLiteral.fromJson(Map<String, Object?> json) =>
      BorderRadiusLiteral(
        topLeft: _readSub(json['topLeft']),
        topRight: _readSub(json['topRight']),
        bottomLeft: _readSub(json['bottomLeft']),
        bottomRight: _readSub(json['bottomRight']),
      );
  final PropertyValue? topLeft;
  final PropertyValue? topRight;
  final PropertyValue? bottomLeft;
  final PropertyValue? bottomRight;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'topLeft', topLeft);
    _writeSub(out, 'topRight', topRight);
    _writeSub(out, 'bottomLeft', bottomLeft);
    _writeSub(out, 'bottomRight', bottomRight);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is BorderRadiusLiteral &&
      topLeft == other.topLeft &&
      topRight == other.topRight &&
      bottomLeft == other.bottomLeft &&
      bottomRight == other.bottomRight;
  @override
  int get hashCode =>
      Object.hash(BorderRadiusLiteral, topLeft, topRight, bottomLeft, bottomRight);
}

@immutable
class BoxConstraintsLiteral {
  const BoxConstraintsLiteral(
      {this.minWidth, this.maxWidth, this.minHeight, this.maxHeight});
  factory BoxConstraintsLiteral.fromJson(Map<String, Object?> json) =>
      BoxConstraintsLiteral(
        minWidth: _readSub(json['minWidth']),
        maxWidth: _readSub(json['maxWidth']),
        minHeight: _readSub(json['minHeight']),
        maxHeight: _readSub(json['maxHeight']),
      );
  final PropertyValue? minWidth;
  final PropertyValue? maxWidth;
  final PropertyValue? minHeight;
  final PropertyValue? maxHeight;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'minWidth', minWidth);
    _writeSub(out, 'maxWidth', maxWidth);
    _writeSub(out, 'minHeight', minHeight);
    _writeSub(out, 'maxHeight', maxHeight);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is BoxConstraintsLiteral &&
      minWidth == other.minWidth &&
      maxWidth == other.maxWidth &&
      minHeight == other.minHeight &&
      maxHeight == other.maxHeight;
  @override
  int get hashCode => Object.hash(
      BoxConstraintsLiteral, minWidth, maxWidth, minHeight, maxHeight);
}

@immutable
class SizeLiteral {
  const SizeLiteral({this.width, this.height});
  factory SizeLiteral.fromJson(Map<String, Object?> json) => SizeLiteral(
        width: _readSub(json['width']),
        height: _readSub(json['height']),
      );
  final PropertyValue? width;
  final PropertyValue? height;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'width', width);
    _writeSub(out, 'height', height);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is SizeLiteral && width == other.width && height == other.height;
  @override
  int get hashCode => Object.hash(SizeLiteral, width, height);
}

@immutable
class OffsetLiteral {
  const OffsetLiteral({this.dx, this.dy});
  factory OffsetLiteral.fromJson(Map<String, Object?> json) => OffsetLiteral(
        dx: _readSub(json['dx']),
        dy: _readSub(json['dy']),
      );
  final PropertyValue? dx;
  final PropertyValue? dy;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'dx', dx);
    _writeSub(out, 'dy', dy);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is OffsetLiteral && dx == other.dx && dy == other.dy;
  @override
  int get hashCode => Object.hash(OffsetLiteral, dx, dy);
}

@immutable
class RectLiteral {
  const RectLiteral({this.left, this.top, this.right, this.bottom});
  factory RectLiteral.fromJson(Map<String, Object?> json) => RectLiteral(
        left: _readSub(json['left']),
        top: _readSub(json['top']),
        right: _readSub(json['right']),
        bottom: _readSub(json['bottom']),
      );
  final PropertyValue? left;
  final PropertyValue? top;
  final PropertyValue? right;
  final PropertyValue? bottom;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'left', left);
    _writeSub(out, 'top', top);
    _writeSub(out, 'right', right);
    _writeSub(out, 'bottom', bottom);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is RectLiteral &&
      left == other.left &&
      top == other.top &&
      right == other.right &&
      bottom == other.bottom;
  @override
  int get hashCode => Object.hash(RectLiteral, left, top, right, bottom);
}

@immutable
class AlignmentLiteral {
  const AlignmentLiteral({this.x, this.y});
  factory AlignmentLiteral.fromJson(Map<String, Object?> json) =>
      AlignmentLiteral(
        x: _readSub(json['x']),
        y: _readSub(json['y']),
      );
  final PropertyValue? x;
  final PropertyValue? y;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'x', x);
    _writeSub(out, 'y', y);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is AlignmentLiteral && x == other.x && y == other.y;
  @override
  int get hashCode => Object.hash(AlignmentLiteral, x, y);
}

// Matrix4 — ordered transform-ops list with `op` discriminator.

@immutable
sealed class Matrix4Op {
  const Matrix4Op();
  String get op;
  Map<String, Object?> toJson();

  static Matrix4Op? fromJson(Map<String, Object?> json) {
    final op = json['op'];
    if (op is! String) return null;
    return switch (op) {
      'identity' => const Matrix4Identity(),
      'translate' => Matrix4Translate(
          x: _readSubRequired(json['x'], 'x'),
          y: _readSubRequired(json['y'], 'y'),
        ),
      'scale' => Matrix4Scale(
          x: _readSubRequired(json['x'], 'x'),
          y: _readSubRequired(json['y'], 'y'),
        ),
      'rotateZ' =>
        Matrix4RotateZ(radians: _readSubRequired(json['radians'], 'radians')),
      _ => null,
    };
  }
}

@immutable
class Matrix4Identity extends Matrix4Op {
  const Matrix4Identity();
  @override
  String get op => 'identity';
  @override
  Map<String, Object?> toJson() => {'op': op};
  @override
  bool operator ==(Object other) => other is Matrix4Identity;
  @override
  int get hashCode => 'matrix4.identity'.hashCode;
}

@immutable
class Matrix4Translate extends Matrix4Op {
  const Matrix4Translate({required this.x, required this.y});
  final PropertyValue x;
  final PropertyValue y;
  @override
  String get op => 'translate';
  @override
  Map<String, Object?> toJson() => {'op': op, 'x': x.toJson(), 'y': y.toJson()};
  @override
  bool operator ==(Object other) =>
      other is Matrix4Translate && other.x == x && other.y == y;
  @override
  int get hashCode => Object.hash(Matrix4Translate, x, y);
}

@immutable
class Matrix4Scale extends Matrix4Op {
  const Matrix4Scale({required this.x, required this.y});
  final PropertyValue x;
  final PropertyValue y;
  @override
  String get op => 'scale';
  @override
  Map<String, Object?> toJson() => {'op': op, 'x': x.toJson(), 'y': y.toJson()};
  @override
  bool operator ==(Object other) =>
      other is Matrix4Scale && other.x == x && other.y == y;
  @override
  int get hashCode => Object.hash(Matrix4Scale, x, y);
}

@immutable
class Matrix4RotateZ extends Matrix4Op {
  const Matrix4RotateZ({required this.radians});
  final PropertyValue radians;
  @override
  String get op => 'rotateZ';
  @override
  Map<String, Object?> toJson() => {'op': op, 'radians': radians.toJson()};
  @override
  bool operator ==(Object other) =>
      other is Matrix4RotateZ && other.radians == radians;
  @override
  int get hashCode => Object.hash(Matrix4RotateZ, radians);
}

@immutable
class Matrix4Literal {
  const Matrix4Literal(this.ops);
  factory Matrix4Literal.fromJson(Map<String, Object?> json) {
    final raw = json['ops'];
    if (raw is! List) {
      throw FormatException('Matrix4 literal requires "ops" array');
    }
    return Matrix4Literal([
      for (final entry in raw)
        if (entry is Map<String, Object?>) Matrix4Op.fromJson(entry)!,
    ]);
  }
  final List<Matrix4Op> ops;
  Map<String, Object?> toJson() => {'ops': [for (final op in ops) op.toJson()]};

  @override
  bool operator ==(Object other) {
    if (other is! Matrix4Literal) return false;
    if (other.ops.length != ops.length) return false;
    for (var i = 0; i < ops.length; i++) {
      if (other.ops[i] != ops[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(Matrix4Literal, Object.hashAll(ops));
}

@immutable
class ShadowLiteral {
  const ShadowLiteral({this.color, this.offset, this.blurRadius});
  factory ShadowLiteral.fromJson(Map<String, Object?> json) => ShadowLiteral(
        color: _readSub(json['color']),
        offset: _readSub(json['offset']),
        blurRadius: _readSub(json['blurRadius']),
      );
  final PropertyValue? color;
  final PropertyValue? offset;
  final PropertyValue? blurRadius;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'color', color);
    _writeSub(out, 'offset', offset);
    _writeSub(out, 'blurRadius', blurRadius);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is ShadowLiteral &&
      color == other.color &&
      offset == other.offset &&
      blurRadius == other.blurRadius;
  @override
  int get hashCode => Object.hash(ShadowLiteral, color, offset, blurRadius);
}

@immutable
class BorderSideLiteral {
  const BorderSideLiteral({this.color, this.width, this.style});
  factory BorderSideLiteral.fromJson(Map<String, Object?> json) =>
      BorderSideLiteral(
        color: _readSub(json['color']),
        width: _readSub(json['width']),
        style: _readSub(json['style']),
      );
  final PropertyValue? color;
  final PropertyValue? width;
  final PropertyValue? style;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'color', color);
    _writeSub(out, 'width', width);
    _writeSub(out, 'style', style);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is BorderSideLiteral &&
      color == other.color &&
      width == other.width &&
      style == other.style;
  @override
  int get hashCode => Object.hash(BorderSideLiteral, color, width, style);
}

@immutable
class BorderLiteral {
  const BorderLiteral({this.top, this.left, this.right, this.bottom});
  factory BorderLiteral.fromJson(Map<String, Object?> json) => BorderLiteral(
        top: _readSub(json['top']),
        left: _readSub(json['left']),
        right: _readSub(json['right']),
        bottom: _readSub(json['bottom']),
      );
  final PropertyValue? top;
  final PropertyValue? left;
  final PropertyValue? right;
  final PropertyValue? bottom;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'top', top);
    _writeSub(out, 'left', left);
    _writeSub(out, 'right', right);
    _writeSub(out, 'bottom', bottom);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is BorderLiteral &&
      top == other.top &&
      left == other.left &&
      right == other.right &&
      bottom == other.bottom;
  @override
  int get hashCode => Object.hash(BorderLiteral, top, left, right, bottom);
}

@immutable
class DecorationLiteral {
  const DecorationLiteral({
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.boxShadow,
    this.shape,
  });
  factory DecorationLiteral.fromJson(Map<String, Object?> json) =>
      DecorationLiteral(
        color: _readSub(json['color']),
        borderRadius: _readSub(json['borderRadius']),
        border: _readSub(json['border']),
        gradient: _readSub(json['gradient']),
        boxShadow: _readSub(json['boxShadow']),
        shape: _readSub(json['shape']),
      );
  final PropertyValue? color;
  final PropertyValue? borderRadius;
  final PropertyValue? border;
  final PropertyValue? gradient;
  final PropertyValue? boxShadow;
  final PropertyValue? shape;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'color', color);
    _writeSub(out, 'borderRadius', borderRadius);
    _writeSub(out, 'border', border);
    _writeSub(out, 'gradient', gradient);
    _writeSub(out, 'boxShadow', boxShadow);
    _writeSub(out, 'shape', shape);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is DecorationLiteral &&
      color == other.color &&
      borderRadius == other.borderRadius &&
      border == other.border &&
      gradient == other.gradient &&
      boxShadow == other.boxShadow &&
      shape == other.shape;
  @override
  int get hashCode => Object.hash(
        DecorationLiteral,
        color,
        borderRadius,
        border,
        gradient,
        boxShadow,
        shape,
      );
}

// Gradient — kind-discriminated tagged union (linear / radial / sweep).

@immutable
sealed class GradientLiteral {
  const GradientLiteral();
  String get kind;
  Map<String, Object?> toJson();

  factory GradientLiteral.fromJson(Map<String, Object?> json) {
    final kind = json['kind'];
    if (kind is! String) {
      throw FormatException('Gradient literal requires "kind" discriminator');
    }
    return switch (kind) {
      'linear' => LinearGradientLiteral.fromJson(json),
      'radial' => RadialGradientLiteral.fromJson(json),
      'sweep' => SweepGradientLiteral.fromJson(json),
      _ => throw FormatException('Unknown gradient kind "$kind"'),
    };
  }
}

@immutable
class LinearGradientLiteral extends GradientLiteral {
  const LinearGradientLiteral(
      {this.begin, this.end, this.colors, this.stops});
  factory LinearGradientLiteral.fromJson(Map<String, Object?> json) =>
      LinearGradientLiteral(
        begin: _readSub(json['begin']),
        end: _readSub(json['end']),
        colors: _readSub(json['colors']),
        stops: _readSub(json['stops']),
      );
  final PropertyValue? begin;
  final PropertyValue? end;
  final PropertyValue? colors;
  final PropertyValue? stops;
  @override
  String get kind => 'linear';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'kind': kind};
    _writeSub(out, 'begin', begin);
    _writeSub(out, 'end', end);
    _writeSub(out, 'colors', colors);
    _writeSub(out, 'stops', stops);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is LinearGradientLiteral &&
      begin == other.begin &&
      end == other.end &&
      colors == other.colors &&
      stops == other.stops;
  @override
  int get hashCode =>
      Object.hash(LinearGradientLiteral, begin, end, colors, stops);
}

@immutable
class RadialGradientLiteral extends GradientLiteral {
  const RadialGradientLiteral(
      {this.center, this.radius, this.colors, this.stops});
  factory RadialGradientLiteral.fromJson(Map<String, Object?> json) =>
      RadialGradientLiteral(
        center: _readSub(json['center']),
        radius: _readSub(json['radius']),
        colors: _readSub(json['colors']),
        stops: _readSub(json['stops']),
      );
  final PropertyValue? center;
  final PropertyValue? radius;
  final PropertyValue? colors;
  final PropertyValue? stops;
  @override
  String get kind => 'radial';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'kind': kind};
    _writeSub(out, 'center', center);
    _writeSub(out, 'radius', radius);
    _writeSub(out, 'colors', colors);
    _writeSub(out, 'stops', stops);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is RadialGradientLiteral &&
      center == other.center &&
      radius == other.radius &&
      colors == other.colors &&
      stops == other.stops;
  @override
  int get hashCode =>
      Object.hash(RadialGradientLiteral, center, radius, colors, stops);
}

@immutable
class SweepGradientLiteral extends GradientLiteral {
  const SweepGradientLiteral({
    this.center,
    this.startAngle,
    this.endAngle,
    this.colors,
    this.stops,
  });
  factory SweepGradientLiteral.fromJson(Map<String, Object?> json) =>
      SweepGradientLiteral(
        center: _readSub(json['center']),
        startAngle: _readSub(json['startAngle']),
        endAngle: _readSub(json['endAngle']),
        colors: _readSub(json['colors']),
        stops: _readSub(json['stops']),
      );
  final PropertyValue? center;
  final PropertyValue? startAngle;
  final PropertyValue? endAngle;
  final PropertyValue? colors;
  final PropertyValue? stops;
  @override
  String get kind => 'sweep';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'kind': kind};
    _writeSub(out, 'center', center);
    _writeSub(out, 'startAngle', startAngle);
    _writeSub(out, 'endAngle', endAngle);
    _writeSub(out, 'colors', colors);
    _writeSub(out, 'stops', stops);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is SweepGradientLiteral &&
      center == other.center &&
      startAngle == other.startAngle &&
      endAngle == other.endAngle &&
      colors == other.colors &&
      stops == other.stops;
  @override
  int get hashCode => Object.hash(
      SweepGradientLiteral, center, startAngle, endAngle, colors, stops);
}

@immutable
class TextStyleLiteral {
  const TextStyleLiteral({
    this.color,
    this.backgroundColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.shadows,
  });
  factory TextStyleLiteral.fromJson(Map<String, Object?> json) =>
      TextStyleLiteral(
        color: _readSub(json['color']),
        backgroundColor: _readSub(json['backgroundColor']),
        fontFamily: _readSub(json['fontFamily']),
        fontSize: _readSub(json['fontSize']),
        fontWeight: _readSub(json['fontWeight']),
        fontStyle: _readSub(json['fontStyle']),
        letterSpacing: _readSub(json['letterSpacing']),
        wordSpacing: _readSub(json['wordSpacing']),
        height: _readSub(json['height']),
        decoration: _readSub(json['decoration']),
        decorationColor: _readSub(json['decorationColor']),
        decorationStyle: _readSub(json['decorationStyle']),
        decorationThickness: _readSub(json['decorationThickness']),
        shadows: _readSub(json['shadows']),
      );
  final PropertyValue? color;
  final PropertyValue? backgroundColor;
  final PropertyValue? fontFamily;
  final PropertyValue? fontSize;
  final PropertyValue? fontWeight;
  final PropertyValue? fontStyle;
  final PropertyValue? letterSpacing;
  final PropertyValue? wordSpacing;
  final PropertyValue? height;
  final PropertyValue? decoration;
  final PropertyValue? decorationColor;
  final PropertyValue? decorationStyle;
  final PropertyValue? decorationThickness;
  final PropertyValue? shadows;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'color', color);
    _writeSub(out, 'backgroundColor', backgroundColor);
    _writeSub(out, 'fontFamily', fontFamily);
    _writeSub(out, 'fontSize', fontSize);
    _writeSub(out, 'fontWeight', fontWeight);
    _writeSub(out, 'fontStyle', fontStyle);
    _writeSub(out, 'letterSpacing', letterSpacing);
    _writeSub(out, 'wordSpacing', wordSpacing);
    _writeSub(out, 'height', height);
    _writeSub(out, 'decoration', decoration);
    _writeSub(out, 'decorationColor', decorationColor);
    _writeSub(out, 'decorationStyle', decorationStyle);
    _writeSub(out, 'decorationThickness', decorationThickness);
    _writeSub(out, 'shadows', shadows);
    return out;
  }

  @override
  bool operator ==(Object other) {
    if (other is! TextStyleLiteral) return false;
    return _subsEqual(_asMap(), other._asMap());
  }

  Map<String, PropertyValue?> _asMap() => {
        'color': color,
        'backgroundColor': backgroundColor,
        'fontFamily': fontFamily,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
        'fontStyle': fontStyle,
        'letterSpacing': letterSpacing,
        'wordSpacing': wordSpacing,
        'height': height,
        'decoration': decoration,
        'decorationColor': decorationColor,
        'decorationStyle': decorationStyle,
        'decorationThickness': decorationThickness,
        'shadows': shadows,
      };

  @override
  int get hashCode => Object.hashAll([
        TextStyleLiteral,
        ..._asMap().entries.map((e) => Object.hash(e.key, e.value)),
      ]);
}

@immutable
class StrutStyleLiteral {
  const StrutStyleLiteral({
    this.fontFamily,
    this.fontSize,
    this.height,
    this.leading,
    this.forceStrutHeight,
  });
  factory StrutStyleLiteral.fromJson(Map<String, Object?> json) =>
      StrutStyleLiteral(
        fontFamily: _readSub(json['fontFamily']),
        fontSize: _readSub(json['fontSize']),
        height: _readSub(json['height']),
        leading: _readSub(json['leading']),
        forceStrutHeight: _readSub(json['forceStrutHeight']),
      );
  final PropertyValue? fontFamily;
  final PropertyValue? fontSize;
  final PropertyValue? height;
  final PropertyValue? leading;
  final PropertyValue? forceStrutHeight;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'fontFamily', fontFamily);
    _writeSub(out, 'fontSize', fontSize);
    _writeSub(out, 'height', height);
    _writeSub(out, 'leading', leading);
    _writeSub(out, 'forceStrutHeight', forceStrutHeight);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is StrutStyleLiteral &&
      fontFamily == other.fontFamily &&
      fontSize == other.fontSize &&
      height == other.height &&
      leading == other.leading &&
      forceStrutHeight == other.forceStrutHeight;
  @override
  int get hashCode => Object.hash(
      StrutStyleLiteral, fontFamily, fontSize, height, leading, forceStrutHeight);
}

// TextScaler — kind-discriminated (linear / noScaling).

@immutable
sealed class TextScalerLiteral {
  const TextScalerLiteral();
  String get kind;
  Map<String, Object?> toJson();
  factory TextScalerLiteral.fromJson(Map<String, Object?> json) {
    final kind = json['kind'];
    return switch (kind) {
      'linear' => TextScalerLinearLiteral(
          scaleFactor: _readSubRequired(json['scaleFactor'], 'scaleFactor')),
      'noScaling' => const TextScalerNoScalingLiteral(),
      _ => throw FormatException('Unknown TextScaler kind "$kind"'),
    };
  }
}

@immutable
class TextScalerLinearLiteral extends TextScalerLiteral {
  const TextScalerLinearLiteral({required this.scaleFactor});
  final PropertyValue scaleFactor;
  @override
  String get kind => 'linear';
  @override
  Map<String, Object?> toJson() =>
      {'kind': kind, 'scaleFactor': scaleFactor.toJson()};
  @override
  bool operator ==(Object other) =>
      other is TextScalerLinearLiteral && scaleFactor == other.scaleFactor;
  @override
  int get hashCode => Object.hash(TextScalerLinearLiteral, scaleFactor);
}

@immutable
class TextScalerNoScalingLiteral extends TextScalerLiteral {
  const TextScalerNoScalingLiteral();
  @override
  String get kind => 'noScaling';
  @override
  Map<String, Object?> toJson() => {'kind': kind};
  @override
  bool operator ==(Object other) => other is TextScalerNoScalingLiteral;
  @override
  int get hashCode => 'textscaler.noscaling'.hashCode;
}

@immutable
class TextHeightBehaviorLiteral {
  const TextHeightBehaviorLiteral(
      {this.applyHeightToFirstAscent, this.applyHeightToLastDescent});
  factory TextHeightBehaviorLiteral.fromJson(Map<String, Object?> json) =>
      TextHeightBehaviorLiteral(
        applyHeightToFirstAscent: _readSub(json['applyHeightToFirstAscent']),
        applyHeightToLastDescent: _readSub(json['applyHeightToLastDescent']),
      );
  final PropertyValue? applyHeightToFirstAscent;
  final PropertyValue? applyHeightToLastDescent;
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    _writeSub(out, 'applyHeightToFirstAscent', applyHeightToFirstAscent);
    _writeSub(out, 'applyHeightToLastDescent', applyHeightToLastDescent);
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is TextHeightBehaviorLiteral &&
      applyHeightToFirstAscent == other.applyHeightToFirstAscent &&
      applyHeightToLastDescent == other.applyHeightToLastDescent;
  @override
  int get hashCode => Object.hash(TextHeightBehaviorLiteral,
      applyHeightToFirstAscent, applyHeightToLastDescent);
}

// Icon — source-discriminated (material / cupertino / custom).

@immutable
sealed class IconLiteral {
  const IconLiteral();
  String get source;
  Map<String, Object?> toJson();
  factory IconLiteral.fromJson(Map<String, Object?> json) {
    final source = json['source'];
    return switch (source) {
      'material' => IconMaterialLiteral(name: json['name']! as String),
      'cupertino' => IconCupertinoLiteral(name: json['name']! as String),
      'custom' => IconCustomLiteral(
          family: json['family']! as String,
          codePoint: json['codePoint']! as int,
        ),
      _ => throw FormatException('Unknown Icon source "$source"'),
    };
  }
}

@immutable
class IconMaterialLiteral extends IconLiteral {
  const IconMaterialLiteral({required this.name});
  final String name;
  @override
  String get source => 'material';
  @override
  Map<String, Object?> toJson() => {'source': source, 'name': name};
  @override
  bool operator ==(Object other) =>
      other is IconMaterialLiteral && other.name == name;
  @override
  int get hashCode => Object.hash(IconMaterialLiteral, name);
}

@immutable
class IconCupertinoLiteral extends IconLiteral {
  const IconCupertinoLiteral({required this.name});
  final String name;
  @override
  String get source => 'cupertino';
  @override
  Map<String, Object?> toJson() => {'source': source, 'name': name};
  @override
  bool operator ==(Object other) =>
      other is IconCupertinoLiteral && other.name == name;
  @override
  int get hashCode => Object.hash(IconCupertinoLiteral, name);
}

@immutable
class IconCustomLiteral extends IconLiteral {
  const IconCustomLiteral({required this.family, required this.codePoint});
  final String family;
  final int codePoint;
  @override
  String get source => 'custom';
  @override
  Map<String, Object?> toJson() =>
      {'source': source, 'family': family, 'codePoint': codePoint};
  @override
  bool operator ==(Object other) =>
      other is IconCustomLiteral &&
      other.family == family &&
      other.codePoint == codePoint;
  @override
  int get hashCode => Object.hash(IconCustomLiteral, family, codePoint);
}

// Image — source-discriminated (asset / network / host). The `host`
// source is structurally distinct from a `HostRef` (which appears only
// at modifier `clipper`/`shader` positions).

@immutable
sealed class ImageLiteral {
  const ImageLiteral();
  String get source;
  Map<String, Object?> toJson();
  factory ImageLiteral.fromJson(Map<String, Object?> json) {
    final source = json['source'];
    return switch (source) {
      'asset' => ImageAssetLiteral(path: json['path']! as String),
      'network' => ImageNetworkLiteral(url: json['url']! as String),
      'host' => ImageHostLiteral(id: json['id']! as String),
      _ => throw FormatException('Unknown Image source "$source"'),
    };
  }
}

@immutable
class ImageAssetLiteral extends ImageLiteral {
  const ImageAssetLiteral({required this.path});
  final String path;
  @override
  String get source => 'asset';
  @override
  Map<String, Object?> toJson() => {'source': source, 'path': path};
  @override
  bool operator ==(Object other) =>
      other is ImageAssetLiteral && other.path == path;
  @override
  int get hashCode => Object.hash(ImageAssetLiteral, path);
}

@immutable
class ImageNetworkLiteral extends ImageLiteral {
  const ImageNetworkLiteral({required this.url});
  final String url;
  @override
  String get source => 'network';
  @override
  Map<String, Object?> toJson() => {'source': source, 'url': url};
  @override
  bool operator ==(Object other) =>
      other is ImageNetworkLiteral && other.url == url;
  @override
  int get hashCode => Object.hash(ImageNetworkLiteral, url);
}

@immutable
class ImageHostLiteral extends ImageLiteral {
  const ImageHostLiteral({required this.id});
  final String id;
  @override
  String get source => 'host';
  @override
  Map<String, Object?> toJson() => {'source': source, 'id': id};
  @override
  bool operator ==(Object other) =>
      other is ImageHostLiteral && other.id == id;
  @override
  int get hashCode => Object.hash(ImageHostLiteral, id);
}
