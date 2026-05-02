/// `WidgetNode`, `StyleNode`, `SubStyleNode`, and `AnimationNode`.
///
/// These are the structural backbone of a Mix JSON document — the
/// `root` field of `MixJsonDocument` is a `WidgetNode`, every widget
/// carries an optional `StyleNode`, and StyleNodes nest variants /
/// modifiers / animations.
///
/// AnimationNode is two non-overlapping sealed subclasses — kind="curve"
/// (with required `curve` field) vs preset kinds (no `curve` field) per
/// schema.v1.json `AnimationNode.oneOf`.
library;

import 'package:meta/meta.dart';

import 'extensions.dart';
import 'modifiers.dart';
import 'values.dart';
import 'variants.dart';

// ---------------------------------------------------------------------------
// AnimationNode

@immutable
sealed class AnimationNode {
  const AnimationNode();

  String get kind;
  int get duration;
  int? get delay;

  Map<String, Object?> toJson();

  static AnimationNode fromJson(Map<String, Object?> json) {
    final kind = json['kind'];
    if (kind is! String) {
      throw FormatException('AnimationNode requires "kind"');
    }
    if (kind == 'curve') {
      return AnimationCurve(
        duration: json['duration']! as int,
        curve: json['curve']! as String,
        delay: json['delay'] as int?,
      );
    }
    return AnimationPreset(
      kind: kind,
      duration: json['duration']! as int,
      delay: json['delay'] as int?,
    );
  }
}

@immutable
class AnimationCurve extends AnimationNode {
  const AnimationCurve({required this.duration, required this.curve, this.delay});
  @override
  String get kind => 'curve';
  @override
  final int duration;
  final String curve;
  @override
  final int? delay;
  @override
  Map<String, Object?> toJson() => {
        'kind': kind,
        'duration': duration,
        'curve': curve,
        if (delay != null) 'delay': delay,
      };
  @override
  bool operator ==(Object other) =>
      other is AnimationCurve &&
      other.duration == duration &&
      other.curve == curve &&
      other.delay == delay;
  @override
  int get hashCode => Object.hash(AnimationCurve, duration, curve, delay);
}

@immutable
class AnimationPreset extends AnimationNode {
  const AnimationPreset(
      {required this.kind, required this.duration, this.delay});
  @override
  final String kind;
  @override
  final int duration;
  @override
  final int? delay;
  @override
  Map<String, Object?> toJson() => {
        'kind': kind,
        'duration': duration,
        if (delay != null) 'delay': delay,
      };
  @override
  bool operator ==(Object other) =>
      other is AnimationPreset &&
      other.kind == kind &&
      other.duration == duration &&
      other.delay == delay;
  @override
  int get hashCode => Object.hash(AnimationPreset, kind, duration, delay);
}

// ---------------------------------------------------------------------------
// StyleNode (8 variants) + SubStyleNode (3 variants).

@immutable
sealed class StyleNode {
  const StyleNode();

  String get spec;

  Map<String, Object?> toJson();

  static StyleNode fromJson(Map<String, Object?> json) {
    final spec = json['spec'];
    if (spec is! String) {
      throw FormatException('StyleNode requires "spec"');
    }
    if (ExtensionId.isValidIdentifier(spec)) {
      return StyleExtension.fromJson(json);
    }
    return switch (spec) {
      'box' => StyleBox.fromJson(json),
      'flex' => StyleFlex.fromJson(json),
      'text' => StyleText.fromJson(json),
      'icon' => StyleIcon.fromJson(json),
      'image' => StyleImage.fromJson(json),
      'stack' => StyleStack.fromJson(json),
      'flexbox' => StyleFlexBox.fromJson(json),
      'stackbox' => StyleStackBox.fromJson(json),
      _ => throw FormatException('Unknown spec "$spec"'),
    };
  }
}

/// Field set shared across leaf StyleNodes (variants / modifiers /
/// animation). Public so that subclass constructor signatures don't leak
/// a private type.
@immutable
class LeafStyleProps {
  const LeafStyleProps({
    this.props = const {},
    this.variants = const [],
    this.modifiers = const [],
    this.animation,
  });

  final Map<String, PropertyValue> props;
  final List<VariantNode> variants;
  final List<ModifierNode> modifiers;
  final AnimationNode? animation;

  Map<String, Object?> toJson(String spec) {
    final out = <String, Object?>{'spec': spec};
    if (props.isNotEmpty) {
      out['props'] = {
        for (final entry in props.entries) entry.key: entry.value.toJson(),
      };
    }
    if (variants.isNotEmpty) {
      out['variants'] = [for (final v in variants) v.toJson()];
    }
    if (modifiers.isNotEmpty) {
      out['modifiers'] = [for (final m in modifiers) m.toJson()];
    }
    if (animation != null) out['animation'] = animation!.toJson();
    return out;
  }
}

Map<String, PropertyValue> _readPropsMap(Object? raw) {
  if (raw is! Map<String, Object?>) return const {};
  final out = <String, PropertyValue>{};
  for (final entry in raw.entries) {
    final pv = PropertyValue.fromJson(entry.value);
    if (pv == null) continue;
    out[entry.key] = pv;
  }
  return out;
}

List<VariantNode> _readVariants(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final entry in raw)
      if (entry is Map<String, Object?>) VariantNode.fromJson(entry),
  ];
}

List<ModifierNode> _readModifiers(Object? raw) {
  if (raw is! List) return const [];
  final out = <ModifierNode>[];
  for (final entry in raw) {
    if (entry is! Map<String, Object?>) continue;
    final node = ModifierNode.fromJson(entry);
    if (node != null) out.add(node);
  }
  return out;
}

AnimationNode? _readAnimation(Object? raw) =>
    raw is Map<String, Object?> ? AnimationNode.fromJson(raw) : null;

bool _propsMapEqual(Map<String, PropertyValue> a, Map<String, PropertyValue> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

bool _listEqual<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _propsMapHash(Map<String, PropertyValue> map) {
  final entries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  return Object.hashAll([for (final e in entries) ...[e.key, e.value]]);
}

@immutable
abstract base class LeafStyleNode extends StyleNode {
  const LeafStyleNode(this.common);
  final LeafStyleProps common;

  Map<String, PropertyValue> get props => common.props;
  List<VariantNode> get variants => common.variants;
  List<ModifierNode> get modifiers => common.modifiers;
  AnimationNode? get animation => common.animation;

  @override
  Map<String, Object?> toJson() => common.toJson(spec);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is LeafStyleNode &&
      _propsMapEqual(common.props, other.common.props) &&
      _listEqual(common.variants, other.common.variants) &&
      _listEqual(common.modifiers, other.common.modifiers) &&
      common.animation == other.common.animation;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        _propsMapHash(common.props),
        Object.hashAll(common.variants),
        Object.hashAll(common.modifiers),
        common.animation,
      );
}

@immutable
final class StyleBox extends LeafStyleNode {
  const StyleBox(super.common);
  factory StyleBox.fromJson(Map<String, Object?> json) => StyleBox(LeafStyleProps(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      ));
  @override
  String get spec => 'box';
}

@immutable
final class StyleFlex extends LeafStyleNode {
  const StyleFlex(super.common);
  factory StyleFlex.fromJson(Map<String, Object?> json) => StyleFlex(LeafStyleProps(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      ));
  @override
  String get spec => 'flex';
}

@immutable
final class StyleText extends StyleNode {
  const StyleText({
    this.props = const {},
    this.variants = const [],
    this.modifiers = const [],
    this.animation,
    this.textDirectives = const [],
  });
  factory StyleText.fromJson(Map<String, Object?> json) => StyleText(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
        textDirectives: _readTextDirectives(json['textDirectives']),
      );
  final Map<String, PropertyValue> props;
  final List<VariantNode> variants;
  final List<ModifierNode> modifiers;
  final AnimationNode? animation;
  final List<Object> textDirectives; // List<StringDirective> in practice
  @override
  String get spec => 'text';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'spec': spec};
    if (props.isNotEmpty) {
      out['props'] = {
        for (final entry in props.entries) entry.key: entry.value.toJson(),
      };
    }
    if (variants.isNotEmpty) {
      out['variants'] = [for (final v in variants) v.toJson()];
    }
    if (modifiers.isNotEmpty) {
      out['modifiers'] = [for (final m in modifiers) m.toJson()];
    }
    if (animation != null) out['animation'] = animation!.toJson();
    if (textDirectives.isNotEmpty) {
      out['textDirectives'] = [...textDirectives];
    }
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is StyleText &&
      _propsMapEqual(props, other.props) &&
      _listEqual(variants, other.variants) &&
      _listEqual(modifiers, other.modifiers) &&
      animation == other.animation &&
      _listEqual(textDirectives, other.textDirectives);

  @override
  int get hashCode => Object.hash(
        StyleText,
        _propsMapHash(props),
        Object.hashAll(variants),
        Object.hashAll(modifiers),
        animation,
        Object.hashAll(textDirectives),
      );
}

@immutable
final class StyleIcon extends LeafStyleNode {
  const StyleIcon(super.common);
  factory StyleIcon.fromJson(Map<String, Object?> json) => StyleIcon(LeafStyleProps(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      ));
  @override
  String get spec => 'icon';
}

@immutable
final class StyleImage extends LeafStyleNode {
  const StyleImage(super.common);
  factory StyleImage.fromJson(Map<String, Object?> json) => StyleImage(LeafStyleProps(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      ));
  @override
  String get spec => 'image';
}

@immutable
final class StyleStack extends LeafStyleNode {
  const StyleStack(super.common);
  factory StyleStack.fromJson(Map<String, Object?> json) => StyleStack(LeafStyleProps(
        props: _readPropsMap(json['props']),
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      ));
  @override
  String get spec => 'stack';
}

@immutable
sealed class SubStyleNode {
  const SubStyleNode();
  String get spec;
  Map<String, Object?> toJson();
  static SubStyleNode fromJson(Map<String, Object?> json) {
    final spec = json['spec'];
    return switch (spec) {
      'box' => SubStyleBox(_readPropsMap(json['props'])),
      'flex' => SubStyleFlex(_readPropsMap(json['props'])),
      'stack' => SubStyleStack(_readPropsMap(json['props'])),
      _ => throw FormatException('Unknown SubStyle spec "$spec"'),
    };
  }
}

@immutable
abstract base class SubStyleBase extends SubStyleNode {
  const SubStyleBase(this.props);
  final Map<String, PropertyValue> props;
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'spec': spec};
    if (props.isNotEmpty) {
      out['props'] = {
        for (final entry in props.entries) entry.key: entry.value.toJson(),
      };
    }
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is SubStyleBase &&
      _propsMapEqual(props, other.props);
  @override
  int get hashCode => Object.hash(runtimeType, _propsMapHash(props));
}

@immutable
final class SubStyleBox extends SubStyleBase {
  const SubStyleBox(super.props);
  @override
  String get spec => 'box';
}

@immutable
final class SubStyleFlex extends SubStyleBase {
  const SubStyleFlex(super.props);
  @override
  String get spec => 'flex';
}

@immutable
final class SubStyleStack extends SubStyleBase {
  const SubStyleStack(super.props);
  @override
  String get spec => 'stack';
}

@immutable
abstract base class CompositeStyleNode extends StyleNode {
  const CompositeStyleNode({
    this.box,
    this.variants = const [],
    this.modifiers = const [],
    this.animation,
  });
  final SubStyleBox? box;
  final List<VariantNode> variants;
  final List<ModifierNode> modifiers;
  final AnimationNode? animation;
}

@immutable
final class StyleFlexBox extends CompositeStyleNode {
  const StyleFlexBox({
    super.box,
    this.flex,
    super.variants,
    super.modifiers,
    super.animation,
  });
  factory StyleFlexBox.fromJson(Map<String, Object?> json) => StyleFlexBox(
        box: json['box'] is Map<String, Object?>
            ? SubStyleBox(_readPropsMap((json['box']! as Map<String, Object?>)['props']))
            : null,
        flex: json['flex'] is Map<String, Object?>
            ? SubStyleFlex(_readPropsMap((json['flex']! as Map<String, Object?>)['props']))
            : null,
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      );
  final SubStyleFlex? flex;
  @override
  String get spec => 'flexbox';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'spec': spec};
    if (box != null) out['box'] = box!.toJson();
    if (flex != null) out['flex'] = flex!.toJson();
    if (variants.isNotEmpty) {
      out['variants'] = [for (final v in variants) v.toJson()];
    }
    if (modifiers.isNotEmpty) {
      out['modifiers'] = [for (final m in modifiers) m.toJson()];
    }
    if (animation != null) out['animation'] = animation!.toJson();
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is StyleFlexBox &&
      box == other.box &&
      flex == other.flex &&
      _listEqual(variants, other.variants) &&
      _listEqual(modifiers, other.modifiers) &&
      animation == other.animation;

  @override
  int get hashCode => Object.hash(
        StyleFlexBox,
        box,
        flex,
        Object.hashAll(variants),
        Object.hashAll(modifiers),
        animation,
      );
}

@immutable
final class StyleStackBox extends CompositeStyleNode {
  const StyleStackBox({
    super.box,
    this.stack,
    super.variants,
    super.modifiers,
    super.animation,
  });
  factory StyleStackBox.fromJson(Map<String, Object?> json) => StyleStackBox(
        box: json['box'] is Map<String, Object?>
            ? SubStyleBox(_readPropsMap((json['box']! as Map<String, Object?>)['props']))
            : null,
        stack: json['stack'] is Map<String, Object?>
            ? SubStyleStack(_readPropsMap((json['stack']! as Map<String, Object?>)['props']))
            : null,
        variants: _readVariants(json['variants']),
        modifiers: _readModifiers(json['modifiers']),
        animation: _readAnimation(json['animation']),
      );
  final SubStyleStack? stack;
  @override
  String get spec => 'stackbox';
  @override
  Map<String, Object?> toJson() {
    final out = <String, Object?>{'spec': spec};
    if (box != null) out['box'] = box!.toJson();
    if (stack != null) out['stack'] = stack!.toJson();
    if (variants.isNotEmpty) {
      out['variants'] = [for (final v in variants) v.toJson()];
    }
    if (modifiers.isNotEmpty) {
      out['modifiers'] = [for (final m in modifiers) m.toJson()];
    }
    if (animation != null) out['animation'] = animation!.toJson();
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is StyleStackBox &&
      box == other.box &&
      stack == other.stack &&
      _listEqual(variants, other.variants) &&
      _listEqual(modifiers, other.modifiers) &&
      animation == other.animation;

  @override
  int get hashCode => Object.hash(
        StyleStackBox,
        box,
        stack,
        Object.hashAll(variants),
        Object.hashAll(modifiers),
        animation,
      );
}

@immutable
class StyleExtension extends StyleNode {
  const StyleExtension(this.key, this.payload);
  factory StyleExtension.fromJson(Map<String, Object?> json) {
    final spec = json['spec']! as String;
    final payload = <String, Object?>{...json}..remove('spec');
    return StyleExtension(ExtensionId.unsafe(spec), payload);
  }
  final ExtensionId key;
  final Map<String, Object?> payload;
  @override
  String get spec => key.value;
  @override
  Map<String, Object?> toJson() => {'spec': spec, ...payload};

  @override
  bool operator ==(Object other) {
    if (other is! StyleExtension) return false;
    if (other.key != key) return false;
    if (other.payload.length != payload.length) return false;
    for (final entry in payload.entries) {
      if (!other.payload.containsKey(entry.key)) return false;
      if (other.payload[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final entries = payload.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return Object.hash(
      StyleExtension,
      key,
      Object.hashAll([for (final e in entries) ...[e.key, e.value]]),
    );
  }
}

// ---------------------------------------------------------------------------
// WidgetNode (11 variants).

@immutable
sealed class WidgetNode {
  const WidgetNode();
  String get widget;
  Map<String, Object?> toJson();
  static WidgetNode fromJson(Map<String, Object?> json) {
    final widget = json['widget'];
    if (widget is! String) {
      throw FormatException('WidgetNode requires "widget"');
    }
    if (ExtensionId.isValidIdentifier(widget)) {
      return WidgetExtension.fromJson(json);
    }
    return switch (widget) {
      'Box' => WidgetBox.fromJson(json),
      'FlexBox' => WidgetFlexBox.fromJson(json),
      'RowBox' => WidgetRowBox.fromJson(json),
      'ColumnBox' => WidgetColumnBox.fromJson(json),
      'StackBox' => WidgetStackBox.fromJson(json),
      'StyledText' => WidgetStyledText.fromJson(json),
      'StyledIcon' => WidgetStyledIcon.fromJson(json),
      'StyledImage' => WidgetStyledImage.fromJson(json),
      'Pressable' => WidgetPressable.fromJson(json),
      'PressableBox' => WidgetPressableBox.fromJson(json),
      _ => throw FormatException('Unknown widget "$widget"'),
    };
  }
}

WidgetNode _readWidgetNode(Object? raw) =>
    WidgetNode.fromJson(raw! as Map<String, Object?>);

List<WidgetNode> _readChildren(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final entry in raw)
      if (entry is Map<String, Object?>) WidgetNode.fromJson(entry),
  ];
}

@immutable
class WidgetBox extends WidgetNode {
  const WidgetBox({this.style, this.child});
  factory WidgetBox.fromJson(Map<String, Object?> json) => WidgetBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        child: json['child'] is Map<String, Object?> ? _readWidgetNode(json['child']) : null,
      );
  final StyleNode? style;
  final WidgetNode? child;
  @override
  String get widget => 'Box';
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        if (style != null) 'style': style!.toJson(),
        if (child != null) 'child': child!.toJson(),
      };
  @override
  bool operator ==(Object other) =>
      other is WidgetBox && other.style == style && other.child == child;
  @override
  int get hashCode => Object.hash(WidgetBox, style, child);
}

@immutable
abstract base class _FlexLikeWidget extends WidgetNode {
  const _FlexLikeWidget({this.style, required this.children});
  final StyleNode? style;
  final List<WidgetNode> children;
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        if (style != null) 'style': style!.toJson(),
        'children': [for (final c in children) c.toJson()],
      };
  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is _FlexLikeWidget &&
      other.style == style &&
      _listEqual(other.children, children);
  @override
  int get hashCode =>
      Object.hash(runtimeType, style, Object.hashAll(children));
}

@immutable
final class WidgetFlexBox extends _FlexLikeWidget {
  const WidgetFlexBox({super.style, required super.children});
  factory WidgetFlexBox.fromJson(Map<String, Object?> json) => WidgetFlexBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        children: _readChildren(json['children']),
      );
  @override
  String get widget => 'FlexBox';
}

@immutable
final class WidgetRowBox extends _FlexLikeWidget {
  const WidgetRowBox({super.style, required super.children});
  factory WidgetRowBox.fromJson(Map<String, Object?> json) => WidgetRowBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        children: _readChildren(json['children']),
      );
  @override
  String get widget => 'RowBox';
}

@immutable
final class WidgetColumnBox extends _FlexLikeWidget {
  const WidgetColumnBox({super.style, required super.children});
  factory WidgetColumnBox.fromJson(Map<String, Object?> json) => WidgetColumnBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        children: _readChildren(json['children']),
      );
  @override
  String get widget => 'ColumnBox';
}

@immutable
final class WidgetStackBox extends _FlexLikeWidget {
  const WidgetStackBox({super.style, required super.children});
  factory WidgetStackBox.fromJson(Map<String, Object?> json) => WidgetStackBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        children: _readChildren(json['children']),
      );
  @override
  String get widget => 'StackBox';
}

@immutable
class WidgetStyledText extends WidgetNode {
  const WidgetStyledText({required this.text, this.style});
  factory WidgetStyledText.fromJson(Map<String, Object?> json) => WidgetStyledText(
        text: json['text']! as String,
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
      );
  final String text;
  final StyleNode? style;
  @override
  String get widget => 'StyledText';
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        'text': text,
        if (style != null) 'style': style!.toJson(),
      };
  @override
  bool operator ==(Object other) =>
      other is WidgetStyledText && other.text == text && other.style == style;
  @override
  int get hashCode => Object.hash(WidgetStyledText, text, style);
}

@immutable
class WidgetStyledIcon extends WidgetNode {
  const WidgetStyledIcon({required this.icon, this.style});
  factory WidgetStyledIcon.fromJson(Map<String, Object?> json) => WidgetStyledIcon(
        icon: IconLiteral.fromJson(json['icon']! as Map<String, Object?>),
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
      );
  final IconLiteral icon;
  final StyleNode? style;
  @override
  String get widget => 'StyledIcon';
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        'icon': icon.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
  @override
  bool operator ==(Object other) =>
      other is WidgetStyledIcon && other.icon == icon && other.style == style;
  @override
  int get hashCode => Object.hash(WidgetStyledIcon, icon, style);
}

@immutable
class WidgetStyledImage extends WidgetNode {
  const WidgetStyledImage({required this.image, this.style});
  factory WidgetStyledImage.fromJson(Map<String, Object?> json) => WidgetStyledImage(
        image: ImageLiteral.fromJson(json['image']! as Map<String, Object?>),
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
      );
  final ImageLiteral image;
  final StyleNode? style;
  @override
  String get widget => 'StyledImage';
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        'image': image.toJson(),
        if (style != null) 'style': style!.toJson(),
      };
  @override
  bool operator ==(Object other) =>
      other is WidgetStyledImage && other.image == image && other.style == style;
  @override
  int get hashCode => Object.hash(WidgetStyledImage, image, style);
}

@immutable
class WidgetPressable extends WidgetNode {
  const WidgetPressable({required this.child});
  factory WidgetPressable.fromJson(Map<String, Object?> json) => WidgetPressable(
        child: _readWidgetNode(json['child']),
      );
  final WidgetNode child;
  @override
  String get widget => 'Pressable';
  @override
  Map<String, Object?> toJson() => {'widget': widget, 'child': child.toJson()};
  @override
  bool operator ==(Object other) =>
      other is WidgetPressable && other.child == child;
  @override
  int get hashCode => Object.hash(WidgetPressable, child);
}

@immutable
class WidgetPressableBox extends WidgetNode {
  const WidgetPressableBox({this.style, this.child});
  factory WidgetPressableBox.fromJson(Map<String, Object?> json) => WidgetPressableBox(
        style: json['style'] is Map<String, Object?>
            ? StyleNode.fromJson(json['style']! as Map<String, Object?>)
            : null,
        child: json['child'] is Map<String, Object?>
            ? _readWidgetNode(json['child'])
            : null,
      );
  final StyleNode? style;
  final WidgetNode? child;
  @override
  String get widget => 'PressableBox';
  @override
  Map<String, Object?> toJson() => {
        'widget': widget,
        if (style != null) 'style': style!.toJson(),
        if (child != null) 'child': child!.toJson(),
      };
  @override
  bool operator ==(Object other) =>
      other is WidgetPressableBox &&
      other.style == style &&
      other.child == child;
  @override
  int get hashCode => Object.hash(WidgetPressableBox, style, child);
}

@immutable
class WidgetExtension extends WidgetNode {
  const WidgetExtension(this.key, this.payload);
  factory WidgetExtension.fromJson(Map<String, Object?> json) {
    final widget = json['widget']! as String;
    final payload = <String, Object?>{...json}..remove('widget');
    return WidgetExtension(ExtensionId.unsafe(widget), payload);
  }
  final ExtensionId key;
  final Map<String, Object?> payload;
  @override
  String get widget => key.value;
  @override
  Map<String, Object?> toJson() => {'widget': widget, ...payload};

  @override
  bool operator ==(Object other) {
    if (other is! WidgetExtension) return false;
    if (other.key != key) return false;
    if (other.payload.length != payload.length) return false;
    for (final entry in payload.entries) {
      if (!other.payload.containsKey(entry.key)) return false;
      if (other.payload[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final entries = payload.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return Object.hash(
      WidgetExtension,
      key,
      Object.hashAll([for (final e in entries) ...[e.key, e.value]]),
    );
  }
}

// ---------------------------------------------------------------------------
// `textDirectives` serialization helpers. Stored as opaque Maps in the
// Phase 2 model — Phase 4 semantic stage validates that each entry is a
// StringDirective. We don't import directives.dart to keep the layering
// clean.

List<Object> _readTextDirectives(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final entry in raw)
      if (entry != null) entry as Object,
  ];
}
