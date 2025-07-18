// ignore_for_file: prefer_relative_imports
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

/// Simple, focused matchers for Mix system testing
///
/// Following the 80/20 rule - these core matchers solve the most common
/// testing pain points without over-engineering.

// =============================================================================
// CORE MATCHERS (80% of use cases)
// =============================================================================

/// The most important matcher - checks if a Mix<T> resolves to expected value
/// Eliminates the need for manual `.resolve(EmptyMixData)` calls
///
/// Usage:
/// ```dart
/// expect(colorMix, resolvesTo(Colors.red));
/// expect(borderSide.width, resolvesTo(2.0));
/// ````
Matcher resolvesTo<T>(T expectedValue, {BuildContext? context}) {
  return _ResolvesToMatcher<T>(expectedValue, context ?? TestData.mockContext);
}

// =============================================================================
// IMPLEMENTATION - Just the essentials
// =============================================================================

class _ResolvesToMatcher<T> extends Matcher {
  final T expectedValue;
  final BuildContext context;

  const _ResolvesToMatcher(this.expectedValue, this.context);

  @override
  bool matches(dynamic item, Map matchState) {
    // Accept any Resolvable implementation
    if (item is Resolvable) {
      try {
        final resolved = item.resolve(context);
        // If expectedValue is a Matcher, apply it to the resolved value
        if (expectedValue is Matcher) {
          return (expectedValue as Matcher).matches(resolved, matchState);
        }
        return resolved == expectedValue;
      } catch (e) {
        matchState['error'] = 'Failed to resolve: $e';
        return false;
      }
    } else {
      matchState['error'] =
          'Expected Resolvable implementation, got ${item.runtimeType}';
      return false;
    }
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

    if (item is Resolvable) {
      final resolved = item.resolve(context);
      return mismatchDescription
          .add('resolved to ')
          .addDescriptionOf(resolved)
          .add(' instead of ')
          .addDescriptionOf(expectedValue);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}
