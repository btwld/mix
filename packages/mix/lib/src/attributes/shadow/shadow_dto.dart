// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'shadow_dto.g.dart';

sealed class ShadowDtoImpl<T extends Shadow> extends Mixable<T> {
  final ColorDto? color;
  final Offset? offset;
  final double? blurRadius;

  const ShadowDtoImpl({this.blurRadius, this.color, this.offset});
}

/// Represents a [Mixable] Data transfer object of [Shadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [Shadow]
@MixableType()
class ShadowDto extends ShadowDtoImpl<Shadow>
    with HasDefaultValue<Shadow>, _$ShadowDto {
  const ShadowDto({super.blurRadius, super.color, super.offset});

  @override
  Shadow get defaultValue => const Shadow();
}

/// Represents a [Mixable] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
@MixableType()
class BoxShadowDto extends ShadowDtoImpl<BoxShadow>
    with HasDefaultValue<BoxShadow>, _$BoxShadowDto {
  final double? spreadRadius;

  const BoxShadowDto({
    super.color,
    super.offset,
    super.blurRadius,
    this.spreadRadius,
  });

  @override
  BoxShadow get defaultValue => const BoxShadow();
}
