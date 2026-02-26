import 'package:flutter/widgets.dart';

import '../engine.dart';
import '../trust/schema_trust.dart';

/// InheritedWidget that provides SchemaEngine and trust configuration.
///
/// Follows TwScope pattern from mix_tailwinds: wraps MixScope + provides
/// schema config.
class SchemaScope extends InheritedWidget {
  final SchemaEngine engine;
  final SchemaTrust trust;

  const SchemaScope({
    super.key,
    required this.engine,
    required this.trust,
    required super.child,
  });

  static SchemaEngine engineOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SchemaScope>();
    assert(scope != null, 'No SchemaScope found in widget tree');
    return scope!.engine;
  }

  static SchemaTrust trustOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SchemaScope>();
    assert(scope != null, 'No SchemaScope found in widget tree');
    return scope!.trust;
  }

  @override
  bool updateShouldNotify(SchemaScope oldWidget) {
    return engine != oldWidget.engine || trust != oldWidget.trust;
  }
}
