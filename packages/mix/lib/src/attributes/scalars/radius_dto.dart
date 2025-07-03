import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../theme/tokens/mix_token.dart';

/// A Data transfer object that represents a [Radius] value.
///
/// This DTO is used to resolve a [Radius] value from a [MixContext] instance.
/// It can hold either a direct radius value or a token reference.
///
/// See also:
/// * [Token], which is used to reference theme values.
/// * [Radius], which is the Flutter equivalent class.
@immutable
class RadiusDto extends Mixable<Radius> with Diagnosticable {
  final Radius? value;

  @protected
  const RadiusDto.internal({this.value, super.token});
  const RadiusDto(Radius value) : this.internal(value: value);

  factory RadiusDto.token(MixableToken<Radius> token) =>
      RadiusDto.internal(token: token);

  @override
  Radius resolve(MixContext mix) {
    final tokenValue = super.resolve(mix);

    return tokenValue ?? value ?? Radius.zero;
  }

  @override
  RadiusDto merge(RadiusDto? other) {
    if (other == null) return this;

    return RadiusDto.internal(
      value: other.value ?? value,
      token: other.token ?? token,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (token != null) {
      properties.add(DiagnosticsProperty('token', token?.toString()));

      return;
    }

    final radius = value ?? Radius.zero;
    properties.add(DiagnosticsProperty('radius', radius));
  }

  @override
  List<Object?> get props => [value, token];
}

extension RadiusExt on Radius {
  RadiusDto toDto() => RadiusDto(this);
}
