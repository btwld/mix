import '../../core/mix_element.dart';
import 'box_spec.dart';

class BoxStyle extends SpecStyle<BoxSpec, BoxSpecAttribute> {
  const BoxStyle.raw({super.modifiers, super.variants, super.animation})
    : super(attribute: const BoxSpecAttribute.props());

  @override
  BoxStyle merge(BoxStyle? other) {
    if (other == null) return this;

    return BoxStyle();
  }

  @override
  Object get mergeKey => runtimeType;
}
