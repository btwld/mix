// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

mixin _$IconSpecMethods on Spec<IconSpec>, Diagnosticable {
  Color? get color;
  double? get size;
  double? get weight;
  double? get grade;
  double? get opticalSize;
  List<Shadow>? get shadows;
  TextDirection? get textDirection;
  bool? get applyTextScaling;
  double? get fill;
  String? get semanticsLabel;
  double? get opacity;
  BlendMode? get blendMode;
  IconData? get icon;

  @override
  IconSpec copyWith({
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
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
  }) {
    return IconSpec(
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
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      icon: icon ?? this.icon,
    );
  }

  @override
  IconSpec lerp(IconSpec? other, double t) {
    return IconSpec(
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
      opacity: MixOps.lerp(opacity, other?.opacity, t),
      blendMode: MixOps.lerpSnap(blendMode, other?.blendMode, t),
      icon: MixOps.lerpSnap(icon, other?.icon, t),
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
      ..add(DoubleProperty('opacity', opacity))
      ..add(EnumProperty<BlendMode>('blendMode', blendMode))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [
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
    opacity,
    blendMode,
    icon,
  ];
}
