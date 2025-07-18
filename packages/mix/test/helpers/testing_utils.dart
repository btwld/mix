// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

export 'package:mix/src/internal/values_ext.dart';

/// Mock BuildContext for testing
class MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    // Provide a minimal MixScope for testing
    if (T == MixScope) {
      return const MixScope(data: MixScopeData.empty(), child: SizedBox())
          as T?;
    }
    return null;
  }

  @override
  InheritedElement?
  getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }
}

/// Create a resolved style for testing
ResolvedStyle<S> createResolvedStyle<S extends Spec<S>>(S spec) {
  return ResolvedStyle(spec: spec);
}

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
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matcher for resolved styles
  static Matcher resolvesTo<T>(Matcher matcher) =>
      _ResolvesToMatcher<T>(matcher);
}

class _ResolvesToMatcher<T> extends CustomMatcher {
  _ResolvesToMatcher(Matcher matcher)
    : super('resolves to', 'resolved value', matcher);

  @override
  Object? featureValueOf(dynamic actual) {
    if (actual is Mix<T>) {
      return actual.resolve(MockBuildContext());
    }
    return actual;
  }
}

/// Test utilities for creating common test data
class TestData {
  static final mockContext = MockBuildContext();

  /// Create a simple BoxSpec for testing
  static BoxSpec createBoxSpec({Color? color, double? width, double? height}) {
    return BoxSpec(width: width, height: height);
  }

  /// Create a simple TextSpec for testing
  static TextSpec createTextSpec({Color? color, double? fontSize}) {
    return TextSpec(
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }
}

/// Helper function for testing Mix resolution
T resolveMix<T>(Mix<T> mix) {
  return mix.resolve(MockBuildContext());
}

/// Helper function for testing style resolution
ResolvedStyle<S> resolveStyle<S extends Spec<S>>(Style<S> style) {
  return style.resolve(MockBuildContext());
}
