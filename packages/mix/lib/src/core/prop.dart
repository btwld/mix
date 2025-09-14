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
/// Provides storage for values, token resolution, merging strategies,
/// and directive application for value transformations.
///
/// Use [Prop.value] for regular values, [Prop.mix] for Mix values.
/// Type conversion to Mix types happens only during resolution.
@immutable
class Prop<V> {
  /// Sources that provide values for this property.
  final List<PropSource<V>> sources;

  /// Directives to transform the resolved value.
  final List<Directive<V>>? $directives;

  // Constructors

  /// Creates a property with the given sources and directives.
  const Prop._({required this.sources, List<Directive<V>>? directives})
    : $directives = directives;

  /// Creates a property by copying all fields from another property.
  Prop.fromProp(Prop<V> other)
    : sources = other.sources,
      $directives = other.$directives;

  /// Creates a property that references a token.
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
  /// Detects token references and creates appropriate source types.
  ///
  /// Does not auto-convert values to Mix types. Use [Prop.mix] for Mix values.
  static Prop<V> value<V>(V value) {
    if (value is Prop<V>) return value;

    // Handle extension type token references
    if (isAnyTokenRef(value as Object)) {
      final token = getTokenFromValue(value as Object) as MixToken<V>?;
      if (token != null) {
        return Prop._(sources: [TokenSource(token)]);
      }
    }

    return Prop._(sources: [ValueSource(value)]);
  }

  /// Creates a property from a [Mix] value for accumulation merging.
  static Prop<V> mix<V>(Mix<V> mix) {
    // Check if mix is already a token reference (MixRef)
    // MixRef objects are Prop<V> instances with TokenSource that implement Mix interfaces
    if (mix is Prop<V>) {
      final prop = mix as Prop<V>;
      if (prop.hasToken) {
        return prop; // Return token reference directly to preserve TokenSource
      }
    }
    
    return Prop._(sources: [MixSource(mix)]);
  }

  /// Creates a property from a nullable value.
  static Prop<V>? maybe<V>(V? value) {
    if (value == null) return null;

    return Prop.value(value);
  }

  /// Creates a property from a nullable [Mix] value.
  static Prop<V>? maybeMix<V>(Mix<V>? value) {
    if (value == null) return null;
    
    // Check if value is already a token reference (MixRef)
    // MixRef objects are Prop<V> instances with TokenSource that implement Mix interfaces
    if (value is Prop<V>) {
      final prop = value as Prop<V>;
      if (prop.hasToken) {
        return prop; // Return token reference directly to preserve TokenSource
      }
    }
    
    return Prop.mix(value);
  }


  /// Creates a property by converting a regular value to a Mix.
  static Prop<V>? mixValue<V>(V value) {
    final converted = MixConverterRegistry.instance.tryConvert<V>(value);
    if (converted == null) return null;

    return Prop.mix(converted);
  }

  // Properties

  /// The runtime type of the property's value.
  Type get type => V;

  /// Whether this property contains at least one value source.
  bool get hasValue =>
      sources.any((s) => s is ValueSource<V> || s is MixSource<V>);

  /// Whether this property contains at least one token source.
  bool get hasToken => sources.any((s) => s is TokenSource<V>);

  // Methods

  /// Returns a new property with the given directives merged with existing ones.
  Prop<V> directives(List<Directive<V>> directives) {
    return mergeProp(Prop.directives(directives));
  }

  /// Merges this property with another property.
  ///
  /// Accumulates all sources. Mix sources use accumulation strategy,
  /// regular values use replacement strategy.
  Prop<V> mergeProp(covariant Prop<V>? other) {
    if (other == null) return this;

    // Always accumulate all sources - no conditional logic
    return Prop._(
      sources: [...sources, ...other.sources],
      directives: PropOps.mergeDirectives($directives, other.$directives),
    );
  }

  /// Resolves this property to a concrete value.
  ///
  /// Resolves sources, converts values to Mix if needed, merges based on type,
  /// and applies directives.
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
