import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../theme/tokens/mix_token.dart';

/// A Data transfer object that represents a [Radius] value.
/// Can be either a direct value or a token reference.
@immutable
sealed class RadiusDto extends Mixable<Radius> with Diagnosticable {
  const RadiusDto();

  const factory RadiusDto.value(Radius value) = ValueRadiusDto;
  const factory RadiusDto.token(MixableToken<Radius> token) = TokenRadiusDto;

  // Convenience factories for common cases
  factory RadiusDto.circular(double radius) = ValueRadiusDto.circular;
  factory RadiusDto.elliptical(double x, double y) = ValueRadiusDto.elliptical;
}

/// A RadiusDto that holds a direct Radius value
@immutable
class ValueRadiusDto extends RadiusDto {
  final Radius value;

  static const zero = ValueRadiusDto(Radius.zero);

  const ValueRadiusDto(this.value);

  // Mirror Radius API for convenience
  ValueRadiusDto.circular(double radius) : value = Radius.circular(radius);

  ValueRadiusDto.elliptical(double x, double y)
      : value = Radius.elliptical(x, y);

  @override
  Radius resolve(MixContext mix) => value;

  @override
  RadiusDto merge(RadiusDto? other) => other ?? this;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('radius', value));
  }

  @override
  List<Object?> get props => [value];
}

/// A RadiusDto that holds a token reference
@immutable
class TokenRadiusDto extends RadiusDto {
  final MixableToken<Radius> token;

  const TokenRadiusDto(this.token);

  @override
  Radius resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  RadiusDto merge(RadiusDto? other) => other ?? this;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('token', token.name));
  }

  @override
  List<Object?> get props => [token];
}

// Extension for easy conversion
extension RadiusExt on Radius {
  RadiusDto toDto() => ValueRadiusDto(this);
}
