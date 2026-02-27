// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import '../stack/stack_spec.dart';
import 'stackbox_spec.dart';
import 'stackbox_style.dart';

/// [StackBox] is equivalent to Flutter's [Stack] and [Container] widgets combined, but provides powerful styling capabilities through the Mix framework.
///
/// [StackBox] enables you to create stacked layouts with visual styles such as decoration, padding, margin, constraints, and box/stack behaviors—all customizable and responsive.
///
/// You can use the [StackBoxStyler] API to fluently compose your layout and decoration styles. Example:
///
/// ```dart
/// final style = StackBoxStyler()
///   .padding(EdgeInsets.all(16))
///   .decoration(
///     BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(12),
///     ),
///   )
///   .alignment(Alignment.center);
///
/// StackBox(
///   children: [
///     Icon(Icons.star, size: 48),
///     Positioned(
///       right: 0,
///       bottom: 0,
///       child: Text('Badge'),
///     ),
///   ],
///   style: style,
/// )
/// ```
class StackBox extends StyleWidget<StackBoxSpec> {
  const StackBox({
    super.style = const StackBoxStyler.create(),
    super.styleSpec,
    super.key,
    this.children = const <Widget>[],
  });

  /// Child widgets to be arranged in the stack layout.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, StackBoxSpec spec) {
    final stackWidget = _createStackSpecWidget(
      spec: spec.stack?.spec,
      children: children,
    );

    if (spec.box != null) {
      return Box(styleSpec: spec.box!, child: stackWidget);
    }

    return stackWidget;
  }
}

/// Creates a [Stack] widget from a [StackSpec] and required parameters.
///
/// Applies all stack layout properties with appropriate default values
/// when specification properties are null.
Stack _createStackSpecWidget({
  required StackSpec? spec,
  List<Widget> children = const [],
}) {
  return Stack(
    alignment: spec?.alignment ?? AlignmentDirectional.topStart,
    textDirection: spec?.textDirection,
    fit: spec?.fit ?? .loose,
    clipBehavior: spec?.clipBehavior ?? .hardEdge,
    children: children,
  );
}
