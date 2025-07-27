/// Utility exports for Mix specification system.
///
/// This file provides convenient global accessors for commonly used spec attributes,
/// utilities, and modifiers in the Mix framework.
library;

import '../core/spec.dart';
import '../core/style.dart';
import '../modifiers/modifier_util.dart';
import '../core/variant/variant_util.dart';
import 'box/box_attribute.dart';
import 'flex/flex_attribute.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_attribute.dart';
import 'image/image_attribute.dart';
import 'stack/stack_attribute.dart';
import 'text/text_attribute.dart';

/// Global accessor for box specification attributes.
BoxSpecAttribute get $box => BoxSpecAttribute();

/// Global accessor for flex specification attributes.
FlexSpecAttribute get $flex => FlexSpecAttribute();

/// Global accessor for flexbox specification utilities.
FlexBoxSpecUtility get $flexbox => FlexBoxSpecUtility.self;

/// Global accessor for image specification attributes.
ImageSpecAttribute get $image => ImageSpecAttribute();

/// Global accessor for icon specification attributes.
IconSpecAttribute get $icon => IconSpecAttribute();

/// Global accessor for text specification attributes.
TextSpecAttribute get $text => TextSpecAttribute();

/// Global accessor for stack specification attributes.
StackSpecAttribute get $stack => StackSpecAttribute();

/// Global accessor for context variant utilities.
OnContextVariantUtility get $on =>
    OnContextVariantUtility<MultiSpec, Style>((v) => Style(v));

/// Global accessor for modifier utilities.
ModifierUtility get $wrap => ModifierUtility((v) => Style(v));
