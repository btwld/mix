import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import 'stack_box_attribute.dart';
import 'stack_box_spec.dart';
import 'stack_spec.dart';

/// Combines [Container] and [Stack] with Mix styling.
///
/// Creates a stacked layout with box styling capabilities.
class ZBox extends StyleWidget<ZBoxWidgetSpec> {
  const ZBox({
    super.style = const StackBoxMix.create(),
    this.children = const <Widget>[],
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, ZBoxWidgetSpec spec) {
    return createZBoxSpecWidget(spec: spec, children: children);
  }
}

/// Creates a [Stack] widget from a [StackSpec] and children.
Stack createStackSpecWidget({
  required StackSpec spec,
  List<Widget> children = const [],
}) {
  return Stack(
    alignment: spec.alignment ?? AlignmentDirectional.topStart,
    textDirection: spec.textDirection,
    fit: spec.fit ?? StackFit.loose,
    clipBehavior: spec.clipBehavior ?? Clip.hardEdge,
    children: children,
  );
}

/// Creates a [Container] with [Stack] child from a [ZBoxWidgetSpec].
Widget createZBoxSpecWidget({
  required ZBoxWidgetSpec spec,
  List<Widget> children = const [],
}) {
  return createBoxSpecWidget(
    spec: spec.box,
    child: createStackSpecWidget(spec: spec.stack, children: children),
  );
}

/// Extension to convert [StackSpec] directly to a [Stack] widget.
extension StackSpecWidget on StackSpec {
  Stack call({List<Widget> children = const []}) {
    return createStackSpecWidget(spec: this, children: children);
  }
}

/// Extension to convert [ZBoxWidgetSpec] directly to a styled stack widget.
extension ZBoxSpecWidget on ZBoxWidgetSpec {
  Widget call({List<Widget> children = const []}) {
    return createZBoxSpecWidget(spec: this, children: children);
  }
}
