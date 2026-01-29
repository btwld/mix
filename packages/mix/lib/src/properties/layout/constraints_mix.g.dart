// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constraints_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$BoxConstraintsMixMixin
    on Mix<BoxConstraints>, DefaultValue<BoxConstraints>, Diagnosticable {
  Prop<double>? get $maxHeight;
  Prop<double>? get $maxWidth;
  Prop<double>? get $minHeight;
  Prop<double>? get $minWidth;

  /// Merges with another [BoxConstraintsMix].
  @override
  BoxConstraintsMix merge(BoxConstraintsMix? other) {
    return BoxConstraintsMix.create(
      maxHeight: MixOps.merge($maxHeight, other?.$maxHeight),
      maxWidth: MixOps.merge($maxWidth, other?.$maxWidth),
      minHeight: MixOps.merge($minHeight, other?.$minHeight),
      minWidth: MixOps.merge($minWidth, other?.$minWidth),
    );
  }

  /// Resolves to [BoxConstraints] using context.
  @override
  BoxConstraints resolve(BuildContext context) {
    return BoxConstraints(
      maxHeight: MixOps.resolve(context, $maxHeight) ?? defaultValue.maxHeight,
      maxWidth: MixOps.resolve(context, $maxWidth) ?? defaultValue.maxWidth,
      minHeight: MixOps.resolve(context, $minHeight) ?? defaultValue.minHeight,
      minWidth: MixOps.resolve(context, $minWidth) ?? defaultValue.minWidth,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('maxHeight', $maxHeight))
      ..add(DiagnosticsProperty('maxWidth', $maxWidth))
      ..add(DiagnosticsProperty('minHeight', $minHeight))
      ..add(DiagnosticsProperty('minWidth', $minWidth));
  }

  @override
  List<Object?> get props => [$maxHeight, $maxWidth, $minHeight, $minWidth];
}
