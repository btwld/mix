// ignore_for_file: prefer_relative_imports
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
/// ```
Matcher resolvesTo<T>(T expectedValue, {MixContext? context}) {
  return _ResolvesToMatcher<T>(expectedValue, context ?? EmptyMixData);
}

/// Check if two resolvable objects are equivalent when resolved
///
/// Usage:
/// ```dart
/// expect(mix1, equivalentTo(mix2));
/// expect(prop1, equivalentTo(prop2));
/// expect(attr1, equivalentTo(attr2));
/// ```
Matcher equivalentTo<T>(dynamic other, {MixContext? context}) {
  return _EquivalentToMatcher<T>(other, context ?? EmptyMixData);
}

// =============================================================================
// IMPLEMENTATION - Just the essentials
// =============================================================================

class _ResolvesToMatcher<T> extends Matcher {
  final T expectedValue;
  final MixContext context;

  const _ResolvesToMatcher(this.expectedValue, this.context);

  @override
  bool matches(dynamic item, Map matchState) {
    // Accept any ResolvableMixin implementation
    if (item is ResolvableMixin) {
      try {
        final resolved = item.resolve(context);
        return resolved == expectedValue;
      } catch (e) {
        matchState['error'] = 'Failed to resolve: $e';
        return false;
      }
    } else {
      matchState['error'] =
          'Expected ResolvableMixin implementation, got ${item.runtimeType}';
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

    if (item is ResolvableMixin) {
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

// Simple implementation that checks if two resolvable objects resolve to the same value
class _EquivalentToMatcher<T> extends Matcher {
  final ResolvableMixin other;
  final MixContext context;

  const _EquivalentToMatcher(this.other, this.context);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! ResolvableMixin) {
      matchState['error'] =
          'Expected ResolvableMixin implementation, got ${item.runtimeType}';
      return false;
    }

    try {
      final itemResolved = item.resolve(context);
      final otherResolved = other.resolve(context);
      return itemResolved == otherResolved;
    } catch (e) {
      matchState['error'] = 'Failed to resolve: $e';
      return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('is equivalent to ').addDescriptionOf(other);
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

    if (item is ResolvableMixin) {
      final itemResolved = item.resolve(context);
      final otherResolved = other.resolve(context);
      return mismatchDescription
          .add('resolved to ')
          .addDescriptionOf(itemResolved)
          .add(' instead of ')
          .addDescriptionOf(otherResolved);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}
