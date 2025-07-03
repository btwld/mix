import 'package:mix_annotations/mix_annotations.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';

part 'space_dto.g.dart';

@Deprecated('Use SpaceDto instead')
typedef SpacingSideDto = SpaceDto;

@MixableType(components: GeneratedPropertyComponents.none)
class SpaceDto extends Mixable<double> with _$SpaceDto {
  final double? value;
  final MixToken<double>? token;

  @MixableConstructor()
  const SpaceDto._({this.value, this.token});
  const SpaceDto(this.value) : token = null;

  factory SpaceDto.token(MixToken<double> token) => SpaceDto._(token: token);

  @override
  double resolve(MixData mix) {
    // Type-safe, direct resolution using MixToken object
    if (token != null) {
      return mix.tokens.resolveToken<double>(token!);
    }
    
    return value ?? 0.0;
  }
}
