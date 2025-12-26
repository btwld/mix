/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

// Global utilities for $on and $wrap functionality are now available via spec-specific utilities:
// - BoxStyler().onHovered(), BoxStyler().wrap(...), etc.
// - TextStyler().onDark(), TextStyler().wrap(...), etc.
import 'box/box_mutable_style.dart';
import 'flex/flex_mutable_style.dart';
import 'flexbox/flexbox_mutable_style.dart';
import 'icon/icon_mutable_style.dart';
import 'image/image_mutable_style.dart';
import 'stack/stack_mutable_style.dart';
import 'stackbox/stackbox_mutable_style.dart';
import 'text/text_mutable_style.dart';

/// Global accessor for box specification utilities.
///
/// **Deprecated**: Use [BoxStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $box.color(Colors.red).size(100, 100);
///
/// // After (recommended):
/// final style = BoxStyler().color(Colors.red).size(100, 100);
/// ```
@Deprecated(
  'Use BoxStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
BoxMutableStyler get $box => BoxMutableStyler();

/// Global accessor for flex specification utilities.
///
/// **Deprecated**: Use [FlexStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $flex.direction(Axis.horizontal).spacing(8);
///
/// // After (recommended):
/// final style = FlexStyler().direction(Axis.horizontal).spacing(8);
/// ```
@Deprecated(
  'Use FlexStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
FlexMutableStyler get $flex => FlexMutableStyler();

/// Global accessor for flexbox specification utilities.
///
/// **Deprecated**: Use [FlexBoxStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $flexbox.color(Colors.red).spacing(8);
///
/// // After (recommended):
/// final style = FlexBoxStyler().color(Colors.red).spacing(8);
/// ```
@Deprecated(
  'Use FlexBoxStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
FlexBoxMutableStyler get $flexbox => FlexBoxMutableStyler();

/// Global accessor for image specification utilities.
///
/// **Deprecated**: Use [ImageStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $image.width(100).height(100).fit(BoxFit.cover);
///
/// // After (recommended):
/// final style = ImageStyler().width(100).height(100).fit(BoxFit.cover);
/// ```
@Deprecated(
  'Use ImageStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
ImageMutableStyler get $image => ImageMutableStyler();

/// Global accessor for icon specification utilities.
///
/// **Deprecated**: Use [IconStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $icon.size(24).color(Colors.blue);
///
/// // After (recommended):
/// final style = IconStyler().size(24).color(Colors.blue);
/// ```
@Deprecated(
  'Use IconStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
IconMutableStyler get $icon => IconMutableStyler();

/// Global accessor for text specification utilities.
///
/// **Deprecated**: Use [TextStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $text.fontSize(16).color(Colors.black);
///
/// // After (recommended):
/// final style = TextStyler().fontSize(16).color(Colors.black);
/// ```
@Deprecated(
  'Use TextStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
TextMutableStyler get $text => TextMutableStyler();

/// Global accessor for stack specification utilities.
///
/// **Deprecated**: Use [StackStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $stack.alignment(Alignment.center).fit(StackFit.expand);
///
/// // After (recommended):
/// final style = StackStyler().alignment(Alignment.center).fit(StackFit.expand);
/// ```
@Deprecated(
  'Use StackStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
StackMutableStyler get $stack => StackMutableStyler();

/// Global accessor for stackbox specification utilities.
///
/// **Deprecated**: Use [StackBoxStyler] directly instead.
///
/// ```dart
/// // Before (deprecated):
/// final style = $stackbox.color(Colors.red).alignment(Alignment.center);
///
/// // After (recommended):
/// final style = StackBoxStyler().color(Colors.red).alignment(Alignment.center);
/// ```
@Deprecated(
  'Use StackBoxStyler() directly instead. '
  'This accessor was deprecated after Mix v2.0.0.',
)
StackBoxMutableStyler get $stackbox => StackBoxMutableStyler();

// Global $on and $wrap utilities have been replaced by spec-specific utilities:
//
// Instead of: $on.hover($box.color.red(), $text.style.color.white())
// Use: BoxStyler().onHovered() and TextStyler().onHovered()
//
// This provides better type safety and eliminates the need for MultiSpec.
