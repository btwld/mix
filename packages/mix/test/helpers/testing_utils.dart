// ignore_for_file: prefer_relative_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// =============================================================================
// MOCK BUILD CONTEXT
// =============================================================================

/// Mock BuildContext for testing Mix components
class MockBuildContext extends BuildContext {
  final MixScopeData? _mixScopeData;

  MockBuildContext({MixScopeData? mixScopeData}) : _mixScopeData = mixScopeData;

  @override
  bool get debugDoingBuild => false;

  @override
  bool get mounted => true;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    if (T == MixScope) {
      return MixScope(
            data: _mixScopeData ?? const MixScopeData.empty(),
            child: const SizedBox(),
          )
          as T?;
    }
    return null;
  }

  @override
  InheritedElement?
  getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  @override
  Widget get widget => const SizedBox();

  @override
  BuildOwner? get owner => null;

  @override
  Size? get size => const Size(800, 600);

  @override
  RenderObject? findRenderObject() => null;

  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) {
    return ancestor.widget as InheritedWidget;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// Mock MixDirective for testing
class MockMixDirective<T> extends MixDirective<T> {
  final String name;
  final T Function(T) transformer;

  const MockMixDirective(this.name, this.transformer);

  @override
  String get key => name;

  @override
  T apply(T value) => transformer(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockMixDirective<T> &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'MockMixDirective($name)';
}
// =============================================================================
// CUSTOM MATCHERS
// =============================================================================

/// Checks if a Mix<T> or Resolvable<T> resolves to expected value
///
/// Usage:
/// ```dart
/// expect(borderMix, resolvesTo(Border.all(width: 2.0)));
/// expect(colorProp, resolvesTo(Colors.red));
/// expect(mix.width, resolvesTo(2.0));
/// ```
Matcher resolvesTo<T>(T expectedValue, {BuildContext? context}) {
  return _ResolvesToMatcher<T>(expectedValue, context ?? MockBuildContext());
}

/// Checks if a value is a Prop<T> with the expected value
///
/// Usage:
/// ```dart
/// expect(strutStyleMix.fontSize, isProp(16.0));
/// expect(strutStyleMix.fontFamily, isProp('Roboto'));
/// ```
Matcher isProp<T>(T expectedValue) {
  return _IsPropMatcher<T>(expectedValue);
}

/// Checks if a value is a Prop<T> with a token reference
///
/// Usage:
/// ```dart
/// expect(colorProp, isPropWithToken<Color>());
/// ```
Matcher isPropWithToken<T>() {
  return _IsPropWithTokenMatcher<T>();
}

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
// MATCHER IMPLEMENTATIONS
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

    matchState['error'] =
        'Expected Resolvable implementation, got ${item.runtimeType}';
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

class _IsPropMatcher<T> extends Matcher {
  final T expectedValue;

  const _IsPropMatcher(this.expectedValue);

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
    return description
        .add('is Prop<$T> with value ')
        .addDescriptionOf(expectedValue);
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
          .add('was Prop<$T> with value ')
          .addDescriptionOf(matchState['actual']);
    }

    return mismatchDescription.add('was ').addDescriptionOf(item);
  }
}

class _IsPropWithTokenMatcher<T> extends Matcher {
  const _IsPropWithTokenMatcher();

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
    return description.add('is Prop<$T> with token');
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

// =============================================================================
// TEST UTILITIES & MOCKS
// =============================================================================

/// Mock attribute for testing utilities
final class UtilityTestAttribute<T> extends SpecAttribute<MockSpec> {
  final T value;

  const UtilityTestAttribute(this.value);

  @override
  UtilityTestAttribute<T> merge(covariant UtilityTestAttribute<T>? other) {
    if (other == null) return this;
    // For Prop types, use their merge method
    if (value is Prop<T> && other.value is Prop<T>) {
      final merged = (value as Prop<T>).merge(other.value as Prop<T>);
      return UtilityTestAttribute(merged as T);
    }
    // For MixProp types that implement Mixable
    if (value is Mixable && other.value is Mixable) {
      final merged = (value as Mixable).merge(other.value as Mixable);
      return UtilityTestAttribute(merged as T);
    }
    // Default: just return the other value
    return UtilityTestAttribute(other.value);
  }

  @override
  MockSpec resolveSpec(BuildContext context) {
    final resolvedValue = value is Resolvable
        ? (value as Resolvable).resolve(context)
        : value;
    return MockSpec(resolvedValue: resolvedValue);
  }

  @override
  List<Object?> get props => [value];
}

/// Mock spec for testing
final class MockSpec extends Spec<MockSpec> {
  final dynamic resolvedValue;

  const MockSpec({this.resolvedValue});

  @override
  MockSpec lerp(MockSpec? other, double t) {
    if (other == null) return this;
    return other;
  }

  @override
  MockSpec copyWith({dynamic resolvedValue}) {
    return MockSpec(resolvedValue: resolvedValue ?? this.resolvedValue);
  }

  @override
  List<Object?> get props => [resolvedValue];
}

// =============================================================================
// WIDGET TESTER EXTENSIONS
// =============================================================================

/// Extension to add Mix testing utilities to WidgetTester
extension WidgetTesterExtension on WidgetTester {
  /// Pump widget with Mix scope
  Future<void> pumpWithMixScope(Widget widget, {MixScopeData? theme}) async {
    await pumpWidget(
      MaterialApp(
        home: MixScope(
          data: theme ?? const MixScopeData.empty(),
          child: widget,
        ),
      ),
    );
  }

  /// Pump widget with pressable state
  Future<void> pumpWithPressable(
    Widget widget, {
    bool disabled = false,
    bool focused = false,
    bool hovered = false,
    bool pressed = false,
  }) async {
    await pumpWithMixScope(Interactable(child: widget));
  }

  /// Pump widget wrapped in MaterialApp
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
  }
}
