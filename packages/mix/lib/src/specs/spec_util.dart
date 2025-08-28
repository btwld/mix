/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

// Global utilities for $on and $wrap functionality are now available via spec-specific utilities:
// - $box.on.hover(), $box.wrap.opacity(), etc.
// - $text.on.dark(), $text.wrap.padding(), etc.
import 'box/box_util.dart';
import 'flex/flex_util.dart';
import 'flexbox/flexbox_util.dart';
import 'icon/icon_util.dart';
import 'image/image_util.dart';
import 'stack/stack_util.dart';
import 'text/text_util.dart';

/// Global accessor for box specification utilities.
BoxSpecUtility get $box => BoxSpecUtility();

/// Global accessor for flex specification utilities.
FlexSpecUtility get $flex => FlexSpecUtility();

/// Global accessor for flexbox specification utilities.
FlexBoxSpecUtility get $flexbox => FlexBoxSpecUtility();

/// Global accessor for image specification utilities.
ImageSpecUtility get $image => ImageSpecUtility();

/// Global accessor for icon specification utilities.
IconSpecUtility get $icon => IconSpecUtility();

/// Global accessor for text specification utilities.
TextSpecUtility get $text => TextSpecUtility();

/// Global accessor for stack specification utilities.
StackSpecUtility get $stack => StackSpecUtility();

// Global $on and $wrap utilities have been replaced by spec-specific utilities:
//
// Instead of: $on.hover($box.color.red(), $text.style.color.white())
// Use: $box.on.hover($box.color.red()) and $text.on.hover($text.style.color.white())
//
// This provides better type safety and eliminates the need for MultiSpec.
