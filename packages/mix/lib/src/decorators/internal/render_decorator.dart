// ignore_for_file: avoid-dynamic

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/widget_decorator.dart';

/// Renders a widget with applied decorators in the correct order.
@internal
class RenderWidgetDecorators extends StatelessWidget {
  /// Creates a widget that applies [widgetDecorators] to a [child] widget.
  const RenderWidgetDecorators({
    required this.child,
    required this.widgetDecorators,
    super.key,
  });

  /// Widget to which decorators will be applied.
  final Widget child;

  /// List of decorators to apply to the [child].
  final List<WidgetDecorator> widgetDecorators;

  @override
  Widget build(BuildContext context) {
    return _RenderWidgetDecorators(
      decorators: widgetDecorators.reversed,
      child: child,
    );
  }
}

/// Internal widget that iteratively applies decorators to a child widget.
class _RenderWidgetDecorators extends StatelessWidget {
  const _RenderWidgetDecorators({
    required this.child,
    required this.decorators,
  });

  /// Base widget to transform.
  final Widget child;

  /// Decorators to apply in sequence.
  final Iterable<WidgetDecorator> decorators;

  @override
  Widget build(BuildContext context) {
    var current = child;

    // Apply each decorator in sequence
    for (final spec in decorators) {
      current = spec.build(current);
    }

    return current;
  }
}
