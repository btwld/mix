import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/space_token.dart';
import 'space_dto.dart';

@Deprecated('Use FlexSpacingUtility instead')
typedef GapUtility<T extends Attribute> = MixUtility<T, SpaceDto>;

final class FlexSpacingUtility<T extends Attribute>
    extends MixUtility<T, SpaceDto> {
  const FlexSpacingUtility(super.builder);

  T call(double value) => builder(SpaceDto(value));

  T ref(SpaceToken ref) => builder(SpaceDto(ref()));
}
