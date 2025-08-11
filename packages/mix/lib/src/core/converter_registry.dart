import 'package:flutter/foundation.dart';

import 'converter_registry_init.dart';
import 'mix_element.dart';

/// Provides context for type conversion operations.
///
/// This interface allows converters to perform nested conversions
/// without directly depending on the registry implementation,
/// avoiding circular dependencies and enabling lazy resolution.
abstract interface class ConversionContext {
  /// Attempts to convert a value to its [Mix] representation.
  ///
  /// Returns the converted [Mix] value if a converter is registered,
  /// or `null` if no converter is found for type [T].
  Mix<T>? tryConvert<T>(T value);

  /// Checks whether a converter is registered for type [T].
  ///
  /// Returns `true` if a converter exists, `false` otherwise.
  bool canConvert<T>();
}

/// Defines how to convert values to their [Mix] representations.
///
/// Implement this interface to create custom converters for your types.
/// Converters receive a [ConversionContext] to enable nested conversions.
abstract interface class MixConverter<T> {
  /// Converts a value to its [Mix] representation.
  ///
  /// Use [context] to convert nested values when needed.
  /// This enables complex conversions without circular dependencies.
  Mix<T> toMix(T value, ConversionContext context);
}

/// A singleton registry for type converters.
///
/// The registry manages converters that transform Flutter types into
/// their [Mix] equivalents. It implements [ConversionContext] to provide
/// lazy resolution and avoid circular dependencies between converters.
///
/// Converters are automatically initialized on first use.
class MixConverterRegistry implements ConversionContext {
  /// The global instance of the converter registry.
  ///
  /// Access this to register custom converters or perform conversions.
  static final MixConverterRegistry instance = MixConverterRegistry._();

  final Map<Type, MixConverter> _converters = {};
  final Map<Object, dynamic> _conversionCache = {};
  bool _initialized = false;

  MixConverterRegistry._();

  /// Registers a converter for type [T].
  ///
  /// The converter will be used when [tryConvert] or [convert] is called
  /// with a value of type [T].
  void register<T>(MixConverter<T> converter) {
    _converters[T] = converter;
  }

  /// Returns the converter registered for type [T].
  ///
  /// Returns `null` if no converter is registered.
  MixConverter<T>? get<T>() {
    return _converters[T] as MixConverter<T>?;
  }

  /// Converts a value to its [Mix] representation.
  ///
  /// Throws [StateError] if no converter is registered for type [T].
  /// Use [tryConvert] for a non-throwing alternative.
  Mix<T> convert<T>(T value) {
    final result = tryConvert<T>(value);
    if (result == null) {
      throw StateError('No converter registered for type $T');
    }

    return result;
  }

  /// Removes all registered converters.
  ///
  /// This method is only available in tests.
  @visibleForTesting
  void clear() {
    _converters.clear();
    _conversionCache.clear();
  }

  /// Clears the internal conversion cache.
  ///
  /// Call this if you need to free memory from cached conversions.
  void clearCache() {
    _conversionCache.clear();
  }

  @override
  bool canConvert<T>() {
    return _converters.containsKey(T);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      _initialized = true;
      initializeMixConverters();
    }
  }
  
  @override
  Mix<T>? tryConvert<T>(T value) {
    _ensureInitialized();
    final converter = get<T>();
    if (converter != null) {
      // Use this registry as the conversion context
      return converter.toMix(value, this);
    }

    return null;
  }
}

// Helper implementations

/// A converter that delegates to a function.
///
/// Use this to adapt existing conversion functions to the [MixConverter] interface.
class FunctionMixConverter<T> implements MixConverter<T> {
  final Mix<T> Function(T value, ConversionContext context) _toMix;

  const FunctionMixConverter(this._toMix);

  @override
  Mix<T> toMix(T value, ConversionContext context) => _toMix(value, context);
}

/// A converter for types that don't require nested conversions.
///
/// Use this when your conversion logic doesn't need to convert nested values.
/// The [ConversionContext] parameter is ignored.
class SimpleMixConverter<T> implements MixConverter<T> {
  final Mix<T> Function(T value) _toMix;

  const SimpleMixConverter(this._toMix);

  @override
  Mix<T> toMix(T value, ConversionContext context) => _toMix(value);
}
