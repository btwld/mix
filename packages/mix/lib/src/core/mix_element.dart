import 'package:flutter/widgets.dart';

import '../internal/compare_mixin.dart';
import 'factory/mix_context.dart';
import 'mix_value.dart';

// Generic directive for modifying values
@immutable
class MixDirective<T> {
  final T Function(T) modify;
  final String? debugLabel;

  const MixDirective(this.modify, {this.debugLabel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixDirective<T> &&
          runtimeType == other.runtimeType &&
          debugLabel == other.debugLabel;

  @override
  int get hashCode => debugLabel.hashCode;
}

abstract class StyleElement with EqualityMixin {
  const StyleElement();

  // Used as the key to determine how
  // attributes get merged
  Object get mergeKey => runtimeType;

  /// Merges this object with [other], returning a new object of type [T].
  StyleElement merge(covariant StyleElement? other);
}

mixin MergeableMixin<Self> {
  /// Merges this object with [other], returning a new object of type [Self].
  Self merge(covariant Self? other);
}

mixin ResolvableMixin<T> {
  /// Resolves to the concrete value using the provided context.
  T resolve(MixContext mix);
}

/// Simple value Mix - holds a direct value
@immutable
abstract class Mix<T> with EqualityMixin {
  const Mix();

  /// Resolves to the concrete value using the provided context
  T resolve(MixContext mix);

  /// Merges this mix with another mix, returning a new mix.
  Mix<T> merge(covariant Mix<T>? other);

  @protected
  V? resolveProp<V>(MixContext context, MixValue<V>? mix) {
    return mix?.resolve(context);
  }

  @protected
  MixValue<V>? mergeProp<V>(MixValue<V>? a, MixValue<V>? b) {
    return (a?.merge(b) ?? b);
  }
}

sealed class ValueMix<T> extends Mix<T> {
  final T value;
  const ValueMix(this.value);

  /// Resolves to the concrete value using the provided context.
  @override
  T resolve(MixContext mix) => value;

  /// Merges this mix with another mix, returning a new mix.
  @override
  ValueMix<T> merge(covariant ValueMix<T>? other);

  @override
  get props => [value];
}

// =============================================================================
// CONCRETE MIX IMPLEMENTATIONS FOR SCALAR VALUES
// =============================================================================

final class DoubleMix extends ValueMix<double> {
  const DoubleMix(super.value);

  @override
  DoubleMix merge(DoubleMix? other) {
    return other == null ? this : DoubleMix(other.value);
  }
}

final class IntMix extends ValueMix<int> {
  const IntMix(super.value);

  @override
  IntMix merge(IntMix? other) {
    return other == null ? this : IntMix(other.value);
  }
}

final class BoolMix extends ValueMix<bool> {
  const BoolMix(super.value);

  @override
  BoolMix merge(BoolMix? other) {
    return other == null ? this : BoolMix(other.value);
  }
}

final class StringMix extends ValueMix<String> {
  const StringMix(super.value);

  @override
  StringMix merge(StringMix? other) {
    return other == null ? this : StringMix(other.value);
  }
}

final class ColorMix extends ValueMix<Color> {
  const ColorMix(super.value);

  @override
  ColorMix merge(ColorMix? other) {
    return other == null ? this : ColorMix(other.value);
  }
}

final class OffsetMix extends ValueMix<Offset> {
  const OffsetMix(super.value);

  @override
  OffsetMix merge(OffsetMix? other) {
    return other == null ? this : OffsetMix(other.value);
  }
}

final class RadiusMix extends ValueMix<Radius> {
  const RadiusMix(super.value);

  @override
  RadiusMix merge(RadiusMix? other) {
    return other == null ? this : RadiusMix(other.value);
  }
}

final class AligmentGeometryMix extends ValueMix<AlignmentGeometry> {
  const AligmentGeometryMix(super.value);

  @override
  AligmentGeometryMix merge(AligmentGeometryMix? other) {
    return other == null ? this : AligmentGeometryMix(other.value);
  }
}

final class AlignmentDirectionalMix extends ValueMix<AlignmentDirectional> {
  const AlignmentDirectionalMix(super.value);

  @override
  AlignmentDirectionalMix merge(AlignmentDirectionalMix? other) {
    return other == null ? this : AlignmentDirectionalMix(other.value);
  }
}

final class FontWeightMix extends ValueMix<FontWeight> {
  const FontWeightMix(super.value);

  @override
  FontWeightMix merge(FontWeightMix? other) {
    return other == null ? this : FontWeightMix(other.value);
  }
}

final class FontFeatureMix extends ValueMix<FontFeature> {
  const FontFeatureMix(super.value);

  @override
  FontFeatureMix merge(FontFeatureMix? other) {
    return other == null ? this : FontFeatureMix(other.value);
  }
}

final class DurationMix extends ValueMix<Duration> {
  const DurationMix(super.value);

  @override
  DurationMix merge(DurationMix? other) {
    return other == null ? this : DurationMix(other.value);
  }
}

final class TextDecorationMix extends ValueMix<TextDecoration> {
  const TextDecorationMix(super.value);

  @override
  TextDecorationMix merge(TextDecorationMix? other) {
    return other == null ? this : TextDecorationMix(other.value);
  }
}

final class CurveMix extends ValueMix<Curve> {
  const CurveMix(super.value);

  @override
  CurveMix merge(CurveMix? other) {
    return other == null ? this : CurveMix(other.value);
  }
}

final class RectMix extends ValueMix<Rect> {
  const RectMix(super.value);

  @override
  RectMix merge(RectMix? other) {
    return other == null ? this : RectMix(other.value);
  }
}

final class PaintMix extends ValueMix<Paint> {
  const PaintMix(super.value);

  @override
  PaintMix merge(PaintMix? other) {
    return other == null ? this : PaintMix(other.value);
  }
}

final class LocaleMix extends ValueMix<Locale> {
  const LocaleMix(super.value);

  @override
  LocaleMix merge(LocaleMix? other) {
    return other == null ? this : LocaleMix(other.value);
  }
}

final class ImageProviderMix extends ValueMix<ImageProvider> {
  const ImageProviderMix(super.value);

  @override
  ImageProviderMix merge(ImageProviderMix? other) {
    return other == null ? this : ImageProviderMix(other.value);
  }
}

final class GradientTransformMix extends ValueMix<GradientTransform> {
  const GradientTransformMix(super.value);

  @override
  GradientTransformMix merge(GradientTransformMix? other) {
    return other == null ? this : GradientTransformMix(other.value);
  }
}

final class Matrix4Mix extends ValueMix<Matrix4> {
  const Matrix4Mix(super.value);

  @override
  Matrix4Mix merge(Matrix4Mix? other) {
    return other == null ? this : Matrix4Mix(other.value);
  }
}

final class TextScalerMix extends ValueMix<TextScaler> {
  const TextScalerMix(super.value);

  @override
  TextScalerMix merge(TextScalerMix? other) {
    return other == null ? this : TextScalerMix(other.value);
  }
}

final class TableColumnWidthMix extends ValueMix<TableColumnWidth> {
  const TableColumnWidthMix(super.value);

  @override
  TableColumnWidthMix merge(TableColumnWidthMix? other) {
    return other == null ? this : TableColumnWidthMix(other.value);
  }
}

final class TableBorderMix extends ValueMix<TableBorder> {
  const TableBorderMix(super.value);

  @override
  TableBorderMix merge(TableBorderMix? other) {
    return other == null ? this : TableBorderMix(other.value);
  }
}

final class EnumMix<T extends Enum> extends ValueMix<T> {
  const EnumMix(super.value);

  @override
  EnumMix<T> merge(EnumMix<T>? other) {
    return other == null ? this : EnumMix(other.value);
  }
}

// Specific enum Mix types for better type safety and API clarity
final class FontStyleMix extends EnumMix<FontStyle> {
  const FontStyleMix(super.value);

  @override
  FontStyleMix merge(FontStyleMix? other) {
    return other == null ? this : FontStyleMix(other.value);
  }
}

final class TextDecorationStyleMix extends EnumMix<TextDecorationStyle> {
  const TextDecorationStyleMix(super.value);

  @override
  TextDecorationStyleMix merge(TextDecorationStyleMix? other) {
    return other == null ? this : TextDecorationStyleMix(other.value);
  }
}

final class TextBaselineMix extends EnumMix<TextBaseline> {
  const TextBaselineMix(super.value);

  @override
  TextBaselineMix merge(TextBaselineMix? other) {
    return other == null ? this : TextBaselineMix(other.value);
  }
}

final class FontVariationMix extends ValueMix<FontVariation> {
  const FontVariationMix(super.value);

  @override
  FontVariationMix merge(FontVariationMix? other) {
    return other == null ? this : FontVariationMix(other.value);
  }
}

final class ShadowMix extends ValueMix<Shadow> {
  const ShadowMix(super.value);

  @override
  ShadowMix merge(ShadowMix? other) {
    return other == null ? this : ShadowMix(other.value);
  }
}

// Generic ListMix for handling lists of Mix types
final class ListMix<T> extends Mix<List<T>> {
  final List<Mix<T>> _mixes;

  const ListMix(this._mixes);

  @override
  List<T> resolve(MixContext context) {
    return _mixes.map((mix) => mix.resolve(context)).toList();
  }

  @override
  ListMix<T> merge(ListMix<T>? other) {
    if (other == null) return this;

    return ListMix([..._mixes, ...other._mixes]);
  }

  @override
  List<Object?> get props => [_mixes];
}

// Define a mixin for properties that have default values
// TODO: Rename this to MixableDefaultValueMixin or similar
mixin HasDefaultValue<Value> {
  @protected
  Value get defaultValue;
}
