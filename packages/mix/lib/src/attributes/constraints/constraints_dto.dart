// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:mix/mix.dart';

sealed class ConstraintsDto<T extends Constraints> extends Mixable<T> {
  const ConstraintsDto();
}

/// Represents a Data transfer object of [BoxConstraints]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxConstraints]
final class BoxConstraintsDto extends ConstraintsDto<BoxConstraints> {
  // Properties use MixableProperty for cleaner merging
  final MixableProperty<double> minWidth;
  final MixableProperty<double> maxWidth;
  final MixableProperty<double> minHeight;
  final MixableProperty<double> maxHeight;

  // Main constructor accepts real values
  factory BoxConstraintsDto({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return BoxConstraintsDto.raw(
      minWidth: MixableProperty.prop(minWidth),
      maxWidth: MixableProperty.prop(maxWidth),
      minHeight: MixableProperty.prop(minHeight),
      maxHeight: MixableProperty.prop(maxHeight),
    );
  }

  // Factory that accepts MixableProperty instances
  const BoxConstraintsDto.raw({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
  });

  // Factory from BoxConstraints
  factory BoxConstraintsDto.from(BoxConstraints constraints) {
    return BoxConstraintsDto(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  BoxConstraints resolve(MixContext mix) {
    return BoxConstraints(
      minWidth: minWidth.resolve(mix) ?? 0.0,
      maxWidth: maxWidth.resolve(mix) ?? double.infinity,
      minHeight: minHeight.resolve(mix) ?? 0.0,
      maxHeight: maxHeight.resolve(mix) ?? double.infinity,
    );
  }

  @override
  BoxConstraintsDto merge(BoxConstraintsDto? other) {
    if (other == null) return this;

    return BoxConstraintsDto.raw(
      minWidth: minWidth.merge(other.minWidth),
      maxWidth: maxWidth.merge(other.maxWidth),
      minHeight: minHeight.merge(other.minHeight),
      maxHeight: maxHeight.merge(other.maxHeight),
    );
  }

  @override
  List<Object?> get props => [minWidth, maxWidth, minHeight, maxHeight];
}

/// Utility class for configuring [BoxConstraints] properties.
///
/// This class provides methods to set individual properties of a [BoxConstraints].
/// Use the methods of this class to configure specific properties of a [BoxConstraints].
class BoxConstraintsUtility<T extends StyleElement>
    extends DtoUtility<T, BoxConstraintsDto, BoxConstraints> {
  /// Utility for defining [BoxConstraintsDto.minWidth]
  late final minWidth = DoubleUtility((v) => only(minWidth: Mixable.value(v)));

  /// Utility for defining [BoxConstraintsDto.maxWidth]
  late final maxWidth = DoubleUtility((v) => only(maxWidth: Mixable.value(v)));

  /// Utility for defining [BoxConstraintsDto.minHeight]
  late final minHeight = DoubleUtility(
    (v) => only(minHeight: Mixable.value(v)),
  );

  /// Utility for defining [BoxConstraintsDto.maxHeight]
  late final maxHeight = DoubleUtility(
    (v) => only(maxHeight: Mixable.value(v)),
  );

  BoxConstraintsUtility(super.builder) : super(valueToDto: (v) => BoxConstraintsDto.from(v));

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return builder(
      BoxConstraintsDto(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
    );
  }

  /// Returns a new [BoxConstraintsDto] with the specified properties.
  @override
  T only({
    Mixable<double>? minWidth,
    Mixable<double>? maxWidth,
    Mixable<double>? minHeight,
    Mixable<double>? maxHeight,
  }) {
    return builder(
      BoxConstraintsDto.raw(
        minWidth: MixableProperty(minWidth),
        maxWidth: MixableProperty(maxWidth),
        minHeight: MixableProperty(minHeight),
        maxHeight: MixableProperty(maxHeight),
      ),
    );
  }
}

