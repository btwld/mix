/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

// These imports were for $on and $wrap utilities which are temporarily disabled
// import '../core/spec.dart';
// import '../core/style.dart';
// import '../modifiers/modifier_util.dart';
// import '../variants/variant_util.dart';
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

// TODO: These global utilities need to be reimplemented after removing MultiSpec/CompoundStyle
// The $on and $wrap utilities previously worked with MultiSpec but now need a different approach
// since we work with specific spec types (BoxSpec, TextSpec, etc.)
//
// Potential solutions:
// 1. Create spec-specific variants like $boxOn, $textOn, etc.
// 2. Use a different pattern that doesn't require a generic spec type
// 3. Restore a limited version of MultiSpec for these utilities only
//
// For now, these are commented out to fix compilation errors:
// OnContextVariantUtility get $on => ...
// ModifierUtility get $wrap => ...
