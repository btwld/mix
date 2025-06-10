// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/text_height_behavior/text_height_behavior_dto.dart';
import '../attributes/text_style/text_style_dto.dart';
import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'default_text_style_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class DefaultTextStyleModifierSpec
    extends WidgetModifierSpec<DefaultTextStyleModifierSpec>
    with _$DefaultTextStyleModifierSpec, Diagnosticable {
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleModifierSpec({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return DefaultTextStyle(
      style: style ?? const TextStyle(),
      textAlign: textAlign,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      child: child,
    );
  }
}

final class DefaultTextStyleModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, DefaultTextStyleModifierSpecAttribute> {
  const DefaultTextStyleModifierSpecUtility(super.builder);
  T call({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return builder(
      DefaultTextStyleModifierSpecAttribute(
        style: style?.toDto(),
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior?.toDto(),
      ),
    );
  }
}
