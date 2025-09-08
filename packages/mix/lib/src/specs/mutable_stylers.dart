/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

// Global utilities for $on and $wrap functionality are now available via spec-specific utilities:
// - $box.on.hover(), $box.wrap.opacity(), etc.
// - $text.on.dark(), $text.wrap.padding(), etc.
import 'box/box_mutable_style.dart';
import 'flex/flex_mutable_style.dart';
import 'flexbox/flexbox_mutable_style.dart';
import 'icon/icon_mutable_style.dart';
import 'image/image_mutable_style.dart';
import 'stack/stack_mutable_style.dart';
import 'text/text_mutable_style.dart';

/// Global accessor for box specification utilities.
BoxMutableStyler get $box => BoxMutableStyler();

/// Global accessor for flex specification utilities.
FlexMutableStyler get $flex => FlexMutableStyler();

/// Global accessor for flexbox specification utilities.
FlexBoxMutableStyler get $flexbox => FlexBoxMutableStyler();

/// Global accessor for image specification utilities.
ImageMutableStyler get $image => ImageMutableStyler();

/// Global accessor for icon specification utilities.
IconMutableStyler get $icon => IconMutableStyler();

/// Global accessor for text specification utilities.
TextMutableStyler get $text => TextMutableStyler();

/// Global accessor for stack specification utilities.
StackMutableStyler get $stack => StackMutableStyler();

// Global $on and $wrap utilities have been replaced by spec-specific utilities:
//
// Instead of: $on.hover($box.color.red(), $text.style.color.white())
// Use: $box.on.hover($box.color.red()) and $text.on.hover($text.style.color.white())
//
// This provides better type safety and eliminates the need for MultiSpec.