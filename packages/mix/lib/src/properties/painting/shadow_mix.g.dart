// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadow_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$ShadowMixMixin on Mix<Shadow>, DefaultValue<Shadow>, Diagnosticable {
  Prop<double>? get $blurRadius;
  Prop<Color>? get $color;
  Prop<Offset>? get $offset;

  /// Merges with another [ShadowMix].
  @override
  ShadowMix merge(ShadowMix? other) {
    return ShadowMix.create(
      blurRadius: MixOps.merge($blurRadius, other?.$blurRadius),
      color: MixOps.merge($color, other?.$color),
      offset: MixOps.merge($offset, other?.$offset),
    );
  }

  /// Resolves to [Shadow] using context.
  @override
  Shadow resolve(BuildContext context) {
    return Shadow(
      blurRadius:
          MixOps.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      offset: MixOps.resolve(context, $offset) ?? defaultValue.offset,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('blurRadius', $blurRadius))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('offset', $offset));
  }

  @override
  List<Object?> get props => [$blurRadius, $color, $offset];
}

mixin _$BoxShadowMixMixin
    on Mix<BoxShadow>, DefaultValue<BoxShadow>, Diagnosticable {
  Prop<double>? get $blurRadius;
  Prop<Color>? get $color;
  Prop<Offset>? get $offset;
  Prop<double>? get $spreadRadius;

  /// Merges with another [BoxShadowMix].
  @override
  BoxShadowMix merge(BoxShadowMix? other) {
    return BoxShadowMix.create(
      blurRadius: MixOps.merge($blurRadius, other?.$blurRadius),
      color: MixOps.merge($color, other?.$color),
      offset: MixOps.merge($offset, other?.$offset),
      spreadRadius: MixOps.merge($spreadRadius, other?.$spreadRadius),
    );
  }

  /// Resolves to [BoxShadow] using context.
  @override
  BoxShadow resolve(BuildContext context) {
    return BoxShadow(
      blurRadius:
          MixOps.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      offset: MixOps.resolve(context, $offset) ?? defaultValue.offset,
      spreadRadius:
          MixOps.resolve(context, $spreadRadius) ?? defaultValue.spreadRadius,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('blurRadius', $blurRadius))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('offset', $offset))
      ..add(DiagnosticsProperty('spreadRadius', $spreadRadius));
  }

  @override
  List<Object?> get props => [$blurRadius, $color, $offset, $spreadRadius];
}
