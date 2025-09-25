import 'package:flutter/widgets.dart';

import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import 'stack_box_spec.dart';
import 'stack_box_style.dart';
import 'stack_spec.dart';

/// Combines [Container] and [Stack] with Mix styling.
///
/// Creates a stacked layout with box styling capabilities.
class ZBox extends StyleWidget<ZBoxSpec> {
  const ZBox({
    super.style = const StackBoxStyler.create(),
    super.styleSpec,
    this.children = const <Widget>[],
    super.key,
  });


  final List<Widget> children;

  @override
  Widget build(BuildContext context, ZBoxSpec spec) {
    final boxStyleSpec = spec.box;
    final stackStyleSpec = spec.stack;
    final stackSpec = stackStyleSpec?.spec ?? const StackSpec();
    final stack = _createStackSpecWidget(spec: stackSpec, children: children);

    if (boxStyleSpec != null) {
      return Box(styleSpec: boxStyleSpec, child: stack);
    }

    return stack;
  }
}

/// Creates a [Stack] widget from a [StackSpec] and children.
Stack _createStackSpecWidget({
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

extension ZBoxSpecWrappedWidget on StyleSpec<ZBoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<ZBoxSpec>] with context.
  @Deprecated('Use ZBox(children: children, styleSpec: styleSpec) instead')
  Widget createWidget({List<Widget> children = const []}) {
    return call(children: children);
  }

  /// Convenient shorthand for creating a ZBox widget with this StyleSpec.
  @Deprecated('Use ZBox(children: children, styleSpec: styleSpec) instead')
  Widget call({List<Widget> children = const []}) {
    return ZBox(styleSpec: this, children: children);
  }
}
