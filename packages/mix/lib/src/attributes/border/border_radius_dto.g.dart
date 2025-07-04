// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_radius_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [BorderRadiusDto].
mixin _$BorderRadiusDto on Mixable<BorderRadius> {
  /// Merges the properties of this [BorderRadiusDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderRadiusDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderRadiusDto merge(BorderRadiusDto? other) {
    if (other == null) return _$this;

    return BorderRadiusDto(
      topLeft: _$this.topLeft?.merge(other.topLeft) ?? other.topLeft,
      topRight: _$this.topRight?.merge(other.topRight) ?? other.topRight,
      bottomLeft:
          _$this.bottomLeft?.merge(other.bottomLeft) ?? other.bottomLeft,
      bottomRight:
          _$this.bottomRight?.merge(other.bottomRight) ?? other.bottomRight,
    );
  }

  /// The list of properties that constitute the state of this [BorderRadiusDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderRadiusDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.topLeft,
        _$this.topRight,
        _$this.bottomLeft,
        _$this.bottomRight,
      ];

  /// Returns this instance as a [BorderRadiusDto].
  BorderRadiusDto get _$this => this as BorderRadiusDto;
}

/// Extension methods to convert [BorderRadius] to [BorderRadiusDto].
extension BorderRadiusMixExt on BorderRadius {
  /// Converts this [BorderRadius] to a [BorderRadiusDto].
  BorderRadiusDto toDto() {
    return BorderRadiusDto(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}

/// Extension methods to convert List<[BorderRadius]> to List<[BorderRadiusDto]>.
extension ListBorderRadiusMixExt on List<BorderRadius> {
  /// Converts this List<[BorderRadius]> to a List<[BorderRadiusDto]>.
  List<BorderRadiusDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [BorderRadiusDirectionalDto].
mixin _$BorderRadiusDirectionalDto on Mixable<BorderRadiusDirectional> {
  /// Merges the properties of this [BorderRadiusDirectionalDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderRadiusDirectionalDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderRadiusDirectionalDto merge(BorderRadiusDirectionalDto? other) {
    if (other == null) return _$this;

    return BorderRadiusDirectionalDto(
      topStart: _$this.topStart?.merge(other.topStart) ?? other.topStart,
      topEnd: _$this.topEnd?.merge(other.topEnd) ?? other.topEnd,
      bottomStart:
          _$this.bottomStart?.merge(other.bottomStart) ?? other.bottomStart,
      bottomEnd: _$this.bottomEnd?.merge(other.bottomEnd) ?? other.bottomEnd,
    );
  }

  /// The list of properties that constitute the state of this [BorderRadiusDirectionalDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderRadiusDirectionalDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.topStart,
        _$this.topEnd,
        _$this.bottomStart,
        _$this.bottomEnd,
      ];

  /// Returns this instance as a [BorderRadiusDirectionalDto].
  BorderRadiusDirectionalDto get _$this => this as BorderRadiusDirectionalDto;
}

/// Extension methods to convert [BorderRadiusDirectional] to [BorderRadiusDirectionalDto].
extension BorderRadiusDirectionalMixExt on BorderRadiusDirectional {
  /// Converts this [BorderRadiusDirectional] to a [BorderRadiusDirectionalDto].
  BorderRadiusDirectionalDto toDto() {
    return BorderRadiusDirectionalDto(
      topStart: topStart,
      topEnd: topEnd,
      bottomStart: bottomStart,
      bottomEnd: bottomEnd,
    );
  }
}

/// Extension methods to convert List<[BorderRadiusDirectional]> to List<[BorderRadiusDirectionalDto]>.
extension ListBorderRadiusDirectionalMixExt on List<BorderRadiusDirectional> {
  /// Converts this List<[BorderRadiusDirectional]> to a List<[BorderRadiusDirectionalDto]>.
  List<BorderRadiusDirectionalDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}
