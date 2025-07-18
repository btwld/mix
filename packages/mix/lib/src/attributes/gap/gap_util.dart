import '../../core/attribute.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import 'space_dto.dart';

final class GapUtility<T extends Attribute> extends MixUtility<T, SpaceDto> {
  const GapUtility(super.builder);

  T call(double value) => builder(SpaceDto.value(value));

  T token(MixToken<double> token) => builder(SpaceDto.token(token));

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<double> ref) => token(ref);
}
