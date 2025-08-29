import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import '../../core/widget_spec.dart';
import '../../core/style_builder.dart';
import '../box/box_widget.dart';
import 'stack_box_spec.dart';
import 'stack_box_style.dart';
import 'stack_spec.dart';

/// Combines [Container] and [Stack] with Mix styling.
///
/// Creates a stacked layout with box styling capabilities.
class ZBox extends StyleWidget<ZBoxSpec> {
  const ZBox({
    super.style = const StackBoxMix.create(),
    this.children = const <Widget>[],
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, ZBoxSpec spec) {
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

/// Creates a [Container] with [Stack] child from a [ZBoxSpec].
Widget createZBoxSpecWidget({
  required ZBoxSpec spec,
  List<Widget> children = const [],
}) {
  final boxWidgetSpec = spec.box;
  final stackWidgetSpec = spec.stack;
  final stackSpec = stackWidgetSpec?.spec ?? const StackSpec();
  final stack = createStackSpecWidget(spec: stackSpec, children: children);

  if (boxWidgetSpec != null) {
    return createBoxSpecWidget(spec: boxWidgetSpec.spec, child: stack);
  }

  return stack;
}

/// Extension to convert [StackSpec] directly to a [Stack] widget.
extension StackSpecWidget on StackSpec {
  Stack call({List<Widget> children = const []}) {
    return createStackSpecWidget(spec: this, children: children);
  }
}

/// Extension to convert [ZBoxSpec] directly to a styled stack widget.
extension ZBoxSpecWidget on ZBoxSpec {
  Widget call({List<Widget> children = const []}) {
    return createZBoxSpecWidget(spec: this, children: children);
  }
}

extension StackSpecWrappedWidget on WidgetSpec<StackSpec> {
  Widget call({List<Widget> children = const []}) {
    return WidgetSpecBuilder(
      builder: (context, spec) {
        return createStackSpecWidget(spec: spec, children: children);
      },
      wrappedSpec: this,
    );
  }
}

extension ZBoxSpecWrappedWidget on WidgetSpec<ZBoxSpec> {
  Widget call({List<Widget> children = const []}) {
    return WidgetSpecBuilder(
      builder: (context, spec) {
        return createZBoxSpecWidget(spec: spec, children: children);
      },
      wrappedSpec: this,
    );
  }
}
