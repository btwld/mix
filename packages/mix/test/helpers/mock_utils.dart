// ignore_for_file: prefer_relative_imports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Mock utilities for testing Mix components
///
/// This file provides mock classes and utilities needed for testing
/// Mix utilities, DTOs, and other components in isolation.

// =============================================================================
// MOCK TEST ATTRIBUTES
// =============================================================================

/// Mock attribute for testing utilities - handles both Prop<T> and Prop<Mix<T>>
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
/// // For MixPropUtility (takes Prop<Mix<T>>)
/// final gradientUtility = GradientUtility(UtilityTestAttribute.new);
/// final attr = gradientUtility.linear(...);
/// ```
final class UtilityTestAttribute<T> extends SpecStyle<MockSpec> {
  final T value;

  const UtilityTestAttribute(this.value);

  /// Helper to get the resolved value from the prop (works for both Prop and MixProp)
  T? getValue() {
    if (value is Prop<T> && (value as Prop<T>).hasValue) {
      return (value as Prop<T>).getValue();
    }
    return null;
  }

  /// Helper to get the token from the prop (works for both Prop and MixProp)
  MixToken<T>? getToken() {
    if (value is Prop<T> && (value as Prop<T>).hasToken) {
      return (value as Prop<T>).getToken();
    }
    return null;
  }

  /// Helper to check if prop has a value
  bool get hasValue {
    if (value is Prop<T>) {
      return (value as Prop<T>).hasValue;
    }
    return value != null;
  }

  /// Helper to check if prop has a token
  bool get hasToken {
    if (value is Prop<T>) {
      return (value as Prop<T>).hasToken;
    }
    return false;
  }

  /// Helper to resolve the prop value
  T? resolveValue(BuildContext context) {
    if (value is Resolvable<T>) {
      return (value as Resolvable<T>).resolve(context);
    }
    return value as T?;
  }

  /// Backward compatibility getter for tests that expect .value.value
  /// This allows tests to access the underlying value directly
  T? get valueValue => getValue();

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
  MockSpec resolve(BuildContext context) {
    final resolvedValue = value is Resolvable
        ? (value as Resolvable).resolve(context)
        : value;
    return MockSpec(resolvedValue: resolvedValue);
  }

  @override
  List<Object?> get props => [value];
}

/// Mock spec for testing purposes
///
/// A simple Spec implementation that holds a resolved value.
/// Used as the target spec for mock attributes.
final class MockSpec extends Spec<MockSpec> {
  final dynamic resolvedValue;

  const MockSpec({this.resolvedValue});

  @override
  MockSpec lerp(MockSpec? other, double t) {
    if (other == null) return this;
    // Simple lerp - just return other for testing
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
// MOCK BUILD CONTEXT
// =============================================================================

/// Enhanced mock BuildContext for testing
///
/// Provides a more complete BuildContext implementation for testing
/// Mix components that need context for resolution.
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
    // Provide MixScope for testing if requested
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

  // All other methods use noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// =============================================================================
// MOCK DATA CONSTANTS
// =============================================================================

/// Mock BuildContext instance for testing
final mockContext = MockBuildContext();

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

// =============================================================================
// ENHANCED SPEC & ATTRIBUTE TESTING INFRASTRUCTURE
// =============================================================================

/// Enhanced mock infrastructure for testing Specs and SpecAttributes
class SpecTestHelper {
  /// Creates a mock BuildContext for testing spec resolution
  static BuildContext createMockContext() => MockBuildContext();

  /// Creates a mock Style for testing attribute resolution
  static SpecStyle createMockStyle() {
    return Style();
  }

  /// Helper to test spec lerp functionality
  static void testSpecLerp<T extends Spec<T>>(
    T spec1,
    T spec2,
    double t,
    T expected, {
    String? description,
  }) {
    final result = spec1.lerp(spec2, t);
    if (result != expected) {
      throw AssertionError(
        'Lerp test failed${description != null ? ' ($description)' : ''}: '
        'Expected $expected, got $result',
      );
    }
  }

  /// Helper to test spec copyWith functionality
  static void testSpecCopyWith<T extends Spec<T>>(
    T original,
    T Function() copyWithCall,
    bool Function(T result) validator, {
    String? description,
  }) {
    final result = copyWithCall();
    if (!validator(result)) {
      throw AssertionError(
        'CopyWith test failed${description != null ? ' ($description)' : ''}: '
        'Validator returned false for result $result',
      );
    }
  }

  /// Helper to test spec equality
  static void testSpecEquality<T extends Spec<T>>(
    T spec1,
    T spec2,
    bool shouldBeEqual, {
    String? description,
  }) {
    final areEqual = spec1 == spec2;
    if (areEqual != shouldBeEqual) {
      throw AssertionError(
        'Equality test failed${description != null ? ' ($description)' : ''}: '
        'Expected ${shouldBeEqual ? 'equal' : 'not equal'}, but specs were ${areEqual ? 'equal' : 'not equal'}',
      );
    }
  }
}

/// Enhanced mock infrastructure for testing SpecAttributes
class AttributeTestHelper {
  /// Helper to test attribute merge functionality
  static void testAttributeMerge<T extends Spec<T>, A extends SpecStyle<T>>(
    A attr1,
    A attr2,
    bool Function(A result) validator, {
    String? description,
  }) {
    final result = attr1.merge(attr2) as A;
    if (!validator(result)) {
      throw AssertionError(
        'Merge test failed${description != null ? ' ($description)' : ''}: '
        'Validator returned false for result $result',
      );
    }
  }

  /// Helper to test attribute resolution
  static void testAttributeResolution<
    T extends Spec<T>,
    A extends SpecStyle<T>
  >(A attribute, bool Function(T spec) validator, {String? description}) {
    final context = SpecTestHelper.createMockContext();
    final result = attribute.resolve(context);
    if (!validator(result)) {
      throw AssertionError(
        'Resolution test failed${description != null ? ' ($description)' : ''}: '
        'Validator returned false for spec $result',
      );
    }
  }

  /// Helper to test attribute equality
  static void testAttributeEquality<T extends Spec<T>, A extends SpecStyle<T>>(
    A attr1,
    A attr2,
    bool shouldBeEqual, {
    String? description,
  }) {
    final areEqual = attr1 == attr2;
    if (areEqual != shouldBeEqual) {
      throw AssertionError(
        'Equality test failed${description != null ? ' ($description)' : ''}: '
        'Expected ${shouldBeEqual ? 'equal' : 'not equal'}, but attributes were ${areEqual ? 'equal' : 'not equal'}',
      );
    }
  }

  /// Helper to test attribute property access
  static void testAttributeProperty<T, A extends SpecStyle<dynamic>>(
    A attribute,
    T? Function(A attr) propertyGetter,
    T? expectedValue, {
    String? description,
  }) {
    final actualValue = propertyGetter(attribute);
    if (actualValue != expectedValue) {
      throw AssertionError(
        'Property test failed${description != null ? ' ($description)' : ''}: '
        'Expected $expectedValue, got $actualValue',
      );
    }
  }
}
