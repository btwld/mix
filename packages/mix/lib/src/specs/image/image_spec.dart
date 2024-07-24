import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/color/color_dto.dart';
import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/attribute.dart';
import '../../core/factory/mix_data.dart';
import '../../core/factory/mix_provider.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'image_widget.dart';

part 'image_spec.g.dart';

@MixableSpec()
final class ImageSpec extends Spec<ImageSpec> with _$ImageSpec, Diagnosticable {
  final double? width, height;
  final Color? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;

  final BlendMode? colorBlendMode;

  static const of = _$ImageSpec.of;

  static const from = _$ImageSpec.from;

  const ImageSpec({
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
    super.animated,
    super.modifiers,
  });

  Widget call({
    required ImageProvider<Object> image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    bool matchTextDirection = false,
    Animation<double>? opacity,
  }) {
    return isAnimated
        ? AnimatedImageSpecWidget(
            spec: this,
            image: image,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            duration: animated!.duration,
            curve: animated!.curve,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            matchTextDirection: matchTextDirection,
            opacity: opacity,
          )
        : ImageSpecWidget(
            spec: this,
            image: image,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            opacity: opacity,
            matchTextDirection: matchTextDirection,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
