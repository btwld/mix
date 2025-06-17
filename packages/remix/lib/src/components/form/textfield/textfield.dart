import 'dart:ui';

import 'package:flutter/cupertino.dart'
    show
        CupertinoColors,
        cupertinoDesktopTextSelectionHandleControls,
        cupertinoTextSelectionHandleControls;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/component_builder.dart';
import '../../../helpers/spec_style.dart';
import 'attributes/attributes.dart';

part 'textfield.g.dart';
part 'textfield_style.dart';
part 'textfield_widget.dart';

@MixableSpec()
class TextFieldSpec extends Spec<TextFieldSpec>
    with _$TextFieldSpec, Diagnosticable {
  final TextStyle style;
  final TextAlign textAlign;

  final bool floatingLabel;

  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;

  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color cursorColor;
  final Offset cursorOffset;
  final bool paintCursorAboveText;
  final bool cursorOpacityAnimates;
  final Color backgroundCursorColor;
  final Color? selectionColor;

  @MixableField(
    utilities: [MixableFieldUtility(type: BoxHeightStyleUtility)],
  )
  final BoxHeightStyle selectionHeightStyle;

  @MixableField(
    utilities: [MixableFieldUtility(type: BoxWidthStyleUtility)],
  )
  final BoxWidthStyle selectionWidthStyle;

  final EdgeInsets scrollPadding;
  final Clip clipBehavior;

  @MixableField(utilities: [MixableFieldUtility(type: Brightness)])
  final Brightness keyboardAppearance;
  final Color? autocorrectionTextRectColor;
  final FlexBoxSpec outerContainer;
  final FlexBoxSpec container;
  final TextStyle? hintTextStyle;
  final TextSpec helperText;
  final IconSpec icon;
  final double floatingLabelHeight;
  final TextStyle? floatingLabelStyle;

  @MixableField(dto: MixableFieldType(type: TextHeightBehaviorDto))
  final TextHeightBehavior? textHeightBehavior;

  static const of = _$TextFieldSpec.of;

  static const from = _$TextFieldSpec.from;

  const TextFieldSpec({
    TextStyle? style,
    TextAlign? textAlign,
    this.strutStyle,
    this.textHeightBehavior,
    TextWidthBasis? textWidthBasis,
    double? cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    bool? paintCursorAboveText,
    Color? backgroundCursorColor,
    this.selectionColor,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Clip? clipBehavior,
    Brightness? keyboardAppearance,
    this.autocorrectionTextRectColor,
    bool? cursorOpacityAnimates,
    FlexBoxSpec? outerContainer,
    FlexBoxSpec? container,
    this.hintTextStyle,
    TextSpec? helperText,
    IconSpec? icon,
    bool? floatingLabel,
    double? floatingLabelHeight,
    this.floatingLabelStyle,
    super.animated,
    super.modifiers,
  })  : style = style ?? const TextStyle(),
        textAlign = textAlign ?? TextAlign.start,
        textWidthBasis = textWidthBasis ?? TextWidthBasis.parent,
        cursorWidth = cursorWidth ?? 2.0,
        cursorColor = cursorColor ?? m.Colors.black54,
        cursorOffset = cursorOffset ?? Offset.zero,
        paintCursorAboveText = paintCursorAboveText ?? false,
        cursorOpacityAnimates = cursorOpacityAnimates ?? false,
        backgroundCursorColor =
            backgroundCursorColor ?? CupertinoColors.inactiveGray,
        selectionHeightStyle = selectionHeightStyle ?? BoxHeightStyle.tight,
        selectionWidthStyle = selectionWidthStyle ?? BoxWidthStyle.tight,
        scrollPadding = scrollPadding ?? const EdgeInsets.all(20.0),
        clipBehavior = clipBehavior ?? Clip.hardEdge,
        keyboardAppearance = keyboardAppearance ?? Brightness.light,
        outerContainer = outerContainer ?? const FlexBoxSpec(),
        helperText = helperText ?? const TextSpec(),
        container = container ?? const FlexBoxSpec(),
        icon = icon ?? const IconSpec(),
        floatingLabel = floatingLabel ?? false,
        floatingLabelHeight = floatingLabelHeight ?? 14;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
