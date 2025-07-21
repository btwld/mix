// import '../modifiers/widget_modifiers_util.dart';
import '../variants/variant_util.dart';
import 'box/box_spec.dart';
import 'flex/flex_attribute.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_spec.dart';
import 'image/image_attribute.dart';
import 'stack/stack_attribute.dart';
import 'text/text_attribute.dart';

const _mixUtility = MixUtilities();

BoxSpecUtility get $box => _mixUtility.box;
FlexBoxSpecUtility get $flexbox => _mixUtility.flexbox;
FlexSpecUtility get $flex => _mixUtility.flex;
ImageSpecAttribute get $image => _mixUtility.image;
IconSpecUtility get $icon => _mixUtility.icon;
TextSpecAttribute get $text => _mixUtility.text;
StackSpecAttribute get $stack => _mixUtility.stack;
OnContextVariantUtility get $on => _mixUtility.on;
// WithModifierUtility<ModifierAttribute> get $with => _mixUtility.mod;

class MixUtilities {
  const MixUtilities();
  BoxSpecUtility get box => BoxSpecAttribute();
  FlexSpecUtility get flex => FlexSpecAttribute();
  FlexBoxSpecUtility get flexbox => FlexBoxSpecUtility.self;
  ImageSpecAttribute get image => ImageSpecAttribute();
  IconSpecUtility get icon => IconSpecUtility.self;
  TextSpecAttribute get text => TextSpecAttribute();
  StackSpecAttribute get stack => StackSpecAttribute();
  OnContextVariantUtility get on => OnContextVariantUtility.self;
  // WithModifierUtility<ModifierAttribute> get mod =>
  //     WithModifierUtility.self;
}
