// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$FlexSpecMethods on Spec<FlexSpec>, Diagnosticable {
  Axis? get direction;
  MainAxisAlignment? get mainAxisAlignment;
  CrossAxisAlignment? get crossAxisAlignment;
  MainAxisSize? get mainAxisSize;
  VerticalDirection? get verticalDirection;
  TextDirection? get textDirection;
  TextBaseline? get textBaseline;
  Clip? get clipBehavior;
  double? get spacing;

  @override
  FlexSpec copyWith({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
  }) {
    return FlexSpec(
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    return FlexSpec(
      direction: MixOps.lerpSnap(direction, other?.direction, t),
      mainAxisAlignment: MixOps.lerpSnap(
        mainAxisAlignment,
        other?.mainAxisAlignment,
        t,
      ),
      crossAxisAlignment: MixOps.lerpSnap(
        crossAxisAlignment,
        other?.crossAxisAlignment,
        t,
      ),
      mainAxisSize: MixOps.lerpSnap(mainAxisSize, other?.mainAxisSize, t),
      verticalDirection: MixOps.lerpSnap(
        verticalDirection,
        other?.verticalDirection,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      textBaseline: MixOps.lerpSnap(textBaseline, other?.textBaseline, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(
        EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment),
      )
      ..add(
        EnumProperty<CrossAxisAlignment>(
          'crossAxisAlignment',
          crossAxisAlignment,
        ),
      )
      ..add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize))
      ..add(
        EnumProperty<VerticalDirection>('verticalDirection', verticalDirection),
      )
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<TextBaseline>('textBaseline', textBaseline))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DoubleProperty('spacing', spacing));
  }

  @override
  List<Object?> get props => [
    direction,
    mainAxisAlignment,
    crossAxisAlignment,
    mainAxisSize,
    verticalDirection,
    textDirection,
    textBaseline,
    clipBehavior,
    spacing,
  ];
}
