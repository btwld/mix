import '../core/spec.dart';
import '../core/style.dart';
import '../modifiers/modifier_util.dart';
import '../variants/variant_util.dart';
import 'box/box_attribute.dart';
import 'flex/flex_attribute.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_attribute.dart';
import 'image/image_attribute.dart';
import 'stack/stack_attribute.dart';
import 'text/text_attribute.dart';

BoxSpecAttribute get $box => BoxSpecAttribute();
FlexSpecAttribute get $flex => FlexSpecAttribute();
FlexBoxSpecUtility get $flexbox => FlexBoxSpecUtility.self;
ImageSpecAttribute get $image => ImageSpecAttribute();
IconSpecAttribute get $icon => IconSpecAttribute();
TextSpecAttribute get $text => TextSpecAttribute();
StackSpecAttribute get $stack => StackSpecAttribute();
OnContextVariantUtility get $on =>
    OnContextVariantUtility<MultiSpec, Style>((v) => Style(v));
ModifierUtility get $wrap => ModifierUtility((v) => Style(v));
