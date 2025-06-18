import '../../variants/variant_attribute.dart';
import '../factory/style_mix.dart';
import '../spec.dart';
import '../variant.dart';

class StyleSheet<U extends SpecUtility> {
  final U Function() createUtility;
  final List<VariantAttribute> _variantList = [];

  StyleSheet(this.createUtility);

  Style call(void Function(U utility) styles) {
    final utility = createUtility();
    styles(utility);

    return Style.create([utility.attributeValue!, ..._variantList]);
  }

  void variant<V extends IVariant>(
    V variant,
    void Function(U utility) styles,
  ) {
    _variantList.add(
      VariantAttribute(
        variant,
        call((utility) {
          styles(utility);
        }),
      ),
    );
  }
}
