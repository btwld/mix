import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../theme/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import '../theme/tokens/token_refs.dart';
import 'converter_registry.dart';
import 'directive.dart';
import 'helpers.dart';
import 'mix_element.dart';
import 'prop_source.dart';

/// A property that can hold values, tokens, or Mix types.
///
/// [Prop] is the foundation of the Mix styling system. It provides:
/// - Storage for values through different source types
/// - Token resolution via [BuildContext]
/// - Merging capabilities with different strategies
/// - Directive application for value transformations
/// - Animation configuration support
///
/// This class serves as the base for both regular and Mix properties,
/// consolidating the previous PropBase hierarchy into a single implementation.
///
/// ## Value Creation
/// Use [Prop.value] for regular values - it creates a [ValueSource] without conversion.
/// Use [Prop.mix] for explicit Mix values - it creates a [MixSource].
///
/// ## Conversion Behavior
/// Type conversion to Mix types happens ONLY during resolution when Mix values
/// are present in the property. [Prop.value] never auto-converts values.
@immutable
class Prop<V> {
  /// The list of sources that provide values for this property.
  ///
  /// Sources can be [ValueSource], [TokenSource], or [MixSource].
  final List<PropSource<V>> sources;

  /// Optional directives to transform the resolved value.
  ///
  /// Directives are applied after resolution but before the value is returned.
  final List<Directive<V>>? $directives;

  // Constructors

  /// Creates a property with the given sources and directives.
  ///
  /// This constructor is private and used internally by factory methods.
  const Prop._({required this.sources, List<Directive<V>>? directives})
    : $directives = directives;

  /// Creates a new property by copying all fields from another property.
  ///
  /// Used by subclasses that need to wrap existing properties.
  Prop.fromProp(Prop<V> other)
    : sources = other.sources,
      $directives = other.$directives;

  /// Creates a property that references a token.
  ///
  /// The token will be resolved from [MixScope] during resolution.
  /// Optionally accepts [directives] configuration.
  factory Prop.token(MixToken<V> token, {List<Directive<V>>? directives}) {
    return Prop._(sources: [TokenSource(token)], directives: directives);
  }

  /// Creates a property with only directives.
  ///
  /// This property has no value source and is used for applying
  /// transformations when merged with other properties.
  const Prop.directives(List<Directive<V>> directives)
    : this._(sources: const [], directives: directives);

  // Factory methods

  /// Creates a property from a direct value.
  ///
  /// If [value] is already a [Prop], returns it unchanged.
  /// Otherwise, checks if it's a token reference and handles accordingly.
  ///
  /// This method does NOT auto-convert values to Mix types.
  /// Use [Prop.mix] for explicit Mix values.
  static Prop<V> value<V>(V value) {
    // If it's already a Prop, return unchanged
    if (value is Prop<V>) return value;

    // Check if this is a token reference (DoubleRef, IntRef, StringRef)
    // Only for primitive extension types, not for class-based Props
    if (isAnyTokenRef(value as Object)) {
      final token = getTokenFromValue(value as Object) as MixToken<V>?;
      if (token != null) {
        // This is a token reference - store as TokenSource
        return Prop._(sources: [TokenSource(token)]);
      }
    }

    // Regular value - store as ValueSource
    return Prop._(sources: [ValueSource(value)]);
  }

  /// Creates a property from a [Mix] value.
  ///
  /// Use this when you explicitly want to store a Mix value
  /// for accumulation merging behavior.
  static Prop<V> mix<V>(Mix<V> mix) {
    return Prop._(sources: [MixSource(mix)]);
  }

  /// Creates a property from a nullable value.
  ///
  /// Returns `null` if [value] is `null`, otherwise calls [Prop.value].
  static Prop<V>? maybe<V>(V? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  /// Creates a property from a nullable [Mix] value.
  ///
  /// Returns `null` if [value] is `null`, otherwise calls [Prop.mix].
  static Prop<V>? maybeMix<V>(Mix<V>? value) {
    if (value == null) return null;

    return Prop.mix(value);
  }

  /// Creates a property from a regular value by converting it to a Mix.
  ///
  /// Uses the converter registry to transform the value into a Mix type,
  /// then wraps it in a Prop. Returns null if conversion is not possible.
  static Prop<V>? mixValue<V>(V value) {
    final converted = MixConverterRegistry.instance.tryConvert<V>(value);
    if (converted == null) return null;

    return Prop.mix(converted);
  }

  // Properties

  /// The runtime type of the property's value.
  Type get type => V;

  /// Whether this property contains at least one value source.
  ///
  /// Returns `true` if the property has [ValueSource] or [MixSource].
  bool get hasValue =>
      sources.any((s) => s is ValueSource<V> || s is MixSource<V>);

  /// Whether this property contains at least one token source.
  ///
  /// Returns `true` if the property has [TokenSource].
  bool get hasToken => sources.any((s) => s is TokenSource<V>);

  // Methods

  /// Returns a new property with the given directives merged with existing ones.
  Prop<V> directives(List<Directive<V>> directives) {
    return mergeProp(Prop.directives(directives));
  }

  /// Merges this property with another property.
  ///
  /// Always accumulates all sources from both properties.
  /// During resolution, the behavior depends on the source types:
  /// - Mix sources: merged using accumulation strategy
  /// - Regular values: last value wins during resolution
  ///
  /// Directives are merged from both properties.
  Prop<V> mergeProp(covariant Prop<V>? other) {
    if (other == null) return this;

    // Always accumulate all sources - no conditional logic
    return Prop._(
      sources: [...sources, ...other.sources],
      directives: PropOps.mergeDirectives($directives, other.$directives),
    );
  }

  /// Resolves this property to a concrete value using the given context.
  ///
  /// Resolution process:
  /// 1. Resolves all sources (tokens from context, Mix values, etc.)
  /// 2. Converts regular values to Mix when Mix values are present
  /// 3. Merges multiple values based on type (accumulation for Mix, replacement for others)
  /// 4. Applies any directives to transform the final value
  ///
  /// Throws [FlutterError] if the property has no sources.
  V resolveProp(BuildContext context) {
    if (sources.isEmpty) {
      throw FlutterError('Prop<$V> has no sources');
    }

    // Resolve all sources to values
    final values = [];
    for (final source in sources) {
      final value = switch (source) {
        ValueSource<V>(:final value) => value,
        TokenSource<V>(:final token) => MixScope.tokenOf(token, context),
        MixSource<V>(:final mix) => mix,
      };
      values.add(value);
    }

    // Check if we have Mix values
    final hasMixValues = values.any((v) => v is Mix<V>);

    V resolvedValue;
    if (hasMixValues) {
      // Need to merge as Mix types
      final mixValues = <Mix<V>>[];

      for (final value in values) {
        if (value is Mix<V>) {
          mixValues.add(value);
        } else if (value is V) {
          // Try to convert regular value to Mix
          final converted = MixConverterRegistry.instance.tryConvert<V>(value);
          if (converted != null) {
            mixValues.add(converted);
          } else {
            // Debug-only diagnostic to surface silent conversion failures
            assert(() {
              debugPrint(
                'Mix: could not convert value of type ${value.runtimeType} '
                'to Mix<$V>. Register a MixConverter for <$V> or pass a Mix via Prop.mix.',
              );

              return true;
            }());
          }
        }
      }

      // Invariant check: when hasMixValues is true, we expect at least one Mix collected
      assert(
        mixValues.isNotEmpty,
        'Mix: invariant violated in Prop<$V>.resolveProp - hasMixValues was true, but no Mix values were collected from sources. Falling back to last value.',
      );

      if (mixValues.isEmpty) {
        // Release-safe fallback to maintain stability
        resolvedValue = values.last as V;
      } else {
        // Merge all Mix values
        Mix<V> mergedMix = mixValues.first;
        for (int i = 1; i < mixValues.length; i++) {
          mergedMix = PropOps.mergeMixes(context, mergedMix, mixValues[i]);
        }
        resolvedValue = mergedMix.resolve(context);
      }
    } else {
      // Simple values - use last one (replacement strategy)
      resolvedValue = values.last as V;
    }

    // Apply directives
    return PropOps.applyDirectives(resolvedValue, $directives);
  }

  // Equality and debugging

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prop<V> &&
        listEquals(other.sources, sources) &&
        listEquals(other.$directives, $directives);
  }

  @override
  String toString() {
    final parts = <String>[];
    if (sources.isNotEmpty) {
      parts.add('sources: ${sources.length}');
    }
    if ($directives != null && $directives!.isNotEmpty) {
      parts.add('directives: ${$directives!.length}');
    }

    return '$runtimeType(${parts.join(', ')})';
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(sources), $directives);
}
