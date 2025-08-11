// ignore_for_file: prefer_relative_imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void expectProp<T>(Prop<T>? prop, dynamic expected) {
  if (expected == null || expected == isNull) {
    expect(prop, isNull);
    return;
  }

  if (prop == null) {
    fail('Expected Prop<$T> to exist, but was null');
  }

  // Handle MixProp (no accumulation anymore)
  if (prop is MixProp<T>) {
    final value = prop.value;
    if (value == null) {
      fail('Expected MixProp<$T> to have a value, but value was null');
    }
    expect(
      value,
      expected,
      reason: 'MixProp<$T> value does not match expected',
    );
    return;
  }

  // Handle Prop
  final value = prop.$value;
  final token = prop.$token;

  if (value == null && token == null) {
    expect(isNull, expected, reason: 'Prop<$T> has no value or token defined');
    return;
  }

  // Handle token expectations
  if (expected is MixToken<T>) {
    if (token != null) {
      expect(token, expected, reason: 'Prop<$T> token does not match expected');
    } else {
      fail('Expected token, but prop has value: $value');
    }
    return;
  }

  // Handle direct value expectations
  if (token != null) {
    fail('Expected value, but prop has token: $token');
  }

  expect(value, expected, reason: 'Prop<$T> value does not match expected');
  return;

  fail('Unknown prop type: ${prop.runtimeType}');
}

/// Creates a matcher that tests what a Resolvable resolves to
///
/// Usage:
/// ```dart
/// // For any Resolvable type
/// expect(colorMix, resolvesTo(Colors.red));
/// expect(paddingAttribute, resolvesTo(EdgeInsets.all(10)));
/// expect(widthProp, resolvesTo(100.0));
///
/// // With custom context for token resolution
/// final context = MockBuildContext(
///   tokens: {
///     MixToken<Color>('primary').defineValue(Colors.blue),
///   },
/// );
/// expect(tokenProp, resolvesTo(Colors.blue, context: context));
/// ```
Matcher resolvesTo<T>(T expected, {BuildContext? context}) {
  return _ResolvesToMatcher<T>(expected, context);
}

class _ResolvesToMatcher<T> extends Matcher {
  final T expected;
  final BuildContext? context;

  const _ResolvesToMatcher(this.expected, this.context);

  @override
  bool matches(dynamic item, Map matchState) {
    // Check if item implements Resolvable (any type)
    if (item is! Resolvable && item is! Prop) {
      matchState['error'] =
          'Expected Resolvable or Prop, but got ${item.runtimeType}';
      return false;
    }

    try {
      final ctx = context ?? MockBuildContext();
      dynamic resolved;
      if (item is Prop) {
        resolved = item.resolveProp(ctx);
      } else {
        resolved = item.resolve(ctx);
      }

      // Let runtime comparison handle type compatibility
      // This allows Prop<AlignmentGeometry> to work with Alignment expectations
      if (resolved == expected) {
        return true;
      }

      // Provide helpful error message with actual vs expected types
      matchState['error'] =
          'Resolved to ${resolved.runtimeType}:<$resolved>, expected $T:<$expected>';
      return false;
    } catch (e) {
      matchState['error'] = 'Failed to resolve: $e';
      return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('resolves to ').addDescriptionOf(expected);
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

    if (item is Resolvable<T>) {
      try {
        final ctx = context ?? MockBuildContext();
        final resolved = item.resolve(ctx);
        return mismatchDescription
            .add('resolved to ')
            .addDescriptionOf(resolved)
            .add(' instead of ')
            .addDescriptionOf(expected);
      } catch (e) {
        return mismatchDescription.add('failed to resolve: $e');
      }
    }

    return mismatchDescription
        .add('was ')
        .addDescriptionOf(item)
        .add(' which is not a Resolvable<$T>');
  }
}

// =============================================================================
// MOCK BUILD CONTEXT
// =============================================================================

/// Mock BuildContext for testing Mix components
class MockBuildContext extends BuildContext {
  final Set<TokenDefinition>? _tokens;
  final List<Type>? _orderOfModifiers;
  MixScope? _mixScope;

  MockBuildContext({Set<TokenDefinition>? tokens, List<Type>? orderOfModifiers})
    : _tokens = tokens,
      _orderOfModifiers = orderOfModifiers {
    // Create MixScope instance once
    _mixScope = MixScope(
      tokens: _tokens,
      orderOfModifiers: _orderOfModifiers,
      child: const SizedBox(),
    );
  }

  @override
  bool get debugDoingBuild => false;

  @override
  bool get mounted => true;

  /// Inherited widget - supports both InheritedWidget and InheritedModel
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    if (T == MixScope) {
      return _mixScope as T?;
    }
    return null;
  }

  @override
  InheritedElement?
  getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    // For InheritedModel.inheritFrom to work, we need to return a mock element
    if (T == MixScope && _mixScope != null) {
      return _MockInheritedElement(_mixScope!);
    }
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    if (T == MixScope) {
      return _mixScope as T?;
    }
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

/// Mock InheritedElement for testing InheritedModel functionality
class _MockInheritedElement extends InheritedElement {
  _MockInheritedElement(super.widget);

  @override
  MixScope get widget => super.widget as MixScope;

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    // Mock implementation - just track the dependency
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // Mock implementation
  }
}

// =============================================================================
// ADDITIONAL TEST UTILITIES
// =============================================================================

/// Mock attribute for testing utilities - handles both `Prop<T>` and `MixProp<V>`
///
/// This is a universal SpecMix that can wrap any prop type for testing purposes.
/// Used with utilities that expect a SpecMix builder function.
///
/// Usage:
/// ```dart
/// // For PropUtility (takes Prop<T>)
/// final colorUtility = ColorUtility(UtilityTestAttribute.new);
/// final attr = colorUtility(Colors.red);
///
/// // For complex utilities (takes Mix<V>)
/// final gradientUtility = GradientUtility(UtilityTestAttribute.new);
/// final attr = gradientUtility.linear(...);
/// ```
class MockStyle<T> extends Style<MockSpec<T>> {
  final T value;

  const MockStyle(
    this.value, {
    super.variants,
    super.modifier,
    super.animation,

    super.inherit,
  });

  @override
  MockStyle<T> merge(covariant MockStyle<T>? other) {
    if (other == null) return this;
    // For Prop types (Prop<T> and MixProp<V>), use their merge method
    if (value is Prop && other.value is Prop) {
      final merged = (value as Prop).mergeProp(other.value as Prop);
      return MockStyle(merged as T);
    }
    // For other Mixable types
    if (value is Mixable && other.value is Mixable) {
      final merged = (value as Mixable).merge(other.value as Mixable);
      return MockStyle(merged as T);
    }
    // Default: just return the other value
    return MockStyle(other.value);
  }

  @override
  MockSpec<T> resolve(BuildContext context) {
    return MockSpec<T>(resolvedValue: value);
  }

  @override
  List<Object?> get props => [value];
}

/// Mock spec for testing purposes
///
/// A simple Spec implementation that holds a resolved value.
/// Used as the target spec for mock attributes.
final class MockSpec<T> extends Spec<MockSpec<T>> {
  final T? resolvedValue;

  const MockSpec({this.resolvedValue});

  @override
  MockSpec<T> lerp(MockSpec<T>? other, double t) {
    if (other == null) return this;
    // Simple lerp - just return other for testing
    return other;
  }

  @override
  MockSpec<T> copyWith({T? resolvedValue}) {
    return MockSpec(resolvedValue: resolvedValue ?? this.resolvedValue);
  }

  @override
  List<Object?> get props => [resolvedValue];
}

// =============================================================================
// MOCK TESTING UTILITIES
// =============================================================================

/// Mock Mix type for testing
///
/// A generic Mix implementation that can hold any type of value.
/// Supports merge operations by delegating to a custom merge function.
///
/// Usage:
/// ```dart
/// final mixInt = MockMix<int>(42);
/// final mixString = MockMix<String>('hello');
///
/// // With custom merge logic
/// final mixList = MockMix<List<int>>(
///   [1, 2, 3],
///   merger: (a, b) => [...a, ...b],
/// );
/// ```
class MockMix<T> extends Mix<T> {
  final T value;
  final T Function(T a, T b)? merger;

  const MockMix(this.value, {this.merger});

  @override
  MockMix<T> merge(covariant MockMix<T>? other) {
    if (other == null) return this;

    final mergedValue = merger != null
        ? merger!(value, other.value)
        : other.value; // Default: other wins

    return MockMix<T>(mergedValue, merger: merger);
  }

  @override
  T resolve(BuildContext context) => value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'MockMix<$T>($value)';
}

/// Mock directive for testing
///
/// A simple directive implementation for testing purposes.
/// By default, applies identity transformation (returns value unchanged).
/// Can optionally provide a custom transformer function.
///
/// Usage:
/// ```dart
/// // Simple directive for testing presence (identity transform)
/// final directive1 = MockDirective<int>('test');
///
/// // With custom transformer
/// final doubleDirective = MockDirective<int>(
///   'double',
///   (value) => value * 2,
/// );
/// ```
class MockDirective<T> extends Directive<T> {
  final String name;
  final T Function(T)? transformer;

  const MockDirective(this.name, [this.transformer]);

  @override
  T apply(T value) => transformer?.call(value) ?? value;

  @override
  String get key => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MockDirective<T> &&
        other.name == name &&
        other.transformer == transformer;
  }

  @override
  int get hashCode => Object.hash(name, transformer);

  @override
  String toString() => 'MockDirective<$T>($name)';
}

// =============================================================================
// WIDGET TESTER EXTENSIONS
// =============================================================================

/// Extension to add Mix testing utilities to WidgetTester
extension WidgetTesterExtension on WidgetTester {
  /// Pump widget with Mix scope
  Future<void> pumpWithMixScope(
    Widget widget, {
    Set<TokenDefinition>? tokens,
    List<Type>? orderOfModifiers,
    bool withMaterial = false,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: withMaterial
            ? MixScope.withMaterial(
                tokens: tokens,
                orderOfModifiers: orderOfModifiers,
                child: widget,
              )
            : tokens != null || orderOfModifiers != null
            ? MixScope(
                tokens: tokens,
                orderOfModifiers: orderOfModifiers,
                child: widget,
              )
            : MixScope.empty(child: widget),
      ),
    );
  }

  /// Pump widget wrapped in MaterialApp
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
  }
}

// =============================================================================
// MOCK CLASSES FOR TESTING
// =============================================================================

/// Mock directive for testing purposes
///
/// A simple directive implementation for testing purposes.
/// By default, applies identity transformation (returns value unchanged).
/// Can optionally provide a custom transformer function.
class MockMixDirective<T> extends Directive<T> {
  final String name;
  final T Function(T)? transform;

  const MockMixDirective(this.name, [this.transform]);

  @override
  String get key => name;

  @override
  T apply(T value) => transform?.call(value) ?? value;

  @override
  String toString() => 'MockMixDirective($name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MockMixDirective<T> &&
        other.name == name &&
        other.transform == transform;
  }

  @override
  int get hashCode => Object.hash(name, transform);
}

final blackPixelBytes = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==",
);

MemoryImage mockImageProvider() {
  return MemoryImage(blackPixelBytes);
}
