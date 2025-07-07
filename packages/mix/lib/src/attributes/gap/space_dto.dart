import 'package:flutter/foundation.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../theme/tokens/mix_token.dart';

@immutable
sealed class SpaceDto extends Mixable<double> with Diagnosticable {
  // Common constants using private types
  static const zero = _ValueSpaceDto(0);

  static const infinity = _ValueSpaceDto(
    double.infinity,
  ); // Private constructor
  const SpaceDto._();

  // Public factories only
  const factory SpaceDto.value(double value) = _ValueSpaceDto;
  const factory SpaceDto.token(MixableToken<double> token) = _TokenSpaceDto;

  @override
  SpaceDto merge(SpaceDto? other) => other ?? this;
}

// Private implementations
@immutable
class _ValueSpaceDto extends SpaceDto {
  @override
  final double value;

  const _ValueSpaceDto(this.value) : super._();

  @override
  double resolve(MixContext mix) => value;

  @override
  List<Object?> get props => [value];
}

@immutable
class _TokenSpaceDto extends SpaceDto {
  final MixableToken<double> token;

  const _TokenSpaceDto(this.token) : super._();

  @override
  double resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  List<Object?> get props => [token];
}
