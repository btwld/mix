// ignore_for_file: prefer_relative_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// =============================================================================
// CORE TEST MATCHERS - Mix 2.0
//
// This file provides two core matchers for testing Mix components:
// 1. expectProp() - Tests Prop structure (values, tokens, accumulated values)
// 2. resolvesTo() - Matcher for testing what Resolvable types resolve to
// =============================================================================

/// Tests the structure of a Prop - what it contains (value, token, or accumulated values)
/// 
/// Usage:
/// ```dart
/// // For direct values
/// expectProp(colorProp, Colors.red);  // Matches Prop(Colors.red)
/// 
/// // For Mix values  
/// expectProp(paddingProp, EdgeInsetsMix.all(10));  // Matches Prop(EdgeInsetsMix.all(10))
/// 
/// // For tokens
/// expectProp(colorProp, MixToken<Color>('primary'));  // Matches Prop.token(MixToken<Color>('primary'))
/// 
/// // For accumulated values (merged props)
/// expectProp(mergedProp, [Colors.red, MixToken<Color>('primary'), Colors.blue]);
/// ```
void expectProp<T>(Prop<T>? prop, dynamic expected) {
  if (prop == null) {
    fail('Expected Prop<$T> to exist, but was null');
  }

  final source = prop.source;
  
  if (expected is List) {
    // Expecting accumulated values
    if (source is! AccumulativePropSource<T>) {
      fail('Expected Prop<$T> with accumulated values, but got ${source.runtimeType}');
    }
    
    final actualValues = <dynamic>[];
    for (final s in source.sources) {
      if (s is ValueSource<T>) {
        actualValues.add(s.value);
      } else if (s is TokenSource<T>) {
        actualValues.add(s.token);
      } else {
        fail('Unknown source type in AccumulativePropSource: ${s.runtimeType}');
      }
    }
    
    expect(actualValues, equals(expected),
        reason: 'Prop<$T> accumulated values do not match expected');
  } else if (expected is MixToken<T>) {
    // Expecting a token
    if (source is! TokenSource<T>) {
      fail('Expected Prop<$T> with token, but got ${source.runtimeType}');
    }
    
    expect(source.token, equals(expected),
        reason: 'Prop<$T> token does not match expected');
  } else {
    // Expecting a direct value
    if (source is! ValueSource<T>) {
      fail('Expected Prop<$T> with direct value, but got ${source.runtimeType}');
    }
    
    expect(source.value, equals(expected),
        reason: 'Prop<$T> value does not match expected');
  }
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
///   mixScopeData: MixScopeData.static(tokens: {
///     MixToken<Color>('primary'): Colors.blue,
///   }),
/// );
/// expect(tokenProp, resolvesTo(Colors.blue).withContext(context));
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
    if (item is! Resolvable<T>) {
      matchState['error'] = 'Expected Resolvable<$T>, but got ${item.runtimeType}';
      return false;
    }

    try {
      final ctx = context ?? MockBuildContext();
      final resolved = item.resolve(ctx);
      return resolved == expected;
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

// =============================================================================
// ADDITIONAL TEST UTILITIES
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

  /// Pump widget wrapped in MaterialApp
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(MaterialApp(home: Scaffold(body: widget)));
  }
}

