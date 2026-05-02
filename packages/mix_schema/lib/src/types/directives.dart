/// Directive catalog — 27 ops grouped by target type (color/string/number).
///
/// Directives transform a leaf Value left-to-right. They never appear at a
/// structured-literal root — only on leaf positions inside literal
/// sub-fields (spec.md §Directives, Decision #14).
///
/// The 3 marker mixins (`ColorDirective`, `StringDirective`,
/// `NumberDirective`) declare a directive's target type. The semantic
/// validator (Phase 4 stage 4) uses these to enforce
/// `directive.type-mismatch` against the enclosing leaf type.
library;

import 'package:meta/meta.dart';

import '../_internal.dart' show deepEquals;

/// Marker mixin for directives that transform a `Color` target.
mixin ColorDirective on DirectiveNode {}

/// Marker mixin for directives that transform a `String` target.
mixin StringDirective on DirectiveNode {}

/// Marker mixin for directives that transform a `num` target.
mixin NumberDirective on DirectiveNode {}

/// Tagged-union root for the 27 directive ops.
@immutable
sealed class DirectiveNode {
  const DirectiveNode();

  /// The op string (e.g. `"darken"`, `"multiply"`, `"uppercase"`).
  String get op;

  /// Canonical JSON. Always a single-key-per-prop object discriminated by
  /// `op`.
  Map<String, Object?> toJson();

  /// Parse a canonical directive from JSON. Returns `null` when the `op`
  /// field is absent or unknown — callers (Phase 4 validator) raise
  /// `directive.unknown` in that case.
  static DirectiveNode? fromJson(Map<String, Object?> json) {
    final op = json['op'];
    if (op is! String) return null;
    return switch (op) {
      // color
      'opacity' => DirectiveOpacity._fromJson(json),
      'withValues' => DirectiveWithValues._fromJson(json),
      'alpha' => DirectiveAlpha._fromJson(json),
      'darken' => DirectiveDarken._fromJson(json),
      'lighten' => DirectiveLighten._fromJson(json),
      'saturate' => DirectiveSaturate._fromJson(json),
      'desaturate' => DirectiveDesaturate._fromJson(json),
      'tint' => DirectiveTint._fromJson(json),
      'shade' => DirectiveShade._fromJson(json),
      'brighten' => DirectiveBrighten._fromJson(json),
      'withRed' => DirectiveWithRed._fromJson(json),
      'withGreen' => DirectiveWithGreen._fromJson(json),
      'withBlue' => DirectiveWithBlue._fromJson(json),
      // string
      'capitalize' => const DirectiveCapitalize(),
      'uppercase' => const DirectiveUppercase(),
      'lowercase' => const DirectiveLowercase(),
      'titleCase' => const DirectiveTitleCase(),
      'sentenceCase' => const DirectiveSentenceCase(),
      // number
      'multiply' => DirectiveMultiply._fromJson(json),
      'add' => DirectiveAdd._fromJson(json),
      'subtract' => DirectiveSubtract._fromJson(json),
      'divide' => DirectiveDivide._fromJson(json),
      'clamp' => DirectiveClamp._fromJson(json),
      'abs' => const DirectiveAbs(),
      'round' => const DirectiveRound(),
      'floor' => const DirectiveFloor(),
      'ceil' => const DirectiveCeil(),
      _ => null,
    };
  }
}

// ---------------------------------------------------------------------------
// Color directives (13 ops)

@immutable
class DirectiveOpacity extends DirectiveNode with ColorDirective {
  const DirectiveOpacity(this.value);
  factory DirectiveOpacity._fromJson(Map<String, Object?> json) =>
      DirectiveOpacity((json['value'] as num).toDouble());
  final double value;
  @override
  String get op => 'opacity';
  @override
  Map<String, Object?> toJson() => {'op': op, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is DirectiveOpacity && other.value == value;
  @override
  int get hashCode => Object.hash(op, value);
}

@immutable
class DirectiveWithValues extends DirectiveNode with ColorDirective {
  const DirectiveWithValues({this.alpha, this.red, this.green, this.blue});
  factory DirectiveWithValues._fromJson(Map<String, Object?> json) =>
      DirectiveWithValues(
        alpha: (json['alpha'] as num?)?.toDouble(),
        red: (json['red'] as num?)?.toDouble(),
        green: (json['green'] as num?)?.toDouble(),
        blue: (json['blue'] as num?)?.toDouble(),
      );
  final double? alpha;
  final double? red;
  final double? green;
  final double? blue;
  @override
  String get op => 'withValues';
  @override
  Map<String, Object?> toJson() => {
        'op': op,
        if (alpha != null) 'alpha': alpha,
        if (red != null) 'red': red,
        if (green != null) 'green': green,
        if (blue != null) 'blue': blue,
      };
  @override
  bool operator ==(Object other) =>
      other is DirectiveWithValues &&
      other.alpha == alpha &&
      other.red == red &&
      other.green == green &&
      other.blue == blue;
  @override
  int get hashCode => Object.hash(op, alpha, red, green, blue);
}

@immutable
class DirectiveAlpha extends DirectiveNode with ColorDirective {
  const DirectiveAlpha(this.value);
  factory DirectiveAlpha._fromJson(Map<String, Object?> json) =>
      DirectiveAlpha(json['value']! as int);
  final int value;
  @override
  String get op => 'alpha';
  @override
  Map<String, Object?> toJson() => {'op': op, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is DirectiveAlpha && other.value == value;
  @override
  int get hashCode => Object.hash(op, value);
}

/// Common base for the simple `{op, amount}` color directives (darken,
/// lighten, saturate, desaturate, tint, shade, brighten).
@immutable
abstract base class _AmountColorDirective extends DirectiveNode
    with ColorDirective {
  const _AmountColorDirective(this.amount);
  final int amount;
  @override
  Map<String, Object?> toJson() => {'op': op, 'amount': amount};
  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is _AmountColorDirective &&
      other.amount == amount;
  @override
  int get hashCode => Object.hash(op, amount);
}

@immutable
final class DirectiveDarken extends _AmountColorDirective {
  const DirectiveDarken(super.amount);
  factory DirectiveDarken._fromJson(Map<String, Object?> json) =>
      DirectiveDarken(json['amount']! as int);
  @override
  String get op => 'darken';
}

@immutable
final class DirectiveLighten extends _AmountColorDirective {
  const DirectiveLighten(super.amount);
  factory DirectiveLighten._fromJson(Map<String, Object?> json) =>
      DirectiveLighten(json['amount']! as int);
  @override
  String get op => 'lighten';
}

@immutable
final class DirectiveSaturate extends _AmountColorDirective {
  const DirectiveSaturate(super.amount);
  factory DirectiveSaturate._fromJson(Map<String, Object?> json) =>
      DirectiveSaturate(json['amount']! as int);
  @override
  String get op => 'saturate';
}

@immutable
final class DirectiveDesaturate extends _AmountColorDirective {
  const DirectiveDesaturate(super.amount);
  factory DirectiveDesaturate._fromJson(Map<String, Object?> json) =>
      DirectiveDesaturate(json['amount']! as int);
  @override
  String get op => 'desaturate';
}

@immutable
final class DirectiveTint extends _AmountColorDirective {
  const DirectiveTint(super.amount);
  factory DirectiveTint._fromJson(Map<String, Object?> json) =>
      DirectiveTint(json['amount']! as int);
  @override
  String get op => 'tint';
}

@immutable
final class DirectiveShade extends _AmountColorDirective {
  const DirectiveShade(super.amount);
  factory DirectiveShade._fromJson(Map<String, Object?> json) =>
      DirectiveShade(json['amount']! as int);
  @override
  String get op => 'shade';
}

@immutable
final class DirectiveBrighten extends _AmountColorDirective {
  const DirectiveBrighten(super.amount);
  factory DirectiveBrighten._fromJson(Map<String, Object?> json) =>
      DirectiveBrighten(json['amount']! as int);
  @override
  String get op => 'brighten';
}

/// Common base for `withRed` / `withGreen` / `withBlue`.
@immutable
abstract base class _ChannelColorDirective extends DirectiveNode
    with ColorDirective {
  const _ChannelColorDirective(this.value);
  final int value;
  @override
  Map<String, Object?> toJson() => {'op': op, 'value': value};
  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is _ChannelColorDirective &&
      other.value == value;
  @override
  int get hashCode => Object.hash(op, value);
}

@immutable
final class DirectiveWithRed extends _ChannelColorDirective {
  const DirectiveWithRed(super.value);
  factory DirectiveWithRed._fromJson(Map<String, Object?> json) =>
      DirectiveWithRed(json['value']! as int);
  @override
  String get op => 'withRed';
}

@immutable
final class DirectiveWithGreen extends _ChannelColorDirective {
  const DirectiveWithGreen(super.value);
  factory DirectiveWithGreen._fromJson(Map<String, Object?> json) =>
      DirectiveWithGreen(json['value']! as int);
  @override
  String get op => 'withGreen';
}

@immutable
final class DirectiveWithBlue extends _ChannelColorDirective {
  const DirectiveWithBlue(super.value);
  factory DirectiveWithBlue._fromJson(Map<String, Object?> json) =>
      DirectiveWithBlue(json['value']! as int);
  @override
  String get op => 'withBlue';
}

// ---------------------------------------------------------------------------
// String directives (5 ops, all no-arg)

@immutable
abstract base class _NoArgStringDirective extends DirectiveNode
    with StringDirective {
  const _NoArgStringDirective();
  @override
  Map<String, Object?> toJson() => {'op': op};
  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;
  @override
  int get hashCode => op.hashCode;
}

@immutable
final class DirectiveCapitalize extends _NoArgStringDirective {
  const DirectiveCapitalize();
  @override
  String get op => 'capitalize';
}

@immutable
final class DirectiveUppercase extends _NoArgStringDirective {
  const DirectiveUppercase();
  @override
  String get op => 'uppercase';
}

@immutable
final class DirectiveLowercase extends _NoArgStringDirective {
  const DirectiveLowercase();
  @override
  String get op => 'lowercase';
}

@immutable
final class DirectiveTitleCase extends _NoArgStringDirective {
  const DirectiveTitleCase();
  @override
  String get op => 'titleCase';
}

@immutable
final class DirectiveSentenceCase extends _NoArgStringDirective {
  const DirectiveSentenceCase();
  @override
  String get op => 'sentenceCase';
}

// ---------------------------------------------------------------------------
// Number directives (9 ops)

@immutable
class DirectiveMultiply extends DirectiveNode with NumberDirective {
  const DirectiveMultiply(this.factor);
  factory DirectiveMultiply._fromJson(Map<String, Object?> json) =>
      DirectiveMultiply(json['factor']! as num);
  final num factor;
  @override
  String get op => 'multiply';
  @override
  Map<String, Object?> toJson() => {'op': op, 'factor': factor};
  @override
  bool operator ==(Object other) =>
      other is DirectiveMultiply && other.factor == factor;
  @override
  int get hashCode => Object.hash(op, factor);
}

@immutable
class DirectiveAdd extends DirectiveNode with NumberDirective {
  const DirectiveAdd(this.addend);
  factory DirectiveAdd._fromJson(Map<String, Object?> json) =>
      DirectiveAdd(json['addend']! as num);
  final num addend;
  @override
  String get op => 'add';
  @override
  Map<String, Object?> toJson() => {'op': op, 'addend': addend};
  @override
  bool operator ==(Object other) =>
      other is DirectiveAdd && other.addend == addend;
  @override
  int get hashCode => Object.hash(op, addend);
}

@immutable
class DirectiveSubtract extends DirectiveNode with NumberDirective {
  const DirectiveSubtract(this.subtrahend);
  factory DirectiveSubtract._fromJson(Map<String, Object?> json) =>
      DirectiveSubtract(json['subtrahend']! as num);
  final num subtrahend;
  @override
  String get op => 'subtract';
  @override
  Map<String, Object?> toJson() => {'op': op, 'subtrahend': subtrahend};
  @override
  bool operator ==(Object other) =>
      other is DirectiveSubtract && other.subtrahend == subtrahend;
  @override
  int get hashCode => Object.hash(op, subtrahend);
}

@immutable
class DirectiveDivide extends DirectiveNode with NumberDirective {
  const DirectiveDivide(this.divisor);
  factory DirectiveDivide._fromJson(Map<String, Object?> json) =>
      DirectiveDivide(json['divisor']! as num);
  final num divisor;
  @override
  String get op => 'divide';
  @override
  Map<String, Object?> toJson() => {'op': op, 'divisor': divisor};
  @override
  bool operator ==(Object other) =>
      other is DirectiveDivide && other.divisor == divisor;
  @override
  int get hashCode => Object.hash(op, divisor);
}

@immutable
class DirectiveClamp extends DirectiveNode with NumberDirective {
  const DirectiveClamp({required this.min, required this.max});
  factory DirectiveClamp._fromJson(Map<String, Object?> json) =>
      DirectiveClamp(
        min: json['min']! as num,
        max: json['max']! as num,
      );
  final num min;
  final num max;
  @override
  String get op => 'clamp';
  @override
  Map<String, Object?> toJson() => {'op': op, 'min': min, 'max': max};
  @override
  bool operator ==(Object other) =>
      other is DirectiveClamp && other.min == min && other.max == max;
  @override
  int get hashCode => Object.hash(op, min, max);
}

@immutable
abstract base class _NoArgNumberDirective extends DirectiveNode
    with NumberDirective {
  const _NoArgNumberDirective();
  @override
  Map<String, Object?> toJson() => {'op': op};
  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;
  @override
  int get hashCode => op.hashCode;
}

@immutable
final class DirectiveAbs extends _NoArgNumberDirective {
  const DirectiveAbs();
  @override
  String get op => 'abs';
}

@immutable
final class DirectiveRound extends _NoArgNumberDirective {
  const DirectiveRound();
  @override
  String get op => 'round';
}

@immutable
final class DirectiveFloor extends _NoArgNumberDirective {
  const DirectiveFloor();
  @override
  String get op => 'floor';
}

@immutable
final class DirectiveCeil extends _NoArgNumberDirective {
  const DirectiveCeil();
  @override
  String get op => 'ceil';
}

/// Encode a list of directives back to canonical JSON.
List<Map<String, Object?>> encodeDirectives(List<DirectiveNode> directives) =>
    [for (final d in directives) d.toJson()];

/// Decode a JSON list into typed directives. Unknown ops yield `null` —
/// callers (Phase 4 validator) raise `directive.unknown`.
List<DirectiveNode>? decodeDirectives(Object? raw) {
  if (raw is! List) return null;
  final result = <DirectiveNode>[];
  for (final entry in raw) {
    if (entry is! Map<String, Object?>) return null;
    final node = DirectiveNode.fromJson(entry);
    if (node == null) return null;
    result.add(node);
  }
  return result;
}

/// Structural equality across two directive lists. Order matters
/// (directives are applied left-to-right).
bool directivesEqual(List<DirectiveNode> a, List<DirectiveNode> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// `deepEquals` is exposed for callers that need to compare directive props
// (e.g. `DirectiveWithValues` with optional fields). Re-export so consumers
// don't need to reach into `_internal.dart`.
@visibleForTesting
bool directivesDeepEquals(Object? a, Object? b) => deepEquals(a, b);
