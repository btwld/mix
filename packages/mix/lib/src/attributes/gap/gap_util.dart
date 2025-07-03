import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../../theme/tokens/space_token.dart';
import 'space_dto.dart';

final class GapUtility<T extends StyleElement> extends MixUtility<T, SpaceDto> {
  const GapUtility(super.builder);

  T call(double value) => builder(SpaceDto(value));

  T token(MixToken<double> token) => builder(SpaceDto.token(token));

  T ref(SpaceToken ref) => builder(SpaceDto(ref()));
}
