import 'package:flutter/widgets.dart';

import '../core/element.dart';
import '../core/factory/style_mix.dart';
import '../core/variant.dart';
import 'variant_attribute.dart';

@immutable
abstract class ContextVariant extends IVariant {
  const ContextVariant();

  VariantAttribute call([
    StyleElement? p1,
    StyleElement? p2,
    StyleElement? p3,
    StyleElement? p4,
    StyleElement? p5,
    StyleElement? p6,
    StyleElement? p7,
    StyleElement? p8,
    StyleElement? p9,
    StyleElement? p10,
    StyleElement? p11,
    StyleElement? p12,
    StyleElement? p13,
    StyleElement? p14,
    StyleElement? p15,
    StyleElement? p16,
    StyleElement? p17,
    StyleElement? p18,
    StyleElement? p19,
    StyleElement? p20,
  ]) {
    final params = [
      p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, //
      p11, p12, p13, p14, p15, p16, p17, p18, p19, p20,
    ].whereType<StyleElement>();

    return VariantAttribute(this, Style.create(params));
  }

  @override
  VariantPriority get priority => VariantPriority.normal;

  @override
  Object get mergeKey => '$runtimeType';

  @override
  get props => [priority];
}

@immutable
abstract class MediaQueryContextVariant extends ContextVariant {
  @override
  final priority = VariantPriority.normal;

  const MediaQueryContextVariant();
}

@immutable
final class ContextVariantBuilder extends VariantAttribute<ContextVariant> {
  final Style Function(BuildContext context) fn;

  const ContextVariantBuilder(this.fn, ContextVariant variant)
      : super(variant, const Style.empty());

  Style Function(BuildContext context) mergeFn(
    Style Function(BuildContext context) other,
  ) {
    return (BuildContext context) => fn(context).merge(other(context));
  }

  @override
  ContextVariantBuilder merge(ContextVariantBuilder? other) {
    if (other == null) return this;
    if (other.variant != variant) {
      throw ArgumentError.value(other, 'variant is not the same');
    }

    return ContextVariantBuilder(mergeFn(other.fn), variant);
  }

  @override
  @protected
  Style get value => throw FlutterError.fromParts(
        [
          ErrorSummary(
            'Attempted to access value of ContextVariantBuilder directly.',
          ),
          ErrorDescription(
            'This is a ContextVariantBuilder and requires a BuildContext to resolve.',
          ),
          ErrorHint(
            'Use the build(context) method instead of accessing value directly.',
          ),
        ],
      );

  @override
  Object get mergeKey => '$runtimeType.${variant.mergeKey}';

  @override
  get props => [variant];

  Style build(BuildContext context) => fn(context);
}
