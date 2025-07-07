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
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;

  const BoxConstraintsDto({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  @override
  BoxConstraints resolve(MixContext mix) {
    return BoxConstraints(
      minWidth: minWidth ?? 0.0,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: minHeight ?? 0.0,
      maxHeight: maxHeight ?? double.infinity,
    );
  }

  @override
  BoxConstraintsDto merge(BoxConstraintsDto? other) {
    if (other == null) return this;

    return BoxConstraintsDto(
      minWidth: other.minWidth ?? minWidth,
      maxWidth: other.maxWidth ?? maxWidth,
      minHeight: other.minHeight ?? minHeight,
      maxHeight: other.maxHeight ?? maxHeight,
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
  late final minWidth = DoubleUtility((v) => only(minWidth: v));

  /// Utility for defining [BoxConstraintsDto.maxWidth]
  late final maxWidth = DoubleUtility((v) => only(maxWidth: v));

  /// Utility for defining [BoxConstraintsDto.minHeight]
  late final minHeight = DoubleUtility((v) => only(minHeight: v));

  /// Utility for defining [BoxConstraintsDto.maxHeight]
  late final maxHeight = DoubleUtility((v) => only(maxHeight: v));

  BoxConstraintsUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return only(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  /// Returns a new [BoxConstraintsDto] with the specified properties.
  @override
  T only({
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
}

/// Extension methods to convert [BoxConstraints] to [BoxConstraintsDto].
extension BoxConstraintsMixExt on BoxConstraints {
  /// Converts this [BoxConstraints] to a [BoxConstraintsDto].
  BoxConstraintsDto toDto() {
    return BoxConstraintsDto(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}

/// Extension methods to convert List<[BoxConstraints]> to List<[BoxConstraintsDto]>.
extension ListBoxConstraintsMixExt on List<BoxConstraints> {
  /// Converts this List<[BoxConstraints]> to a List<[BoxConstraintsDto]>.
  List<BoxConstraintsDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
