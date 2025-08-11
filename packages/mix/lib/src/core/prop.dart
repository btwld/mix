import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../animation/animation_config.dart';
import '../theme/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
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
  /// Sources can be [ValueSource], [TokenSource], [MixSource], or [MixTokenSource].
  final List<PropSource<V>> sources;

  /// Optional directives to transform the resolved value.
  ///
  /// Directives are applied after resolution but before the value is returned.
  final List<Directive<V>>? $directives;

  /// Optional animation configuration for animating property changes.
  final AnimationConfig? $animation;

  // Constructors

  /// Creates a property with the given sources, directives, and animation.
  ///
  /// This constructor is private and used internally by factory methods.
  const Prop._({
    required this.sources,
    List<Directive<V>>? directives,
    AnimationConfig? animation,
  }) : $directives = directives,
       $animation = animation;

  /// Creates a new property by copying all fields from another property.
  ///
  /// Used by subclasses that need to wrap existing properties.
  Prop.fromProp(Prop<V> other)
    : sources = other.sources,
      $directives = other.$directives,
      $animation = other.$animation;

  /// Creates a property that references a token.
  ///
  /// The token will be resolved from [MixScope] during resolution.
  /// Optionally accepts [directives] and [animation] configuration.
  factory Prop.token(
    MixToken<V> token, {
    List<Directive<V>>? directives,
    AnimationConfig? animation,
  }) {
    return Prop._(
      sources: [TokenSource(token)],
      directives: directives,
      animation: animation,
    );
  }

  /// Creates a property with only directives.
  ///
  /// This property has no value source and is used for applying
  /// transformations when merged with other properties.
  const Prop.directives(
    List<Directive<V>> directives, {
    AnimationConfig? animation,
  }) : this._(sources: const [], directives: directives, animation: animation);

  /// Creates a property with only animation configuration.
  ///
  /// This property has no value source and is used for applying
  /// animation when merged with other properties.
  const Prop.animation(AnimationConfig animation)
    : this._(sources: const [], directives: null, animation: animation);

  // Factory methods

  /// Creates a property from a direct value.
  ///
  /// If [value] is already a [Prop], returns it unchanged.
  /// Otherwise, wraps the value in a [ValueSource].
  /// 
  /// This method does NOT auto-convert values to Mix types.
  /// Use [Prop.mix] for explicit Mix values.
  static Prop<V> value<V>(V value) {
    if (value is Prop<V>) return value;
    
    // Always create ValueSource - no conversion!
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

  // Properties

  /// The runtime type of the property's value.
  Type get type => V;
  
  /// Returns the direct value if this property has a [ValueSource].
  ///
  /// Returns `null` if the property has no [ValueSource].
  /// This getter is maintained for backward compatibility.
  V? get $value {
    final valueSource = sources.whereType<ValueSource<V>>().firstOrNull;
    
    return valueSource?.value;
  }
  
  /// Returns the token if this property has a [TokenSource].
  ///
  /// Returns `null` if the property has no [TokenSource].
  /// This getter is maintained for backward compatibility.
  MixToken<V>? get $token {
    final tokenSource = sources.whereType<TokenSource<V>>().firstOrNull;
    
    return tokenSource?.token;
  }

  /// Whether this property contains at least one value source.
  ///
  /// Returns `true` if the property has [ValueSource] or [MixSource].
  bool get hasValue =>
      sources.any((s) => s is ValueSource<V> || s is MixSource<V>);

  /// Whether this property contains at least one token source.
  ///
  /// Returns `true` if the property has [TokenSource] or [MixTokenSource].
  bool get hasToken =>
      sources.any((s) => s is TokenSource<V> || s is MixTokenSource<V>);

  // Methods

  /// Returns a new property with the given directives merged with existing ones.
  Prop<V> directives(List<Directive<V>> directives) {
    return mergeProp(Prop.directives(directives));
  }

  /// Returns a new property with the given animation configuration.
  Prop<V> animation(AnimationConfig animation) {
    return mergeProp(Prop.animation(animation));
  }

  /// Merges this property with another property.
  ///
  /// The merge strategy depends on the source types:
  /// - For Mix sources: accumulates all sources
  /// - For regular values: replaces with the other's sources
  ///
  /// Directives are merged and animation from [other] takes precedence.
  Prop<V> mergeProp(covariant Prop<V>? other) {
    if (other == null) return this;

    // Determine merge strategy based on source types
    final hasMixSources =
        sources.any((s) => s is MixSource<V> || s is MixTokenSource<V>) ||
        other.sources.any((s) => s is MixSource<V> || s is MixTokenSource<V>);

    if (hasMixSources) {
      // Accumulation merge for Mix types
      return Prop._(
        sources: [...sources, ...other.sources],
        directives: PropOps.mergeDirectives($directives, other.$directives),
        animation: other.$animation ?? $animation,
      );
    } // Replacement merge for regular types
    final newSources = other.sources.isNotEmpty ? other.sources : sources;

    return Prop._(
      sources: newSources,
      directives: PropOps.mergeDirectives($directives, other.$directives),
      animation: other.$animation ?? $animation,
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
        MixTokenSource<V>(:final token, :final converter) => converter(
          MixScope.tokenOf(token, context),
        ),
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
          }
          // Skip if can't convert
        }
      }

      if (mixValues.isEmpty) {
        // Fallback to last value if no Mix values could be created
        resolvedValue = values.last as V;
      } else {
        // Merge all Mix values
        Mix<V> mergedMix = mixValues.first;
        for (int i = 1; i < mixValues.length; i++) {
          mergedMix = PropOps.mergeMixes(mergedMix, mixValues[i]);
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
        listEquals(other.$directives, $directives) &&
        other.$animation == $animation;
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
    if ($animation != null) {
      parts.add('animated');
    }

    return '$runtimeType(${parts.join(', ')})';
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(sources), $directives, $animation);
}

/// A property specialized for [Mix] values with accumulation merge behavior.
///
/// [MixProp] extends [Prop] to maintain backward compatibility while using
/// the unified property implementation internally. This class preserves the
/// original MixProp API to allow gradual migration to the new [Prop] API.
///
/// Unlike regular properties that use replacement merge, [MixProp] accumulates
/// values when merged, making it suitable for composable styling.
/// 
/// MIGRATION NOTE: In future versions, use [Prop.mix] for Mix values
/// and [Prop.value] for regular values. MixProp will be deprecated.
@immutable
class MixProp<V> extends Prop<V> {
  // Constructors

  /// Creates a property from a [Mix] value.
  MixProp(Mix<V> value) : super._(sources: [MixSource(value)]);

  /// Creates a property from a token with a converter function.
  ///
  /// The [converter] transforms the resolved token value into a [Mix].
  MixProp.token(MixToken<V> token, Mix<V> Function(V) converter)
    : super._(sources: [MixTokenSource(token, converter)]);

  /// Creates a property with only directives for transformation.
  const MixProp.directives(List<Directive<V>> directives)
    : super._(sources: const [], directives: directives);

  /// Creates a property with only animation configuration.
  const MixProp.animation(AnimationConfig animation)
    : super._(sources: const [], animation: animation);

  /// Creates a property with explicit sources, directives, and animation.
  ///
  /// This constructor is used internally by the factory method.
  const MixProp._({required super.sources, super.directives, super.animation})
    : super._();

  /// Creates a property from explicit components.
  ///
  /// Used internally to maintain type consistency when creating new instances.
  factory MixProp.create({
    required List<PropSource<V>> sources,
    List<Directive<V>>? directives,
    AnimationConfig? animation,
  }) {
    return MixProp._(
      sources: sources,
      directives: directives,
      animation: animation,
    );
  }

  // Static methods

  /// Creates a property from a nullable [Mix] value.
  ///
  /// Returns `null` if [value] is `null`.
  static MixProp<T>? maybe<T>(Mix<T>? value) {
    if (value == null) return null;

    return MixProp(value);
  }

  // Properties

  /// Returns the accumulated [Mix] value from all [MixSource] instances.
  ///
  /// Returns `null` if no [MixSource] instances are present.
  /// Token sources are ignored as they require context for resolution.
  Mix<V>? get value {
    if (sources.isEmpty) return null;

    // Collect all MixSource values
    final mixSources = sources
        .whereType<MixSource<V>>()
        .map((source) => source.mix)
        .toList();

    if (mixSources.isEmpty) {
      // No direct Mix values available
      return null;
    }

    // Merge all Mix values
    return mixSources.reduce((a, b) => PropOps.mergeMixes(a, b));
  }

  // Method overrides for type consistency

  @override
  MixProp<V> directives(List<Directive<V>> directives) {
    final merged = mergeProp(MixProp.directives(directives));

    return MixProp._(
      sources: merged.sources,
      directives: merged.$directives,
      animation: merged.$animation,
    );
  }

  @override
  MixProp<V> animation(AnimationConfig animation) {
    final merged = mergeProp(MixProp.animation(animation));

    return MixProp._(
      sources: merged.sources,
      directives: merged.$directives,
      animation: merged.$animation,
    );
  }

  @override
  MixProp<V> mergeProp(covariant Prop<V>? other) {
    if (other == null) return this;

    final merged = super.mergeProp(other);

    return MixProp._(
      sources: merged.sources,
      directives: merged.$directives,
      animation: merged.$animation,
    );
  }
}

// Type aliases

/// Alias for backward compatibility with code using PropBase.
@Deprecated('Use Prop instead. PropBase has been consolidated into Prop.')
typedef PropBase<V> = Prop<V>;
