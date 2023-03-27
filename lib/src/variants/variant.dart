import '../attributes/attribute.dart';
import '../mixer/mix_factory.dart';
import 'variant_attribute.dart';
import 'variant_operation.dart';

/// {@category Variants}
/// A class representing a variant, which is a combination of attributes.
/// It can be combined with other variants using logical AND (&) and OR (|) operations.
class Variant {
  final String name;

  /// Creates a new [Variant] with a given [name] and an optional [inverse] flag.
  const Variant(this.name);

  /// Combines this variant with another [variant] using a logical AND operation.
  VariantOperation operator &(Variant variant) {
    return VariantOperation([this, variant], operator: EnumVariantOperator.and);
  }

  /// Combines this variant with another [variant] using a logical OR operation.
  VariantOperation operator |(Variant variant) {
    return VariantOperation([this, variant], operator: EnumVariantOperator.or);
  }

  /// Applies the variant to a set of attributes and creates a [VariantAttribute] instance.
  /// Up to 12 optional [Attribute] parameters can be provided.
  // ignore: long-parameter-list
  VariantAttribute call([
    Attribute? p1,
    Attribute? p2,
    Attribute? p3,
    Attribute? p4,
    Attribute? p5,
    Attribute? p6,
    Attribute? p7,
    Attribute? p8,
    Attribute? p9,
    Attribute? p10,
    Attribute? p11,
    Attribute? p12,
  ]) {
    final params = <Attribute>[];

    for (final param in [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12]) {
      if (param != null) params.add(param);
    }

    // Create a VariantAttribute using the collected parameters
    return VariantAttribute(this, Mix.fromAttributes(params));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Variant && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'name: $name';
}
