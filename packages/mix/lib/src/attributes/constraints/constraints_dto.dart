// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:mix/mix.dart';

sealed class ConstraintsDto<T extends Constraints> extends Mix<T> {
  const ConstraintsDto();
}

/// Represents a Data transfer object of [BoxConstraints]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxConstraints]
final class BoxConstraintsDto extends ConstraintsDto<BoxConstraints> {
  // Properties use MixProp for cleaner merging
  final MixProp<double> minWidth;
  final MixProp<double> maxWidth;
  final MixProp<double> minHeight;
  final MixProp<double> maxHeight;

  // Main constructor accepts Mix values
  factory BoxConstraintsDto({
    Mix<double>? minWidth,
    Mix<double>? maxWidth,
    Mix<double>? minHeight,
    Mix<double>? maxHeight,
  }) {
    return BoxConstraintsDto._(
      minWidth: MixProp(minWidth),
      maxWidth: MixProp(maxWidth),
      minHeight: MixProp(minHeight),
      maxHeight: MixProp(maxHeight),
    );
  }

  // Private constructor that accepts MixProp instances
  const BoxConstraintsDto._({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
  });

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

    return BoxConstraintsDto._(
      minWidth: minWidth.merge(other.minWidth),
      maxWidth: maxWidth.merge(other.maxWidth),
      minHeight: minHeight.merge(other.minHeight),
      maxHeight: maxHeight.merge(other.maxHeight),
    );
  }

  @override
  List<Object?> get props => [minWidth, maxWidth, minHeight, maxHeight];
}

