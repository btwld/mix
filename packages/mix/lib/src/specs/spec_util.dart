// import '../modifiers/widget_modifiers_util.dart';
import '../variants/variant_util.dart';
import 'box/box_spec.dart';
import 'flex/flex_spec.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_spec.dart';
import 'image/image_spec.dart';
import 'stack/stack_spec.dart';
import 'text/text_spec.dart';

const _mixUtility = MixUtilities();

BoxSpecUtility get $box => _mixUtility.box;
FlexBoxSpecUtility get $flexbox => _mixUtility.flexbox;
FlexSpecUtility get $flex => _mixUtility.flex;
ImageSpecUtility get $image => _mixUtility.image;
IconSpecUtility get $icon => _mixUtility.icon;
TextSpecUtility get $text => _mixUtility.text;
StackSpecUtility get $stack => _mixUtility.stack;
OnContextVariantUtility get $on => _mixUtility.on;
// WithModifierUtility<ModifierSpecAttribute> get $with => _mixUtility.mod;

class MixUtilities {
  const MixUtilities();
  BoxSpecUtility get box => BoxSpecUtility.self;
  FlexSpecUtility get flex => FlexSpecUtility.self;
  FlexBoxSpecUtility get flexbox => FlexBoxSpecUtility.self;
  ImageSpecUtility get image => ImageSpecUtility.self;
  IconSpecUtility get icon => IconSpecUtility.self;
  TextSpecUtility get text => TextSpecUtility.self;
  StackSpecUtility get stack => StackSpecUtility.self;
  OnContextVariantUtility get on => OnContextVariantUtility.self;
  // WithModifierUtility<ModifierSpecAttribute> get mod =>
  //     WithModifierUtility.self;
}
