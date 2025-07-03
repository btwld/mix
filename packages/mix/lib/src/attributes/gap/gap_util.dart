import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'space_dto.dart';

final class GapUtility<T extends StyleElement> extends MixUtility<T, SpaceDto> {
  const GapUtility(super.builder);

  T call(double value) => builder(SpaceDto(value));

  T token(MixableToken<double> token) => builder(SpaceDto.token(token));

  T ref(MixableToken<double> ref) => builder(SpaceDto.token(ref));
}
