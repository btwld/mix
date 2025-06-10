import 'package:flutter/widgets.dart';

/// Minimal mock BuildContext for unit tests
/// Only implements methods needed for MixData.create()
class MockBuildContext implements BuildContext {
  @override
  bool get debugDoingBuild => false;

  @override
  bool get mounted => true;

  @override
  InheritedWidget dependOnInheritedElement(InheritedElement ancestor,
      {Object? aspect}) {
    return ancestor.widget as InheritedWidget;
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    return null;
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  @override
  Widget get widget => throw UnimplementedError();

  @override
  BuildOwner? get owner => null;

  @override
  Size? get size => null;

  @override
  RenderObject? findRenderObject() => null;

  // All other methods throw UnimplementedError
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
