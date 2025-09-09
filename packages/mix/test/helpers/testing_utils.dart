// ignore_for_file: prefer_relative_imports
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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

      // Check if expected is a Matcher and use its matches() method
      if (expected is Matcher) {
        final matcher = expected as Matcher;
        if (matcher.matches(resolved, matchState)) {
          return true;
        }
        // matchState is already populated by the matcher
        return false;
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

    if (item is Resolvable || item is Prop) {
      try {
        final ctx = context ?? MockBuildContext();
        dynamic resolved;
        if (item is Prop) {
          resolved = item.resolveProp(ctx);
        } else {
          resolved = (item as Resolvable).resolve(ctx);
        }

        // Handle Matcher expected values differently
        if (expected is Matcher) {
          return mismatchDescription
              .add('resolved to ')
              .addDescriptionOf(resolved)
              .add(' which does not match ')
              .addDescriptionOf(expected);
        }

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
        .add(' which is not a Resolvable or Prop');
  }
}

// =============================================================================
// MOCK BUILD CONTEXT
// =============================================================================

/// Mock BuildContext for testing Mix components
class MockBuildContext extends BuildContext {
  final Set<TokenDefinition>? _tokens;
  final List<Type>? _orderOfModifiers;
  final ThemeData? _themeData;
  MixScope? _mixScope;

  MockBuildContext({
    Set<TokenDefinition>? tokens, 
    List<Type>? orderOfModifiers,
    ThemeData? themeData,
  }) : _tokens = tokens,
       _orderOfModifiers = orderOfModifiers,
       _themeData = themeData {
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
    if (T == Theme && _themeData != null) {
      return Theme(data: _themeData, child: const SizedBox()) as T?;
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
    if (T == Theme && _themeData != null) {
      return Theme(data: _themeData, child: const SizedBox()) as T?;
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

/// Mock attribute for testing utilities - handles `Prop<T>` values
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
    super.widgetModifier,
    super.animation,
  });

  @override
  MockStyle<T> merge(covariant MockStyle<T>? other) {
    if (other == null) return this;
    // For Prop types, use their merge method
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
  StyleSpec<MockSpec<T>> resolve(BuildContext context) {
    final mockSpec = MockSpec<T>(resolvedValue: value);

    return StyleSpec(
      spec: mockSpec,
      animation: $animation,
      widgetModifiers: $widgetModifier?.resolve(context),
    );
  }

  @override
  List<Object?> get props => [value];
}

/// Mock spec for testing purposes
///
/// A simple Spec implementation that holds a resolved value.
/// Used as the target spec for mock attributes.
final class MockSpec<T> extends Spec<MockSpec<T>> with Diagnosticable {
  final T? resolvedValue;

  const MockSpec({this.resolvedValue});

  @override
  MockSpec<T> lerp(MockSpec<T>? other, double t) {
    if (other == null) return this;
    // Simple lerp - just return other for testing
    return MockSpec<T>(resolvedValue: other.resolvedValue);
  }

  @override
  MockSpec<T> copyWith({T? resolvedValue}) {
    return MockSpec<T>(resolvedValue: resolvedValue ?? this.resolvedValue);
  }

  @override
  List<Object?> get props => [resolvedValue];

  StyleSpec<MockSpec<T>> toStyleSpec() {
    return StyleSpec(spec: this);
  }
}

// Test-only extension to simplify access to MockSpec.resolvedValue when wrapped
extension WrappedMockResolvedValue<T> on StyleSpec<MockSpec<T>> {
  T? get resolvedValue => spec.resolvedValue;
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

// =============================================================================
// PROP MATCHERS FOR CLEAN TESTING
// =============================================================================

/// Testing matchers for Prop properties
///
/// Provides clean, descriptive matchers for testing Prop contents without
/// exposing internal source structure.
class PropMatcher {
  /// Matches a Prop that contains a specific value
  static Matcher isValue<T>(T expected) => _PropValueMatcher<T>(expected);

  /// Matches a Prop that contains a specific token
  static Matcher isToken<T>(MixToken<T> expected) =>
      _PropTokenMatcher<T>(expected);

  /// Matches a Prop that contains a specific Mix
  static Matcher isMix<T>(Mix<T> expected) => _PropMixMatcher<T>(expected);

  /// Matches a Prop that has any value sources
  static Matcher get hasValues => const _PropHasValuesMatcher();

  /// Matches a Prop that has any token sources
  static Matcher get hasTokens => const _PropHasTokensMatcher();

  /// Matches a Prop that has any Mix sources
  static Matcher get hasMixes => const _PropHasMixesMatcher();

  /// Matches a Prop that has directives
  static Matcher get hasDirectives => const _PropHasDirectivesMatcher();
}

/// Matcher for Prop values
class _PropValueMatcher<T> extends Matcher {
  final T expected;

  const _PropValueMatcher(this.expected);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop<T>) {
      matchState['error'] = 'Expected Prop<$T>, got ${item.runtimeType}';
      return false;
    }

    final valueSource = item.sources.whereType<ValueSource<T>>().firstOrNull;
    if (valueSource == null) {
      matchState['error'] = 'Prop<$T> does not contain a ValueSource';
      return false;
    }

    return valueSource.value == expected;
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with value ').addDescriptionOf(expected);
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

    if (item is Prop<T>) {
      final valueSource = item.sources.whereType<ValueSource<T>>().firstOrNull;
      if (valueSource != null) {
        return mismatchDescription
            .add('has value ')
            .addDescriptionOf(valueSource.value)
            .add(' instead of ')
            .addDescriptionOf(expected);
      }
    }

    return mismatchDescription.add('is not a Prop with a value');
  }
}

/// Matcher for Prop tokens
class _PropTokenMatcher<T> extends Matcher {
  final MixToken<T> expected;

  const _PropTokenMatcher(this.expected);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop<T>) {
      matchState['error'] = 'Expected Prop<$T>, got ${item.runtimeType}';
      return false;
    }

    final tokenSource = item.sources.whereType<TokenSource<T>>().firstOrNull;
    if (tokenSource == null) {
      matchState['error'] = 'Prop<$T> does not contain a TokenSource';
      return false;
    }

    return tokenSource.token == expected;
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with token ').addDescriptionOf(expected);
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

    if (item is Prop<T>) {
      final tokenSource = item.sources.whereType<TokenSource<T>>().firstOrNull;
      if (tokenSource != null) {
        return mismatchDescription
            .add('has token ')
            .addDescriptionOf(tokenSource.token)
            .add(' instead of ')
            .addDescriptionOf(expected);
      }
    }

    return mismatchDescription.add('is not a Prop with a token');
  }
}

/// Matcher for Prop Mix values
class _PropMixMatcher<T> extends Matcher {
  final Mix<T> expected;

  const _PropMixMatcher(this.expected);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop<T>) {
      matchState['error'] = 'Expected Prop<$T>, got ${item.runtimeType}';
      return false;
    }

    final mixSource = item.sources.whereType<MixSource<T>>().firstOrNull;
    if (mixSource == null) {
      matchState['error'] = 'Prop<$T> does not contain a MixSource';
      return false;
    }

    return mixSource.mix == expected;
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with Mix ').addDescriptionOf(expected);
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

    if (item is Prop<T>) {
      final mixSource = item.sources.whereType<MixSource<T>>().firstOrNull;
      if (mixSource != null) {
        return mismatchDescription
            .add('has Mix ')
            .addDescriptionOf(mixSource.mix)
            .add(' instead of ')
            .addDescriptionOf(expected);
      }
    }

    return mismatchDescription.add('is not a Prop with a Mix');
  }
}

/// Matcher for Prop that has any value sources
class _PropHasValuesMatcher extends Matcher {
  const _PropHasValuesMatcher();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop) {
      matchState['error'] = 'Expected Prop, got ${item.runtimeType}';
      return false;
    }

    return item.sources.any((s) => s is ValueSource);
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with value sources');
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

    return mismatchDescription.add('does not have any value sources');
  }
}

/// Matcher for Prop that has any token sources
class _PropHasTokensMatcher extends Matcher {
  const _PropHasTokensMatcher();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop) {
      matchState['error'] = 'Expected Prop, got ${item.runtimeType}';
      return false;
    }

    return item.sources.any((s) => s is TokenSource);
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with token sources');
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

    return mismatchDescription.add('does not have any token sources');
  }
}

// Test-only helper extensions to access underlying spec fields on StyleSpec
extension WrappedBoxSpecAccess on StyleSpec<BoxSpec> {
  BoxConstraints? get constraints => spec.constraints;
}

extension WrappedFlexBoxSpecAccess on StyleSpec<FlexBoxSpec> {
  FlexSpec? get flex => spec.flex?.spec;
  BoxSpec? get container => spec.box?.spec;
}

extension WrappedIconSpecAccess on StyleSpec<IconSpec> {
  double? get size => spec.size;
}

extension WrappedStackSpecAccess on StyleSpec<StackSpec> {
  AlignmentGeometry? get alignment => spec.alignment;
}

extension WrappedZBoxSpecAccess on StyleSpec<ZBoxSpec> {
  BoxSpec? get box => spec.box?.spec;
  StackSpec? get stack => spec.stack?.spec;
}

/// Matcher for Prop that has any Mix sources
class _PropHasMixesMatcher extends Matcher {
  const _PropHasMixesMatcher();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop) {
      matchState['error'] = 'Expected Prop, got ${item.runtimeType}';
      return false;
    }

    return item.sources.any((s) => s is MixSource);
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with Mix sources');
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

    return mismatchDescription.add('does not have any Mix sources');
  }
}

/// Matcher for Prop that has directives
class _PropHasDirectivesMatcher extends Matcher {
  const _PropHasDirectivesMatcher();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Prop) {
      matchState['error'] = 'Expected Prop, got ${item.runtimeType}';
      return false;
    }

    return item.$directives != null && item.$directives!.isNotEmpty;
  }

  @override
  Description describe(Description description) {
    return description.add('Prop with directives');
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

    return mismatchDescription.add('does not have directives');
  }
}
