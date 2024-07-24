import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/strut_style/strut_style_dto.dart';
import '../../attributes/text_style/text_style_dto.dart';
import '../../attributes/text_style/text_style_util.dart';
import '../../core/attribute.dart';
import '../../core/directive.dart';
import '../../core/factory/mix_data.dart';
import '../../core/factory/mix_provider.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'text_directives_util.dart';
import 'text_widget.dart';

part 'text_spec.g.dart';

@MixableSpec()
final class TextSpec extends Spec<TextSpec> with _$TextSpec, Diagnosticable {
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final TextScaler? textScaler;
  final TextStyle? style;
  final TextDirection? textDirection;
  final bool? softWrap;

  @Deprecated('Use textScaler instead')
  final double? textScaleFactor;

  @MixableProperty(
    utilities: [
      MixableUtility(
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

  Widget call(String text, {String? semanticLabel, Locale? locale}) {
    return isAnimated
        ? AnimatedTextSpecWidget(
            text,
            spec: this,
            semanticsLabel: semanticLabel,
            locale: locale,
            duration: animated!.duration,
            curve: animated!.curve,
          )
        : TextSpecWidget(
            text,
            spec: this,
            semanticsLabel: semanticLabel,
            locale: locale,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
