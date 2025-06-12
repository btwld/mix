import 'package:mix_annotations/mix_annotations.dart';

import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../theme/tokens/space_token.dart';
import '../../theme/tokens/token.dart';

part 'space_dto.g.dart';

@Deprecated('Use SpaceDto instead')
typedef SpacingSideDto = SpaceDto;

@MixableType(components: GeneratedPropertyComponents.none)
class SpaceDto extends Mixable<double> with _$SpaceDto {
  final double? value;
  final Token<double>? token;

  @MixableConstructor()
  const SpaceDto._({this.value, this.token});
  const SpaceDto(this.value) : token = null;

  factory SpaceDto.token(Token<double> token) => SpaceDto._(token: token);

  @override
  double resolve(MixData mix) {
    // Handle token resolution first
    if (token != null) {
      // Resolve through the token resolver using the old token type for compatibility
      final spaceToken = SpaceToken(token!.name);

      return mix.tokens.spaceToken(spaceToken);
    }

    return mix.tokens.spaceTokenRef(value ?? 0);
  }
}
