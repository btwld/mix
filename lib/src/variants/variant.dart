import '../attributes/attribute.dart';
import '../factory/style_mix.dart';
import 'variant_attribute.dart';
import 'variant_operation.dart';

@Deprecated(
  'Use StyleVariant instead. '
  'This class will be removed in a future release.',
)
typedef Variant = StyleVariant;

/// A class representing a variant, which is a combination of attributes.
/// It can be combined with other variants using logical AND (&) and OR (|) operations.
class StyleVariant {
  final String name;

  /// Creates a new [StyleVariant] with a given [name] and an optional [inverse] flag.
  const StyleVariant(this.name);

  @override
  int get hashCode => name.hashCode;

  /// Combines this variant with another [variant] using a logical AND operation.
  VariantOperation operator &(StyleVariant variant) {
    return VariantOperation([this, variant], operator: EnumVariantOperator.and);
  }

  /// Combines this variant with another [variant] using a logical OR operation.
  VariantOperation operator |(StyleVariant variant) {
    return VariantOperation([this, variant], operator: EnumVariantOperator.or);
  }

  /// Applies the variant to a set of attributes and creates a [VariantAttribute] instance.
  /// Up to 12 optional [StyleAttribute] parameters can be provided.
  // ignore: long-parameter-list

  VariantAttribute call([
    StyleAttribute? p1,
    StyleAttribute? p2,
    StyleAttribute? p3,
    StyleAttribute? p4,
    StyleAttribute? p5,
    StyleAttribute? p6,
    StyleAttribute? p7,
    StyleAttribute? p8,
    StyleAttribute? p9,
    StyleAttribute? p10,
    StyleAttribute? p11,
    StyleAttribute? p12,
  ]) {
    final params = <StyleAttribute>[];

    for (final param in [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12]) {
      if (param != null) params.add(param);
    }

    // Create a VariantAttribute using the collected parameters.
    return VariantAttribute(this, StyleMix.fromAttributes(params));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StyleVariant && other.name == name;
  }

  @override
  String toString() => 'name: $name';
}
