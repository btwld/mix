import 'package:flutter/foundation.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../theme/tokens/mix_token.dart';

@immutable
sealed class SpaceDto extends Mix<double> with Diagnosticable {
  // Common constants using private types
  static const zero = _ValueSpaceDto(0);

  static const infinity = _ValueSpaceDto(
    double.infinity,
  ); // Private constructor
  const SpaceDto._();

  // Public factories only
  const factory SpaceDto.value(double value) = _ValueSpaceDto;
  const factory SpaceDto.token(MixableToken<double> token) = _TokenSpaceDto;

  /// Constructor that accepts a nullable [double] value and creates a [SpaceDto].
  ///
  /// Returns null if the input is null, otherwise uses [SpaceDto.value].
  ///
  /// ```dart
  /// const double? gap = 16.0;
  /// final dto = SpaceDto.maybeValue(gap); // Returns SpaceDto or null
  /// ```
  static SpaceDto? maybeValue(double? value) {
    return value != null ? SpaceDto.value(value) : null;
  }

  @override
  SpaceDto merge(SpaceDto? other) => other ?? this;
}

// Private implementations
@immutable
class _ValueSpaceDto extends SpaceDto {
  final double value;

  const _ValueSpaceDto(this.value) : super._();

  @override
  double resolve(MixContext context) => value;

  @override
  List<Object?> get props => [value];
}

@immutable
class _TokenSpaceDto extends SpaceDto {
  final MixableToken<double> token;

  const _TokenSpaceDto(this.token) : super._();

  @override
  double resolve(MixContext context) {
    return context.scope.getToken(token, context.context);
  }

  @override
  List<Object?> get props => [token];
}
