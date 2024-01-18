import '../variants/variant.dart';

abstract class StyleRecipe<T extends StyleRecipe<T>> {
  const StyleRecipe();

  StyleRecipe<T> merge(covariant StyleRecipe<T>? other);

  StyleRecipe<T> selectVariants(List<Variant> variants);

  StyleRecipe<T> copyWith();
}
