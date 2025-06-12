import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/mix_token.dart';

/// A Data transfer object that represents a [Radius] value.
///
/// This DTO is used to resolve a [Radius] value from a [MixData] instance.
/// It can hold either a direct radius value or a token reference.
///
/// See also:
/// * [Token], which is used to reference theme values.
/// * [Radius], which is the Flutter equivalent class.
@immutable
class RadiusDto extends Mixable<Radius> with Diagnosticable {
  final Radius? value;
  final MixToken<Radius>? token;

  const RadiusDto.raw({this.value, this.token});
  const RadiusDto(Radius value) : this.raw(value: value);

  factory RadiusDto.token(MixToken<Radius> token) => RadiusDto.raw(token: token);

  @override
  Radius resolve(MixData mix) {
    // Direct token resolution using unified resolver system
    if (token != null) {
      return mix.tokens.resolveToken(token!.name);
    }

    return value ?? Radius.zero;
  }

  @override
  RadiusDto merge(RadiusDto? other) {
    if (other == null) return this;

    return RadiusDto.raw(
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
