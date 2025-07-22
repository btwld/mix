import '../variants/variant_util.dart';
import 'box/box_attribute.dart';
import 'flex/flex_attribute.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_spec.dart';
import 'image/image_attribute.dart';
import 'stack/stack_attribute.dart';
import 'stack/stack_box_spec.dart';
import 'text/text_attribute.dart';

const _mixUtility = MixUtilities();

BoxSpecAttribute get $box => _mixUtility.box;
FlexBoxSpecUtility get $flexbox => _mixUtility.flexbox;
FlexSpecAttribute get $flex => _mixUtility.flex;
ImageSpecAttribute get $image => _mixUtility.image;
IconSpecAttribute get $icon => _mixUtility.icon;
TextSpecAttribute get $text => _mixUtility.text;
StackSpecAttribute get $stack => _mixUtility.stack;
StackBoxSpecAttribute get $stackBox =>
    StackBoxSpecAttribute(); // For compatibility with old code
OnContextVariantUtility get $onContext => _mixUtility.on;
OnContextVariantUtility get $on => _mixUtility.on;

class MixUtilities {
  const MixUtilities();
  BoxSpecAttribute get box => BoxSpecAttribute();
  FlexSpecAttribute get flex => FlexSpecAttribute();
  FlexBoxSpecUtility get flexbox => FlexBoxSpecUtility.self;
  ImageSpecAttribute get image => ImageSpecAttribute();
  IconSpecAttribute get icon => IconSpecAttribute();
  TextSpecAttribute get text => TextSpecAttribute();
  StackSpecAttribute get stack => StackSpecAttribute();
  OnContextVariantUtility get on => OnContextVariantUtility.self;
}
