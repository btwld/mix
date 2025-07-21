// ignore_for_file: prefer_relative_imports
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

/// Simple, focused matchers for testing DTOs and Prop values in Mix
///
/// Core principle: Keep it simple and solve the most common case -
/// checking if values resolve correctly.

// =============================================================================
// CORE RESOLUTION MATCHERS
// =============================================================================

/// Checks if a Mix<T> or Resolvable<T> resolves to expected value
/// This is the most important matcher - handles 80% of DTO testing needs
///
/// Usage:
/// ```dart
/// expect(borderMix, resolvesTo(Border.all(width: 2.0)));
/// expect(colorProp, resolvesTo(Colors.red));
/// expect(mix.width, resolvesTo(2.0));
/// ```
Matcher resolvesTo<T>(T expectedValue, {BuildContext? context}) {
  return _ResolvesToMatcher<T>(expectedValue, context ?? TestData.mockContext);
}

/// Checks if a nullable value resolves to expected value or null
///
/// Usage:
/// ```dart
/// expect(mix.color, resolvesToMaybe(Colors.red));
/// expect(nullableMix, resolvesToMaybe(null));
/// ```
Matcher resolvesToMaybe<T>(T? expectedValue, {BuildContext? context}) {
  if (expectedValue == null) {
    return isNull;
  }
  return resolvesTo<T>(expectedValue, context: context);
}

/// Checks multiple properties resolve to expected values
///
/// Usage:
/// ```dart
/// expect(borderMix, resolvesProperties({
///   'top': (mix) => mix.top,
///   'bottom': (mix) => mix.bottom,
/// }, {
///   'top': resolvesTo(BorderSide(width: 1.0)),
///   'bottom': resolvesTo(BorderSide.none),
/// }));
/// ```
Matcher resolvesProperties<T>(
  Map<String, dynamic Function(T)> getters,
  Map<String, Matcher> expectations, {
  BuildContext? context,
}) {
  return _ResolvesPropertiesMatcher<T>(
    getters,
    expectations,
    context ?? TestData.mockContext,
  );
}

// =============================================================================
// PROP-SPECIFIC MATCHERS
// =============================================================================

/// Checks if a Prop has a direct value (not a token)
///
/// Usage:
/// ```dart
/// expect(colorProp, hasValue(Colors.red));
/// ```
Matcher hasValue<T>(T expectedValue) {
  return _HasValueMatcher<T>(expectedValue);
}

/// Checks if a Prop has a token reference
///
/// Usage:
/// ```dart
/// expect(colorProp, hasToken<Color>());
/// ```
Matcher hasToken<T>() {
  return _HasTokenMatcher<T>();
}

// =============================================================================
// MERGE MATCHERS
// =============================================================================

/// Checks if merging produces expected result by resolution
///
/// Usage:
/// ```dart
/// final merged = dto1.merge(mix2);
/// expect(merged, resolvesTo(expectedBorder));
/// ```
// Just use resolvesTo! No need for a separate matcher

/// Checks if merge(null) returns identical instance
///
/// Usage:
/// ```dart
/// expect(mix.merge(null), same(mix));
/// ```
// Just use same()! No need for a custom matcher

// =============================================================================
// IMPLEMENTATION
// =============================================================================

class _ResolvesToMatcher<T> extends Matcher {
  final T expectedValue;
  final BuildContext context;

  const _ResolvesToMatcher(this.expectedValue, this.context);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item == null) {
      matchState['error'] = 'Cannot resolve null';
      return false;
    }

    // Handle Resolvable (includes all DTOs and Props)
    if (item is Resolvable) {
      try {
        final resolved = item.resolve(context);

        // If expectedValue is a Matcher, delegate to it
        if (expectedValue is Matcher) {
          return (expectedValue as Matcher).matches(resolved, matchState);
        }

        // Direct equality check
        if (resolved != expectedValue) {
          matchState['actual'] = resolved;
          return false;
        }
        return true;
      } catch (e) {
        matchState['error'] = 'Failed to resolve: $e';
        return false;
      }
    }

    matchState['error'] = 'Expected Resolvable, got ${item.runtimeType}';
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('resolves to ').addDescriptionOf(expectedValue);
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState.containsKey('error')) {
      return mismatchDescription.add(matchState['error']);
    }

    if (matchState.containsKey('actual')) {
      return mismatchDescription
          .add('resolved to ')
          .addDescriptionOf(matchState['actual']);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}

class _HasValueMatcher<T> extends Matcher {
  final T expectedValue;

  const _HasValueMatcher(this.expectedValue);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop<T>) {
      matchState['error'] = 'Expected Prop<$T>, got ${item.runtimeType}';
      return false;
    }

    if (!item.hasValue) {
      matchState['error'] = 'Prop has no value (might be token or empty)';
      return false;
    }

    final actualValue = item.getValue();
    if (actualValue != expectedValue) {
      matchState['actual'] = actualValue;
      return false;
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('has value ').addDescriptionOf(expectedValue);
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState.containsKey('error')) {
      return mismatchDescription.add(matchState['error']);
    }

    if (matchState.containsKey('actual')) {
      return mismatchDescription
          .add('had value ')
          .addDescriptionOf(matchState['actual']);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}

class _HasTokenMatcher<T> extends Matcher {
  const _HasTokenMatcher();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop<T>) {
      matchState['error'] = 'Expected Prop<$T>, got ${item.runtimeType}';
      return false;
    }

    if (!item.hasToken) {
      matchState['error'] = 'Prop has no token';
      return false;
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('has token of type $T');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState.containsKey('error')) {
      return mismatchDescription.add(matchState['error']);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}

class _ResolvesPropertiesMatcher<T> extends Matcher {
  final Map<String, dynamic Function(T)> getters;
  final Map<String, Matcher> expectations;
  final BuildContext context;

  const _ResolvesPropertiesMatcher(
    this.getters,
    this.expectations,
    this.context,
  );

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! T) {
      matchState['error'] = 'Expected $T, got ${item.runtimeType}';
      return false;
    }

    for (final entry in expectations.entries) {
      final propertyName = entry.key;
      final matcher = entry.value;
      final getter = getters[propertyName];

      if (getter == null) {
        matchState['error'] = 'No getter provided for property "$propertyName"';
        return false;
      }

      try {
        final propertyValue = getter(item);
        if (!matcher.matches(propertyValue, matchState)) {
          matchState['property'] = propertyName;
          return false;
        }
      } catch (e) {
        matchState['error'] = 'Failed to get property "$propertyName": $e';
        return false;
      }
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('has properties that match expectations');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState.containsKey('error')) {
      return mismatchDescription.add(matchState['error']);
    }

    if (matchState.containsKey('property')) {
      return mismatchDescription.add(
        'property "${matchState['property']}" did not match',
      );
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}
