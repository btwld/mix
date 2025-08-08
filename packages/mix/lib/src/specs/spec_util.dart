/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

import '../core/spec.dart';
import '../core/style.dart';
import '../modifiers/modifier_util.dart';
import '../variants/variant_util.dart';
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

/// Global accessor for context variant utilities.
OnContextVariantUtility get $on =>
    OnContextVariantUtility<MultiSpec, CompoundStyle>(
      (v) => CompoundStyle.create([v]),
    );

/// Global accessor for modifier utilities.
WidgetModifierUtility get $wrap =>
    WidgetModifierUtility((v) => CompoundStyle.create([v]));
