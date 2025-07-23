import '../variants/variant_util.dart';
import 'box/box_attribute.dart';
import 'flex/flex_attribute.dart';
import 'flexbox/flexbox_spec.dart';
import 'icon/icon_attribute.dart';
import 'image/image_attribute.dart';
import 'stack/stack_attribute.dart';
import 'stack/stack_box_spec.dart';
import 'text/text_attribute.dart';

const _mixUtility = MixUtilities();

// Cached global instances
final _$box = BoxSpecAttribute();
final _$flex = FlexSpecAttribute();
final _$image = ImageSpecAttribute();
final _$icon = IconSpecAttribute();
final _$text = TextSpecAttribute();
final _$stack = StackSpecAttribute();

BoxSpecAttribute get $box => _$box;
FlexBoxSpecUtility get $flexbox => _mixUtility.flexbox;
FlexSpecAttribute get $flex => _$flex;
ImageSpecAttribute get $image => _$image;
IconSpecAttribute get $icon => _$icon;
TextSpecAttribute get $text => _$text;
StackSpecAttribute get $stack => _$stack;
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
