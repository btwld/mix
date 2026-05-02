/// `Modifier` types — 30 closed-set wrappers + `reset` sentinel +
/// `x:` extension.
///
/// Most modifier props follow the `Value primitive` rules (`PropertyValue`
/// in this package). Two specials carry raw `StyleNode`:
/// `ModifierBox.style` and `ModifierDefaultTextStyler.style` (per spec
/// §Modifiers). Two carry `HostRef`: `ModifierClipPath.clipper` and
/// `ModifierShaderMask.shader`.
///
/// `ModifierReset` is destructive — at merge time it discards every
/// modifier preceding it in the merged list.
library;

import 'package:meta/meta.dart';

import 'extensions.dart';
import 'nodes.dart';
import 'values.dart';

/// Tagged-union root for every modifier node.
@immutable
sealed class ModifierNode {
  const ModifierNode();

  /// The modifier discriminator (e.g. `"opacity"`, `"reset"`).
  String get modifier;

  Map<String, Object?> toJson();

  /// Parse a canonical modifier object. Returns `null` for unknown
  /// modifiers (validator raises `modifier.unknown`).
  static ModifierNode? fromJson(Map<String, Object?> json) {
    final name = json['modifier'];
    if (name is! String) return null;

    if (name == 'reset') return const ModifierReset();
    if (ExtensionId.isValidIdentifier(name)) {
      final payload = <String, Object?>{...json}..remove('modifier');
      return ModifierExtension(ExtensionId.unsafe(name), payload);
    }

    final propsRaw = json['props'];
    final props = propsRaw is Map<String, Object?> ? propsRaw : const <String, Object?>{};

    return switch (name) {
      // Specials — StyleNode-valued.
      'box' => ModifierBox(
          style: StyleNode.fromJson(props['style']! as Map<String, Object?>),
        ),
      'defaultTextStyler' => ModifierDefaultTextStyler(
          style: StyleNode.fromJson(props['style']! as Map<String, Object?>),
        ),
      // Specials — HostRef-valued.
      'clipPath' => ModifierClipPath(
          clipper: HostRef.fromJson(props['clipper']! as Map<String, Object?>),
          clipBehavior: PropertyValue.fromJson(props['clipBehavior']),
        ),
      'shaderMask' => ModifierShaderMask(
          shader: HostRef.fromJson(props['shader']! as Map<String, Object?>),
          blendMode: PropertyValue.fromJson(props['blendMode']),
        ),
      // PropertyValue-only modifiers.
      _ => _PropModifier._tryFromJson(name, props),
    };
  }
}

@immutable
class ModifierReset extends ModifierNode {
  const ModifierReset();
  @override
  String get modifier => 'reset';
  @override
  Map<String, Object?> toJson() => {'modifier': modifier};
  @override
  bool operator ==(Object other) => other is ModifierReset;
  @override
  int get hashCode => 'modifier.reset'.hashCode;
}

@immutable
class ModifierExtension extends ModifierNode {
  const ModifierExtension(this.key, this.payload);
  final ExtensionId key;
  final Map<String, Object?> payload;
  @override
  String get modifier => key.value;
  @override
  Map<String, Object?> toJson() => {'modifier': modifier, ...payload};
  @override
  bool operator ==(Object other) =>
      other is ModifierExtension &&
      other.key == key &&
      _mapEquals(payload, other.payload);
  @override
  int get hashCode => Object.hash(ModifierExtension, key, _mapHash(payload));
}

@immutable
class ModifierBox extends ModifierNode {
  const ModifierBox({required this.style});
  final StyleNode style;
  @override
  String get modifier => 'box';
  @override
  Map<String, Object?> toJson() => {
        'modifier': modifier,
        'props': {'style': style.toJson()},
      };
  @override
  bool operator ==(Object other) =>
      other is ModifierBox && other.style == style;
  @override
  int get hashCode => Object.hash(ModifierBox, style);
}

@immutable
class ModifierDefaultTextStyler extends ModifierNode {
  const ModifierDefaultTextStyler({required this.style});
  final StyleNode style;
  @override
  String get modifier => 'defaultTextStyler';
  @override
  Map<String, Object?> toJson() => {
        'modifier': modifier,
        'props': {'style': style.toJson()},
      };
  @override
  bool operator ==(Object other) =>
      other is ModifierDefaultTextStyler && other.style == style;
  @override
  int get hashCode => Object.hash(ModifierDefaultTextStyler, style);
}

@immutable
class ModifierClipPath extends ModifierNode {
  const ModifierClipPath({required this.clipper, this.clipBehavior});
  final HostRef clipper;
  final PropertyValue? clipBehavior;
  @override
  String get modifier => 'clipPath';
  @override
  Map<String, Object?> toJson() {
    final props = <String, Object?>{'clipper': clipper.toJson()};
    if (clipBehavior != null) props['clipBehavior'] = clipBehavior!.toJson();
    return {'modifier': modifier, 'props': props};
  }

  @override
  bool operator ==(Object other) =>
      other is ModifierClipPath &&
      other.clipper == clipper &&
      other.clipBehavior == clipBehavior;
  @override
  int get hashCode => Object.hash(ModifierClipPath, clipper, clipBehavior);
}

@immutable
class ModifierShaderMask extends ModifierNode {
  const ModifierShaderMask({required this.shader, this.blendMode});
  final HostRef shader;
  final PropertyValue? blendMode;
  @override
  String get modifier => 'shaderMask';
  @override
  Map<String, Object?> toJson() {
    final props = <String, Object?>{'shader': shader.toJson()};
    if (blendMode != null) props['blendMode'] = blendMode!.toJson();
    return {'modifier': modifier, 'props': props};
  }

  @override
  bool operator ==(Object other) =>
      other is ModifierShaderMask &&
      other.shader == shader &&
      other.blendMode == blendMode;
  @override
  int get hashCode => Object.hash(ModifierShaderMask, shader, blendMode);
}

// ---------------------------------------------------------------------------
// PropertyValue-only modifiers — 25 variants share the same shape:
// `{ modifier: <name>, props: { ...PropertyValues... } }`. Subclassed so
// callers can pattern-match.

@immutable
abstract base class _PropModifier extends ModifierNode {
  const _PropModifier(this.props);
  final Map<String, PropertyValue> props;

  /// Set of allowed prop names for this modifier.
  Set<String> get allowedProps;

  static ModifierNode? _tryFromJson(String name, Map<String, Object?> rawProps) {
    final builder = _propModifierBuilders[name];
    if (builder == null) return null;
    return builder(rawProps);
  }

  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    for (final entry in props.entries) {
      out[entry.key] = entry.value.toJson();
    }
    return {'modifier': modifier, 'props': out};
  }

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is _PropModifier &&
      _propsEqual(other.props, props);

  @override
  int get hashCode => Object.hash(modifier, _propsHash(props));
}

bool _propsEqual(Map<String, PropertyValue> a, Map<String, PropertyValue> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

int _propsHash(Map<String, PropertyValue> props) {
  final entries = props.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return Object.hashAll([
    for (final e in entries) ...[e.key, e.value],
  ]);
}

bool _mapEquals(Map<String, Object?> a, Map<String, Object?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

int _mapHash(Map<String, Object?> map) {
  final entries = map.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return Object.hashAll([
    for (final e in entries) ...[e.key, e.value],
  ]);
}

Map<String, PropertyValue> _readProps(
  Map<String, Object?> raw,
  Set<String> allowed,
) {
  final out = <String, PropertyValue>{};
  for (final key in allowed) {
    final value = raw[key];
    if (value == null) continue;
    final pv = PropertyValue.fromJson(value);
    if (pv == null) continue;
    out[key] = pv;
  }
  return out;
}

@immutable
final class ModifierOpacity extends _PropModifier {
  const ModifierOpacity(super.props);
  @override
  String get modifier => 'opacity';
  @override
  Set<String> get allowedProps => const {'opacity'};
}

@immutable
final class ModifierBlur extends _PropModifier {
  const ModifierBlur(super.props);
  @override
  String get modifier => 'blur';
  @override
  Set<String> get allowedProps => const {'sigma'};
}

@immutable
final class ModifierAspectRatio extends _PropModifier {
  const ModifierAspectRatio(super.props);
  @override
  String get modifier => 'aspectRatio';
  @override
  Set<String> get allowedProps => const {'aspectRatio'};
}

@immutable
final class ModifierSizedBox extends _PropModifier {
  const ModifierSizedBox(super.props);
  @override
  String get modifier => 'sizedBox';
  @override
  Set<String> get allowedProps => const {'width', 'height'};
}

@immutable
final class ModifierPadding extends _PropModifier {
  const ModifierPadding(super.props);
  @override
  String get modifier => 'padding';
  @override
  Set<String> get allowedProps => const {'padding'};
}

@immutable
final class ModifierAlign extends _PropModifier {
  const ModifierAlign(super.props);
  @override
  String get modifier => 'align';
  @override
  Set<String> get allowedProps =>
      const {'alignment', 'widthFactor', 'heightFactor'};
}

@immutable
final class ModifierFlexible extends _PropModifier {
  const ModifierFlexible(super.props);
  @override
  String get modifier => 'flexible';
  @override
  Set<String> get allowedProps => const {'flex', 'fit'};
}

@immutable
final class ModifierRotatedBox extends _PropModifier {
  const ModifierRotatedBox(super.props);
  @override
  String get modifier => 'rotatedBox';
  @override
  Set<String> get allowedProps => const {'quarterTurns'};
}

@immutable
final class ModifierVisibility extends _PropModifier {
  const ModifierVisibility(super.props);
  @override
  String get modifier => 'visibility';
  @override
  Set<String> get allowedProps => const {'visible'};
}

@immutable
final class ModifierClipOval extends _PropModifier {
  const ModifierClipOval(super.props);
  @override
  String get modifier => 'clipOval';
  @override
  Set<String> get allowedProps => const {'clipBehavior'};
}

@immutable
final class ModifierClipRect extends _PropModifier {
  const ModifierClipRect(super.props);
  @override
  String get modifier => 'clipRect';
  @override
  Set<String> get allowedProps => const {'clipBehavior'};
}

@immutable
final class ModifierClipRRect extends _PropModifier {
  const ModifierClipRRect(super.props);
  @override
  String get modifier => 'clipRRect';
  @override
  Set<String> get allowedProps => const {'borderRadius', 'clipBehavior'};
}

@immutable
final class ModifierClipTriangle extends _PropModifier {
  const ModifierClipTriangle(super.props);
  @override
  String get modifier => 'clipTriangle';
  @override
  Set<String> get allowedProps => const {'clipBehavior'};
}

@immutable
final class ModifierTransform extends _PropModifier {
  const ModifierTransform(super.props);
  @override
  String get modifier => 'transform';
  @override
  Set<String> get allowedProps => const {'transform', 'alignment'};
}

@immutable
final class ModifierScale extends _PropModifier {
  const ModifierScale(super.props);
  @override
  String get modifier => 'scale';
  @override
  Set<String> get allowedProps => const {'x', 'y', 'alignment'};
}

@immutable
final class ModifierRotate extends _PropModifier {
  const ModifierRotate(super.props);
  @override
  String get modifier => 'rotate';
  @override
  Set<String> get allowedProps => const {'radians', 'alignment'};
}

@immutable
final class ModifierTranslate extends _PropModifier {
  const ModifierTranslate(super.props);
  @override
  String get modifier => 'translate';
  @override
  Set<String> get allowedProps => const {'x', 'y'};
}

@immutable
final class ModifierSkew extends _PropModifier {
  const ModifierSkew(super.props);
  @override
  String get modifier => 'skew';
  @override
  Set<String> get allowedProps => const {'skewX', 'skewY'};
}

@immutable
final class ModifierFractionallySizedBox extends _PropModifier {
  const ModifierFractionallySizedBox(super.props);
  @override
  String get modifier => 'fractionallySizedBox';
  @override
  Set<String> get allowedProps =>
      const {'widthFactor', 'heightFactor', 'alignment'};
}

@immutable
final class ModifierIntrinsicHeight extends _PropModifier {
  const ModifierIntrinsicHeight(super.props);
  @override
  String get modifier => 'intrinsicHeight';
  @override
  Set<String> get allowedProps => const {};
}

@immutable
final class ModifierIntrinsicWidth extends _PropModifier {
  const ModifierIntrinsicWidth(super.props);
  @override
  String get modifier => 'intrinsicWidth';
  @override
  Set<String> get allowedProps => const {};
}

@immutable
final class ModifierIconTheme extends _PropModifier {
  const ModifierIconTheme(super.props);
  @override
  String get modifier => 'iconTheme';
  @override
  Set<String> get allowedProps => const {
        'color',
        'size',
        'fill',
        'weight',
        'grade',
        'opticalSize',
        'applyTextScaling',
      };
}

@immutable
final class ModifierDefaultTextStyle extends _PropModifier {
  const ModifierDefaultTextStyle(super.props);
  @override
  String get modifier => 'defaultTextStyle';
  @override
  Set<String> get allowedProps => const {
        'style',
        'textAlign',
        'softWrap',
        'overflow',
        'maxLines',
        'textWidthBasis',
      };
}

@immutable
final class ModifierMouseCursor extends _PropModifier {
  const ModifierMouseCursor(super.props);
  @override
  String get modifier => 'mouseCursor';
  @override
  Set<String> get allowedProps => const {'cursor'};
}

@immutable
final class ModifierScrollView extends _PropModifier {
  const ModifierScrollView(super.props);
  @override
  String get modifier => 'scrollView';
  @override
  Set<String> get allowedProps => const {'scrollDirection'};
}

// Builder dispatch table — keyed by modifier discriminator.
final Map<String, ModifierNode Function(Map<String, Object?>)>
    _propModifierBuilders = {
  'opacity': (raw) => ModifierOpacity(_readProps(raw, const {'opacity'})),
  'blur': (raw) => ModifierBlur(_readProps(raw, const {'sigma'})),
  'aspectRatio': (raw) =>
      ModifierAspectRatio(_readProps(raw, const {'aspectRatio'})),
  'sizedBox': (raw) =>
      ModifierSizedBox(_readProps(raw, const {'width', 'height'})),
  'padding': (raw) => ModifierPadding(_readProps(raw, const {'padding'})),
  'align': (raw) => ModifierAlign(
      _readProps(raw, const {'alignment', 'widthFactor', 'heightFactor'})),
  'flexible': (raw) => ModifierFlexible(_readProps(raw, const {'flex', 'fit'})),
  'rotatedBox': (raw) =>
      ModifierRotatedBox(_readProps(raw, const {'quarterTurns'})),
  'visibility': (raw) => ModifierVisibility(_readProps(raw, const {'visible'})),
  'clipOval': (raw) => ModifierClipOval(_readProps(raw, const {'clipBehavior'})),
  'clipRect': (raw) => ModifierClipRect(_readProps(raw, const {'clipBehavior'})),
  'clipRRect': (raw) => ModifierClipRRect(
      _readProps(raw, const {'borderRadius', 'clipBehavior'})),
  'clipTriangle': (raw) =>
      ModifierClipTriangle(_readProps(raw, const {'clipBehavior'})),
  'transform': (raw) =>
      ModifierTransform(_readProps(raw, const {'transform', 'alignment'})),
  'scale': (raw) =>
      ModifierScale(_readProps(raw, const {'x', 'y', 'alignment'})),
  'rotate': (raw) =>
      ModifierRotate(_readProps(raw, const {'radians', 'alignment'})),
  'translate': (raw) => ModifierTranslate(_readProps(raw, const {'x', 'y'})),
  'skew': (raw) => ModifierSkew(_readProps(raw, const {'skewX', 'skewY'})),
  'fractionallySizedBox': (raw) => ModifierFractionallySizedBox(
      _readProps(raw, const {'widthFactor', 'heightFactor', 'alignment'})),
  'intrinsicHeight': (raw) => ModifierIntrinsicHeight(_readProps(raw, const {})),
  'intrinsicWidth': (raw) => ModifierIntrinsicWidth(_readProps(raw, const {})),
  'iconTheme': (raw) => ModifierIconTheme(_readProps(raw, const {
        'color',
        'size',
        'fill',
        'weight',
        'grade',
        'opticalSize',
        'applyTextScaling',
      })),
  'defaultTextStyle': (raw) => ModifierDefaultTextStyle(_readProps(raw, const {
        'style',
        'textAlign',
        'softWrap',
        'overflow',
        'maxLines',
        'textWidthBasis',
      })),
  'mouseCursor': (raw) => ModifierMouseCursor(_readProps(raw, const {'cursor'})),
  'scrollView': (raw) =>
      ModifierScrollView(_readProps(raw, const {'scrollDirection'})),
};

/// All modifier discriminator names recognized by [ModifierNode.fromJson].
/// Used by tests to verify catalog completeness against `registry.json`.
Set<String> get allModifierNames => {
      ..._propModifierBuilders.keys,
      'box',
      'defaultTextStyler',
      'clipPath',
      'shaderMask',
      'reset',
    };
