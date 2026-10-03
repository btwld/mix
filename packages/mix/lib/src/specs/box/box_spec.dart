import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

import '../pressable/pressable_widget.dart';
import '../text/text_spec.dart';
import 'box_widget.dart';

part 'box_spec.g.dart';

/// Specification for box styling and layout properties.
///
/// Provides comprehensive box styling including alignment, padding, margin, constraints,
/// decoration, transformation, and clipping behavior. Used as the resolved form
/// of [BoxStyle] styling attributes.
@MixableSpec(target: Box.new)
@immutable
final class BoxSpec with _$BoxSpec {
  /// Aligns the child within the box.
  @override
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the box.
  @override
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the box.
  @override
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  @override
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  @override
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  @override
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the box.
  @override
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  @override
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the box when content overflows.
  @override
  final Clip? clipBehavior;

  const BoxSpec({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
  });
}

/// Builds interactive boxes from a [BoxStyler].
extension BoxStylerPressable on BoxStyler {
  /// Creates a [PressableBox] using this style.
  ///
  /// Call this after composing the style; the result is a widget, while the
  /// original style remains reusable. All interaction options have the same
  /// behavior and defaults as [PressableBox].
  ///
  /// ```dart
  /// final button = BoxStyler()
  ///     .padding(.all(16))
  ///     .color(Colors.blue)
  ///     .onPressed(.color(Colors.indigo))
  ///     .pressable(
  ///       onPress: save,
  ///       semanticsLabel: 'Save',
  ///       child: const Text('Save'),
  ///     );
  /// ```
  PressableBox pressable({
    Key? key,
    required Widget child,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) => .new(
    key: key,
    style: this,
    onLongPress: onLongPress,
    focusNode: focusNode,
    autofocus: autofocus,
    enableFeedback: enableFeedback,
    onFocusChange: onFocusChange,
    onPress: onPress,
    mouseCursor: mouseCursor,
    canRequestFocus: canRequestFocus,
    excludeFromSemantics: excludeFromSemantics,
    semanticsLabel: semanticsLabel,
    semanticsRole: semanticsRole,
    onKeyEvent: onKeyEvent,
    controller: controller,
    actions: actions,
    hitTestBehavior: hitTestBehavior,
    enabled: enabled,
    child: child,
  );
}
