import '../core/modifier.dart';
import '../modifiers/widget_modifiers_util.dart';
import '../variants/context_variant_util/on_util.dart';
import 'box/box_spec.dart';
import 'flex/flex_spec.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_spec.dart';
import 'image/image_spec.dart';
import 'stack/stack_spec.dart';
import 'text/text_spec.dart';

const _mixUtility = MixUtilities();

@Deprecated('Use BoxStyle instead')
BoxSpecUtility<BoxSpecAttribute> get $box => _mixUtility.box;
FlexBoxSpecUtility<FlexBoxSpecAttribute> get $flexbox => _mixUtility.flexbox;
FlexSpecUtility<FlexSpecAttribute> get $flex => _mixUtility.flex;
ImageSpecUtility<ImageSpecAttribute> get $image => _mixUtility.image;
IconSpecUtility<IconSpecAttribute> get $icon => _mixUtility.icon;
TextSpecUtility<TextSpecAttribute> get $text => _mixUtility.text;
StackSpecUtility<StackSpecAttribute> get $stack => _mixUtility.stack;
OnContextVariantUtility get $on => _mixUtility.on;
WithModifierUtility<WidgetModifierSpecAttribute> get $with => _mixUtility.mod;

class MixUtilities {
  const MixUtilities();
  BoxSpecUtility<BoxSpecAttribute> get box => BoxSpecUtility.self;
  FlexSpecUtility<FlexSpecAttribute> get flex => FlexSpecUtility.self;
  FlexBoxSpecUtility<FlexBoxSpecAttribute> get flexbox =>
      FlexBoxSpecUtility.self;
  ImageSpecUtility<ImageSpecAttribute> get image => ImageSpecUtility.self;
  IconSpecUtility<IconSpecAttribute> get icon => IconSpecUtility.self;
  TextSpecUtility<TextSpecAttribute> get text => TextSpecUtility.self;
  StackSpecUtility<StackSpecAttribute> get stack => StackSpecUtility.self;
  OnContextVariantUtility get on => OnContextVariantUtility.self;
  WithModifierUtility<WidgetModifierSpecAttribute> get mod =>
      WithModifierUtility.self;
}
