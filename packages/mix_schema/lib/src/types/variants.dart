/// `Variant` and `WhenExpr` types.
///
/// A `VariantNode` is a `{ when, style }` pair (spec.md §Variants).
/// The `WhenExpr` discriminator covers 5 kinds × 7 contexts.
///
/// Cross-imports `nodes.dart` for `StyleNode`. Dart handles the cycle.
library;

import 'package:meta/meta.dart';

import 'extensions.dart';
import 'nodes.dart';

/// State variants — closed set, mirrors `WidgetState` carriers.
const Set<String> kStateNames = {
  'onHovered',
  'onPressed',
  'onFocused',
  'onDisabled',
  'onEnabled',
  'onSelected',
  'onError',
  'onDark',
  'onLight',
};

/// Context kinds — closed set, one per built-in `ContextVariant` family.
const Set<String> kContextKinds = {
  'breakpoint',
  'orientation',
  'brightness',
  'platform',
  'directionality',
  'preset',
};

@immutable
sealed class WhenExpr {
  const WhenExpr();

  /// Encode to canonical JSON. State/named/enum/context/preset shapes
  /// match spec.md §Variants verbatim.
  Object toJson();

  /// Parse a canonical when-expression.
  static WhenExpr fromJson(Object? raw) {
    if (raw is String) {
      if (kStateNames.contains(raw)) return WhenState(raw);
      throw FormatException('Unknown state variant "$raw"');
    }
    if (raw is! Map<String, Object?>) {
      throw FormatException('Variant.when must be a string or object');
    }
    if (raw.containsKey('named')) {
      return WhenNamed(raw['named']! as String);
    }
    if (raw.containsKey('enum')) {
      return WhenEnum(raw['enum']! as String);
    }
    if (raw.containsKey('context')) {
      return WhenContext._fromJson(raw);
    }
    if (raw.containsKey('not')) {
      return WhenNot(WhenExpr.fromJson(raw['not']));
    }
    if (raw.length == 1) {
      final key = raw.keys.first;
      if (ExtensionId.isValidIdentifier(key)) {
        return WhenExtension(ExtensionId.unsafe(key), raw[key]);
      }
    }
    throw FormatException('Unknown when shape: $raw');
  }
}

@immutable
class WhenState extends WhenExpr {
  const WhenState(this.state);
  final String state;
  @override
  Object toJson() => state;
  @override
  bool operator ==(Object other) =>
      other is WhenState && other.state == state;
  @override
  int get hashCode => Object.hash(WhenState, state);
}

@immutable
class WhenNamed extends WhenExpr {
  const WhenNamed(this.name);
  final String name;
  @override
  Object toJson() => {'named': name};
  @override
  bool operator ==(Object other) =>
      other is WhenNamed && other.name == name;
  @override
  int get hashCode => Object.hash(WhenNamed, name);
}

@immutable
class WhenEnum extends WhenExpr {
  const WhenEnum(this.value);

  /// Enum string in `EnumType.member` form (e.g. `Size.lg`).
  final String value;
  @override
  Object toJson() => {'enum': value};
  @override
  bool operator ==(Object other) =>
      other is WhenEnum && other.value == value;
  @override
  int get hashCode => Object.hash(WhenEnum, value);
}

@immutable
sealed class WhenContext extends WhenExpr {
  const WhenContext();

  String get context;

  factory WhenContext._fromJson(Map<String, Object?> raw) {
    final context = raw['context'];
    if (context is! String) {
      throw FormatException('When_context requires "context" field');
    }
    return switch (context) {
      'breakpoint' => WhenBreakpoint(raw['token']! as String),
      'orientation' => WhenOrientation(raw['value']! as String),
      'brightness' => WhenBrightness(raw['value']! as String),
      'platform' => WhenPlatform(raw['value']! as String),
      'directionality' => WhenDirectionality(raw['value']! as String),
      'preset' => WhenPreset(raw['value']! as String),
      _ => throw FormatException('Unknown context kind "$context"'),
    };
  }
}

@immutable
class WhenBreakpoint extends WhenContext {
  const WhenBreakpoint(this.token);
  final String token;
  @override
  String get context => 'breakpoint';
  @override
  Object toJson() => {'context': context, 'token': token};
  @override
  bool operator ==(Object other) =>
      other is WhenBreakpoint && other.token == token;
  @override
  int get hashCode => Object.hash(WhenBreakpoint, token);
}

@immutable
class WhenOrientation extends WhenContext {
  const WhenOrientation(this.value);
  final String value;
  @override
  String get context => 'orientation';
  @override
  Object toJson() => {'context': context, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is WhenOrientation && other.value == value;
  @override
  int get hashCode => Object.hash(WhenOrientation, value);
}

@immutable
class WhenBrightness extends WhenContext {
  const WhenBrightness(this.value);
  final String value;
  @override
  String get context => 'brightness';
  @override
  Object toJson() => {'context': context, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is WhenBrightness && other.value == value;
  @override
  int get hashCode => Object.hash(WhenBrightness, value);
}

@immutable
class WhenPlatform extends WhenContext {
  const WhenPlatform(this.value);
  final String value;
  @override
  String get context => 'platform';
  @override
  Object toJson() => {'context': context, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is WhenPlatform && other.value == value;
  @override
  int get hashCode => Object.hash(WhenPlatform, value);
}

@immutable
class WhenDirectionality extends WhenContext {
  const WhenDirectionality(this.value);
  final String value;
  @override
  String get context => 'directionality';
  @override
  Object toJson() => {'context': context, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is WhenDirectionality && other.value == value;
  @override
  int get hashCode => Object.hash(WhenDirectionality, value);
}

@immutable
class WhenPreset extends WhenContext {
  const WhenPreset(this.value);
  final String value;
  @override
  String get context => 'preset';
  @override
  Object toJson() => {'context': context, 'value': value};
  @override
  bool operator ==(Object other) =>
      other is WhenPreset && other.value == value;
  @override
  int get hashCode => Object.hash(WhenPreset, value);
}

@immutable
class WhenNot extends WhenExpr {
  const WhenNot(this.inner);
  final WhenExpr inner;
  @override
  Object toJson() => {'not': inner.toJson()};
  @override
  bool operator ==(Object other) =>
      other is WhenNot && other.inner == inner;
  @override
  int get hashCode => Object.hash(WhenNot, inner);
}

@immutable
class WhenExtension extends WhenExpr {
  const WhenExtension(this.key, this.payload);
  final ExtensionId key;
  final Object? payload;
  @override
  Object toJson() => {key.value: payload};
  @override
  bool operator ==(Object other) =>
      other is WhenExtension && other.key == key && other.payload == payload;
  @override
  int get hashCode => Object.hash(WhenExtension, key, payload);
}

/// `{ when, style }` pair. The enclosing `StyleNode` carries an array of
/// these (`variants`). Per Decision #25, `style` MUST share the same
/// spec as the enclosing StyleNode (validator stage 4 enforces).
@immutable
class VariantNode {
  const VariantNode({required this.when, required this.style});

  factory VariantNode.fromJson(Map<String, Object?> json) => VariantNode(
        when: WhenExpr.fromJson(json['when']),
        style: StyleNode.fromJson(json['style']! as Map<String, Object?>),
      );

  final WhenExpr when;
  final StyleNode style;

  Map<String, Object?> toJson() => {
        'when': when.toJson(),
        'style': style.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      other is VariantNode && other.when == when && other.style == style;

  @override
  int get hashCode => Object.hash(VariantNode, when, style);
}
