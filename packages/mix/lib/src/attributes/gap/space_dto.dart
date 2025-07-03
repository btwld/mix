import 'package:mix_annotations/mix_annotations.dart';

import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../theme/tokens/mix_token.dart' as tokens;

part 'space_dto.g.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@MixableType(components: GeneratedPropertyComponents.none)
class SpaceDto extends Mixable<double> with _$SpaceDto {
  final double? value;

  @MixableConstructor()
  const SpaceDto._({this.value, super.token});
  const SpaceDto(this.value);

  factory SpaceDto.token(tokens.MixableToken<double> token) =>
      SpaceDto._(token: token);

  @override
  double resolve(MixContext mix) {
    // Must call super.resolve() first - returns token value or null
    final tokenValue = super.resolve(mix);

    return tokenValue ?? value ?? 0.0;
  }
}
