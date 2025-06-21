import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../helpers/mix_controller_mixin.dart';

import '../../../helpers/remix_builder.dart';
import 'attributes/attributes.dart';

part 'textfield.g.dart';
part 'textfield_style.dart';
part 'textfield_widget.dart';

@MixableSpec()
class TextFieldSpec extends Spec<TextFieldSpec>
    with _$TextFieldSpec, Diagnosticable {
  final TextStyle style;
  final Color? hintTextColor;
  final TextAlign textAlign;

  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Offset cursorOffset;
  final bool? cursorOpacityAnimates;

  @MixableField(
    utilities: [MixableFieldUtility(type: BoxHeightStyleUtility)],
  )
  final BoxHeightStyle selectionHeightStyle;

  @MixableField(
    utilities: [MixableFieldUtility(type: BoxWidthStyleUtility)],
  )
  final BoxWidthStyle selectionWidthStyle;

  final EdgeInsets scrollPadding;

  @MixableField(utilities: [MixableFieldUtility(type: Brightness)])
  final Brightness? keyboardAppearance;
  final double spacing;
  final FlexBoxSpec container;
  final TextSpec helperText;

  static const of = _$TextFieldSpec.of;

  static const from = _$TextFieldSpec.from;

  const TextFieldSpec({
    TextStyle? style,
    this.hintTextColor,
    TextAlign? textAlign,
    double? cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    this.keyboardAppearance,
    this.cursorOpacityAnimates,
    double? spacing,
    FlexBoxSpec? container,
    TextSpec? helperText,
    super.animated,
    super.modifiers,
  })  : style = style ?? const TextStyle(),
        textAlign = textAlign ?? TextAlign.start,
        cursorWidth = cursorWidth ?? 2.0,
        cursorOffset = cursorOffset ?? Offset.zero,
        selectionHeightStyle = selectionHeightStyle ?? BoxHeightStyle.tight,
        selectionWidthStyle = selectionWidthStyle ?? BoxWidthStyle.tight,
        scrollPadding = scrollPadding ?? const EdgeInsets.all(20.0),
        helperText = helperText ?? const TextSpec(),
        container = container ?? const FlexBoxSpec(),
        spacing = spacing ?? 4;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
