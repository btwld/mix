import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
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
    super.spec,
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
      return Box(spec: boxStyleSpec.spec, child: stack);
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

/// Extension to convert [StackSpec] directly to a [Stack] widget.
extension StackSpecWidget on StackSpec {
  /// Creates a [Stack] widget from this [StackSpec].
  @Deprecated('StackSpec is a component spec. Use ZBox for complete widgets')
  Stack createWidget({List<Widget> children = const []}) {
    return _createStackSpecWidget(spec: this, children: children);
  }

  @Deprecated('StackSpec is a component spec. Use ZBox for complete widgets')
  Stack call({List<Widget> children = const []}) {
    return _createStackSpecWidget(spec: this, children: children);
  }
}

/// Extension to convert [ZBoxSpec] directly to a [ZBox] widget.
extension ZBoxSpecWidget on ZBoxSpec {
  /// Creates a [ZBox] widget from this [ZBoxSpec].
  @Deprecated('Use ZBox(spec: this, children: children) instead')
  Widget createWidget({List<Widget> children = const []}) {
    return ZBox(spec: this, children: children);
  }

  @Deprecated('Use ZBox(spec: this, children: children) instead')
  Widget call({List<Widget> children = const []}) {
    return createWidget(children: children);
  }
}

extension StackSpecWrappedWidget on StyleSpec<StackSpec> {
  /// Creates a widget that resolves this [StyleSpec<StackSpec>] with context.
  @Deprecated(
    'StackSpec is a component spec. Use StyleSpecBuilder directly with ZBoxSpec instead',
  )
  Widget createWidget({List<Widget> children = const []}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createStackSpecWidget(spec: spec, children: children);
      },
      styleSpec: this,
    );
  }

  @Deprecated(
    'StackSpec is a component spec. Use StyleSpecBuilder directly with ZBoxSpec instead',
  )
  Widget call({List<Widget> children = const []}) {
    return createWidget(children: children);
  }
}

extension ZBoxSpecWrappedWidget on StyleSpec<ZBoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<ZBoxSpec>] with context.
  @Deprecated(
    'Use StyleSpecBuilder directly for custom logic, or styleSpec(children: children) for simple cases',
  )
  Widget createWidget({List<Widget> children = const []}) {
    return StyleSpecBuilder<ZBoxSpec>(builder: (context, spec) {
      return ZBox(spec: spec, children: children);
    }, styleSpec: this);
  }

  /// Convenient shorthand for creating a ZBox widget with this StyleSpec.
  Widget call({List<Widget> children = const []}) {
    return StyleSpecBuilder<ZBoxSpec>(builder: (context, spec) {
      return ZBox(spec: spec, children: children);
    }, styleSpec: this);
  }
}
