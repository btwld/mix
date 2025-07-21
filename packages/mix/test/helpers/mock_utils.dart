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

/// Mock attribute for testing utilities - handles both Prop<T> and MixProp<T>
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
/// // For MixPropUtility (takes MixProp<T>)
/// final gradientUtility = GradientUtility(UtilityTestAttribute.new);
/// final attr = gradientUtility.linear(...);
/// ```
final class UtilityTestAttribute<T> extends SpecAttribute<MockSpec> {
  final dynamic value;

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
    return UtilityTestAttribute(MixHelpers.merge(value, other.value));
  }

  @override
  MockSpec resolveSpec(BuildContext context) {
    final resolvedValue = value is Resolvable ? value.resolve(context) : value;
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

/// Empty MixData for testing
const emptyMixData = MixScopeData.empty();

/// Empty BuildContext for testing (backward compatibility)
// ignore: constant_identifier_names, non_constant_identifier_names
final EmptyMixData = MockBuildContext();

/// Mock BuildContext instance for testing
final mockContext = MockBuildContext();

// =============================================================================
// EXTENSIONS FOR BACKWARD COMPATIBILITY
// =============================================================================

/// Extension to add a `value` getter to Prop<T> for backward compatibility
/// with existing tests that expect `.value.value` pattern
extension PropTestExtension<T> on Prop<T> {
  /// Backward compatibility getter that returns the underlying value
  /// if this prop has a value source
  T get value {
    if (hasValue) {
      return getValue();
    }
    throw StateError('Prop does not have a value source');
  }
}

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

/// Create a mock BuildContext with custom MixScopeData
MockBuildContext createMockContext({MixScopeData? mixScopeData}) {
  return MockBuildContext(mixScopeData: mixScopeData);
}

/// Resolve a Mix object using mock context
T resolveMockMix<T>(Mix<T> mix, {BuildContext? context}) {
  return mix.resolve(context ?? mockContext);
}

/// Resolve a Prop using mock context
T resolveMockProp<T>(Prop<T> prop, {BuildContext? context}) {
  return prop.resolve(context ?? mockContext);
}

/// Create a simple test SpecMix for testing
UtilityTestAttribute createTestAttribute<T>(T value) {
  return UtilityTestAttribute(Prop(value));
}

/// Create a test SpecMix with MixProp for testing
UtilityTestAttribute createTestDtoAttribute<T>(Mix<T> mix) {
  return UtilityTestAttribute(MixProp(mix));
}
