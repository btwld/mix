// ignore_for_file: avoid-dynamic

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/animated/animated_data.dart';
import '../../internal/iterable_ext.dart';
import '../../internal/string_ext.dart';
import '../../theme/tokens/token_resolver.dart';
import '../../variants/context_variant.dart';
import '../../variants/variant_attribute.dart';
import '../attributes_map.dart';
import '../modifier.dart';
import '../spec.dart';
import 'style_mix.dart';

@Deprecated('Use MixContext instead. This will be removed in version 2.0')
typedef MixData = MixContext;

// MixContext would be a more accurate name as this class provides the contextual
// environment for attribute resolution (tokens, context, animation state) rather than
// being a simple data container. The "Context" naming would also enable more fluid
// refresh and update patterns, making the relationship with BuildContext clearer.

/// Context for resolving [SpecAttribute]s into concrete values.
///
/// Encapsulates the build context, token resolver, and attribute collection
/// needed for style resolution. Acts as the contextual environment during
/// the style computation process.
@immutable
class MixContext with Diagnosticable {
  final AnimatedData? animation;

  // Instance variables for widget attributes, widget modifiers and token resolver.
  final AttributeMap _attributes;

  final MixTokenResolver _tokenResolver;

  /// Creates a [MixContext] instance with the given parameters.
  const MixContext._({
    required MixTokenResolver resolver,
    required AttributeMap attributes,
    required this.animation,
  })  : _attributes = attributes,
        _tokenResolver = resolver;

  factory MixContext.create(BuildContext context, Style style) {
    final attributeList = applyContextToVisualAttributes(context, style);

    final resolver = MixTokenResolver(context);

    return MixContext._(
      resolver: resolver,
      attributes: AttributeMap(attributeList),
      animation: style is AnimatedStyle ? style.animated : null,
    );
  }

  /// Whether this style data includes animation configuration.
  bool get isAnimated => animation != null;

  /// Token resolver for resolving design tokens in this context.
  MixTokenResolver get tokens => _tokenResolver;

  /// Attribute collection for testing purposes.
  @visibleForTesting
  AttributeMap get attributes => _attributes;

  List<WidgetModifierSpec<dynamic>> get modifiers {
    return _attributes
        .whereType<WidgetModifierSpecAttribute>()
        .map((e) => e.resolve(this))
        .toList();
  }

  MixContext toInheritable() {
    final inheritableAttributes = _attributes.values.where(
      (attr) => attr is! WidgetModifierSpecAttribute,
    );

    return copyWith(attributes: AttributeMap(inheritableAttributes));
  }

  /// Returns the resolved attribute of type [A], or null if not found.
  A? attributeOf<A extends SpecAttribute>() {
    final attributes = _attributes.whereType<A>();
    if (attributes.isEmpty) return null;

    return _mergeAttributes(attributes) ?? attributes.last;
  }

  @Deprecated(
    'Use ComputedStyle.of(context).modifiers.whereType<M>() instead. '
    'Prefer ComputedStyle for optimized access with surgical rebuilds. Will be removed in v2.0.0.\n'
    'Migration:\n'
    '// Before\n'
    'final scaleModifiers = mixData.modifiersOf<TransformModifierSpec>();\n'
    '// After\n'
    'final scaleModifiers = ComputedStyle.of(context).modifiers.whereType<TransformModifierSpec>().toList();',
  )
  List<WidgetModifierSpec<dynamic>>
      modifiersOf<M extends WidgetModifierSpec<dynamic>>() {
    return modifiers.whereType<M>().toList();
  }

  Iterable<A> whereType<A extends SpecAttribute>() {
    return _attributes.whereType();
  }

  @Deprecated(
    'Use whereType<T>().isNotEmpty or attributeOf<T>() != null instead. '
    'This method provides unclear semantics and will be removed in v2.0.0.\n'
    'Migration:\n'
    '// Before\n'
    'if (mixData.contains<BoxSpecAttribute>()) { ... }\n'
    '// After\n'
    'if (mixData.attributeOf<BoxSpecAttribute>() != null) { ... }',
  )
  bool contains<T>() {
    return _attributes.values.any((attr) => attr is T);
  }

  @Deprecated(
    'Use ComputedStyle.specOf<T>(context) for pre-resolved specs instead. '
    'Prefer accessing resolved values through ComputedStyle for optimized performance. Will be removed in v2.0.0.\n'
    'Migration:\n'
    '// Before\n'
    'final color = mixData.resolvableOf<Color, ColorUtilityAttribute>();\n'
    '// After\n'
    'final boxSpec = ComputedStyle.specOf<BoxSpec>(context);\n'
    'final color = boxSpec?.decoration?.color; // Access resolved values from specs',
  )
  Value? resolvableOf<Value, A extends SpecAttribute<Value>>() {
    final attribute = _attributes.attributeOfType<A>();

    return attribute?.resolve(this);
  }

  // /// Merges this [MixData] with another, prioritizing this instance's properties.
  MixContext merge(MixContext other) {
    return MixContext._(
      resolver: other._tokenResolver,
      attributes: _attributes.merge(other._attributes),
      animation: other.animation ?? animation,
    );
  }

  MixContext copyWith({
    AttributeMap? attributes,
    AnimatedData? animation,
    MixTokenResolver? resolver,
  }) {
    return MixContext._(
      resolver: resolver ?? _tokenResolver,
      attributes: attributes ?? _attributes,
      animation: animation ?? this.animation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixContext &&
        other._attributes == _attributes &&
        other.animation == animation;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    for (var attr in attributes.values) {
      properties.add(
        DiagnosticsProperty(
          attr.runtimeType.toString().camelCase,
          attr,
          description: attr.runtimeType.toString().camelCase,
          expandableValue: true,
        ),
      );
    }
  }

  @override
  int get hashCode => _attributes.hashCode ^ animation.hashCode;
}

@visibleForTesting
List<SpecAttribute> applyContextToVisualAttributes(
  BuildContext context,
  Style mix,
) {
  if (mix.variants.isEmpty) {
    return mix.styles.values;
  }

  final prioritizedVariants = mix.variants.values.sorted(
    (a, b) => a.priority.value.compareTo(b.priority.value),
  );

  Style style = Style.create(mix.styles.values);

  for (final variant in prioritizedVariants) {
    style = _applyVariants(context, style, variant);
  }

  return applyContextToVisualAttributes(context, style);
}

Style _applyVariants(
  BuildContext context,
  Style style,
  VariantAttribute variantAttribute,
) {
  if (variantAttribute is ContextVariantBuilder &&
      variantAttribute.variant.when(context)) {
    return style.merge(variantAttribute.build(context));
  }

  return variantAttribute.variant.when(context)
      ? style.merge(variantAttribute.value)
      : style;
}

M? _mergeAttributes<M extends SpecAttribute>(Iterable<M> mergeables) {
  if (mergeables.isEmpty) return null;

  return mergeables.reduce((a, b) {
    return a.merge(b) as M;
  });
}
