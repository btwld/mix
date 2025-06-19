import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/strut_style/strut_style_dto.dart';
import '../../attributes/text_height_behavior/text_height_behavior_dto.dart';
import '../../attributes/text_style/text_style_dto.dart';
import '../../attributes/text_style/text_style_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/directive.dart';
import '../../core/factory/mix_data.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'text_directives_util.dart';
import 'text_widget.dart';

part 'text_spec.g.dart';

const _style = MixableFieldUtility(
  type: TextStyle,
  properties: [
    (path: 'color', alias: 'color'),
    (path: 'fontFamily', alias: 'fontFamily'),
    (path: 'fontWeight', alias: 'fontWeight'),
    (path: 'fontStyle', alias: 'fontStyle'),
    (path: 'fontSize', alias: 'fontSize'),
    (path: 'letterSpacing', alias: 'letterSpacing'),
    (path: 'wordSpacing', alias: 'wordSpacing'),
    (path: 'textBaseline', alias: 'textBaseline'),
    (path: 'backgroundColor', alias: 'backgroundColor'),
    (path: 'shadows', alias: 'shadows'),
    (path: 'fontFeatures', alias: 'fontFeatures'),
    (path: 'fontVariations', alias: 'fontVariations'),
    (path: 'decoration', alias: 'decoration'),
    (path: 'decorationColor', alias: 'decorationColor'),
    (path: 'decorationStyle', alias: 'decorationStyle'),
    (path: 'debugLabel', alias: 'debugLabel'),
    (path: 'height', alias: 'height'),
    (path: 'foreground', alias: 'foreground'),
    (path: 'background', alias: 'background'),
    (path: 'decorationThickness', alias: 'decorationThickness'),
    (path: 'fontFamilyFallback', alias: 'fontFamilyFallback'),
  ],
);

@MixableSpec()
final class TextSpec extends Spec<TextSpec> with _$TextSpec, Diagnosticable {
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextScaler? textScaler;

  @MixableField(utilities: [_style])
  final TextStyle? style;
  final TextDirection? textDirection;
  final bool? softWrap;

  @Deprecated('Use textScaler instead')
  final double? textScaleFactor;

  @MixableField(dto: MixableFieldType(type: TextHeightBehaviorDto))
  final TextHeightBehavior? textHeightBehavior;

  @MixableField(
    utilities: [
      MixableFieldUtility(
        properties: [
          (path: 'uppercase', alias: 'uppercase'),
          (path: 'lowercase', alias: 'lowercase'),
          (path: 'capitalize', alias: 'capitalize'),
          (path: 'titleCase', alias: 'titleCase'),
          (path: 'sentenceCase', alias: 'sentenceCase'),
        ],
      ),
    ],
  )
  final TextDirective? directive;

  static const of = _$TextSpec.of;

  static const from = _$TextSpec.from;

  const TextSpec({
    this.overflow,
    this.strutStyle,
    this.textAlign,
    @Deprecated('Use textScaler instead') this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.style,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textDirection,
    this.softWrap,
    this.directive,
    super.animated,
    super.modifiers,
  });

  Widget call(
    String text, {
    @Deprecated('Use semanticsLabel instead') String? semanticLabel,
    String? semanticsLabel,
    Locale? locale,
    List<Type> orderOfModifiers = const [],
  }) {
    return isAnimated
        ? AnimatedTextSpecWidget(
            text,
            spec: this,
            semanticsLabel: semanticsLabel ?? semanticLabel,
            locale: locale,
            orderOfModifiers: orderOfModifiers,
            duration: animated!.duration,
            curve: animated!.curve,
          )
        : TextSpecWidget(
            text,
            spec: this,
            semanticsLabel: semanticsLabel ?? semanticLabel,
            locale: locale,
            orderOfModifiers: orderOfModifiers,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
