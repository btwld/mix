// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_insets_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [EdgeInsetsDto].
mixin _$EdgeInsetsDto on Mixable<EdgeInsets> {
  /// Merges the properties of this [EdgeInsetsDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [EdgeInsetsDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return _$this;

    return EdgeInsetsDto.raw(
      top: _$this.top?.merge(other.top) ?? other.top,
      bottom: _$this.bottom?.merge(other.bottom) ?? other.bottom,
      left: _$this.left?.merge(other.left) ?? other.left,
      right: _$this.right?.merge(other.right) ?? other.right,
    );
  }

  /// The list of properties that constitute the state of this [EdgeInsetsDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [EdgeInsetsDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.top,
        _$this.bottom,
        _$this.left,
        _$this.right,
      ];

  /// Returns this instance as a [EdgeInsetsDto].
  EdgeInsetsDto get _$this => this as EdgeInsetsDto;
}

/// A mixin that provides DTO functionality for [EdgeInsetsDirectionalDto].
mixin _$EdgeInsetsDirectionalDto on Mixable<EdgeInsetsDirectional> {
  /// Merges the properties of this [EdgeInsetsDirectionalDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [EdgeInsetsDirectionalDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return _$this;

    return EdgeInsetsDirectionalDto.raw(
      top: _$this.top?.merge(other.top) ?? other.top,
      bottom: _$this.bottom?.merge(other.bottom) ?? other.bottom,
      start: _$this.start?.merge(other.start) ?? other.start,
      end: _$this.end?.merge(other.end) ?? other.end,
    );
  }

  /// The list of properties that constitute the state of this [EdgeInsetsDirectionalDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [EdgeInsetsDirectionalDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.top,
        _$this.bottom,
        _$this.start,
        _$this.end,
      ];

  /// Returns this instance as a [EdgeInsetsDirectionalDto].
  EdgeInsetsDirectionalDto get _$this => this as EdgeInsetsDirectionalDto;
}
