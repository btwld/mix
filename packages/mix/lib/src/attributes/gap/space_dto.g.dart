// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [SpaceDto].
mixin _$SpaceDto on Mixable<double> {
  /// Merges the properties of this [SpaceDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SpaceDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SpaceDto merge(SpaceDto? other) {
    if (other == null) return _$this;

    return SpaceDto._(value: other.value ?? _$this.value);
  }

  /// The list of properties that constitute the state of this [SpaceDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SpaceDto] instances for equality.
  @override
  List<Object?> get props => [_$this.value];

  /// Returns this instance as a [SpaceDto].
  SpaceDto get _$this => this as SpaceDto;
}
