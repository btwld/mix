// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constraints_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [BoxConstraintsDto].
mixin _$BoxConstraintsDto on Mixable<BoxConstraints> {
  /// Resolves to [BoxConstraints] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxConstraints = BoxConstraintsDto(...).resolve(mix);
  /// ```
  @override
  BoxConstraints resolve(MixContext mix) {
    return BoxConstraints(
      minWidth: _$this.minWidth?.resolve(mix) ?? 0.0,
      maxWidth: _$this.maxWidth?.resolve(mix) ?? double.infinity,
      minHeight: _$this.minHeight?.resolve(mix) ?? 0.0,
      maxHeight: _$this.maxHeight?.resolve(mix) ?? double.infinity,
    );
  }

  /// Merges the properties of this [BoxConstraintsDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxConstraintsDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxConstraintsDto merge(BoxConstraintsDto? other) {
    if (other == null) return _$this;

    return BoxConstraintsDto(
      minWidth: _$this.minWidth?.merge(other.minWidth) ?? other.minWidth,
      maxWidth: _$this.maxWidth?.merge(other.maxWidth) ?? other.maxWidth,
      minHeight: _$this.minHeight?.merge(other.minHeight) ?? other.minHeight,
      maxHeight: _$this.maxHeight?.merge(other.maxHeight) ?? other.maxHeight,
    );
  }

  /// The list of properties that constitute the state of this [BoxConstraintsDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxConstraintsDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.minWidth,
        _$this.maxWidth,
        _$this.minHeight,
        _$this.maxHeight,
      ];

  /// Returns this instance as a [BoxConstraintsDto].
  BoxConstraintsDto get _$this => this as BoxConstraintsDto;
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

  /// Returns a new [BoxConstraintsDto] with the specified properties.
  @override
  T only({
    SpaceDto? minWidth,
    SpaceDto? maxWidth,
    SpaceDto? minHeight,
    SpaceDto? maxHeight,
  }) {
    return builder(BoxConstraintsDto(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    ));
  }

  T call({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return only(
      minWidth: minWidth?.toDto(),
      maxWidth: maxWidth?.toDto(),
      minHeight: minHeight?.toDto(),
      maxHeight: maxHeight?.toDto(),
    );
  }
}

/// Extension methods to convert [BoxConstraints] to [BoxConstraintsDto].
extension BoxConstraintsMixExt on BoxConstraints {
  /// Converts this [BoxConstraints] to a [BoxConstraintsDto].
  BoxConstraintsDto toDto() {
    return BoxConstraintsDto(
      minWidth: minWidth.toDto(),
      maxWidth: maxWidth.toDto(),
      minHeight: minHeight.toDto(),
      maxHeight: maxHeight.toDto(),
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
