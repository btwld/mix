import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';

/// Specification for icon styling properties.
///
/// Provides comprehensive icon styling including color, size, weight, optical properties,
/// text direction, scaling behavior, and shadow effects.
final class IconWidgetSpec extends WidgetSpec<IconWidgetSpec> {
  /// The color to use when drawing the icon.
  final Color? color;

  /// The size of the icon in logical pixels.
  final double? size;

  /// The font weight variant (100-900) for supported icon fonts.
  final double? weight;

  /// The grade variant (-25 to 200) for supported icon fonts.
  final double? grade;

  /// The optical size variant (20-48) for supported icon fonts.
  final double? opticalSize;

  /// The text direction to use for rendering the icon.
  final TextDirection? textDirection;

  /// Whether to scale the icon according to the textScaleFactor.
  final bool? applyTextScaling;

  /// A list of shadows to paint behind the icon.
  final List<Shadow>? shadows;

  /// The fill variant (0.0-1.0) for supported icon fonts.
  final double? fill;

  /// Semantic description for accessibility.
  final String? semanticsLabel;

  /// The blend mode to apply when drawing the icon.
  final BlendMode? blendMode;

  /// The icon data to display.
  final IconData? icon;

  const IconWidgetSpec({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    this.semanticsLabel,
    this.blendMode,
    this.icon,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  });

  @override
  IconWidgetSpec copyWith({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<Shadow>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    BlendMode? blendMode,
    IconData? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return IconWidgetSpec(
      color: color ?? this.color,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      shadows: shadows ?? this.shadows,
      textDirection: textDirection ?? this.textDirection,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
      fill: fill ?? this.fill,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      blendMode: blendMode ?? this.blendMode,
      icon: icon ?? this.icon,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  IconWidgetSpec lerp(IconWidgetSpec? other, double t) {
    return IconWidgetSpec(
      color: MixOps.lerp(color, other?.color, t),
      size: MixOps.lerp(size, other?.size, t),
      weight: MixOps.lerp(weight, other?.weight, t),
      grade: MixOps.lerp(grade, other?.grade, t),
      opticalSize: MixOps.lerp(opticalSize, other?.opticalSize, t),
      shadows: MixOps.lerp(shadows, other?.shadows, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      applyTextScaling: MixOps.lerpSnap(
        applyTextScaling,
        other?.applyTextScaling,
        t,
      ),
      fill: MixOps.lerp(fill, other?.fill, t),
      semanticsLabel: MixOps.lerpSnap(semanticsLabel, other?.semanticsLabel, t),
      blendMode: MixOps.lerpSnap(blendMode, other?.blendMode, t),
      icon: MixOps.lerpSnap(icon, other?.icon, t),
      // Meta fields: use confirmed policy other?.field ?? this.field
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('weight', weight))
      ..add(DoubleProperty('grade', grade))
      ..add(DoubleProperty('opticalSize', opticalSize))
      ..add(IterableProperty<Shadow>('shadows', shadows))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(
        FlagProperty(
          'applyTextScaling',
          value: applyTextScaling,
          ifTrue: 'scales with text',
        ),
      )
      ..add(DoubleProperty('fill', fill))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(EnumProperty<BlendMode>('blendMode', blendMode))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [
    ...super.props,
    color,
    size,
    weight,
    grade,
    opticalSize,
    shadows,
    textDirection,
    applyTextScaling,
    fill,
    semanticsLabel,
    blendMode,
    icon,
  ];
}
