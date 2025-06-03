import 'package:flutter/widgets.dart';

import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import '../box/box_spec.dart';
import '../box/box_widget.dart';
import 'stack_spec.dart';

/// [StyledStack] - A styled widget that creates a stack layout with a mix of styles.
///
/// This widget extends [StyledWidget] and is designed to arrange its [children] in a stack,
/// applying the styles defined in a `Style`. It is useful when you need to layer widgets
/// on top of each other and control their styling in a unified manner.
///
/// Parameters:
///   - [children]: The list of widgets to stack on top of each other.
///   - [inherit]: Determines whether the [StyledStack] should inherit styles from its ancestors.
///     Inherits from [StyledWidget].
///   - [key]: The key for the widget. Inherits from [StyledWidget].
///   - [style]: The [Style] to be applied. Inherits from [StyledWidget].
///
/// ## Migration
///
/// Replace `StyledStack` with `ZBox`. The parameters are largely the same.
/// `ZBox` also inherently supports all `Box` attributes like `width`, `height`, `color`, etc.
///
/// ### Before:
/// ```dart
/// StyledStack(
///   style: Style($stack.alignment.center()),
///   children: const [
///     MyWidget1(),
///     MyWidget2(),
///   ],
/// )
/// ```
///
/// ### After:
/// ```dart
/// ZBox(
///   style: Style($stack.alignment.center()),
///   children: const [
///     MyWidget1(),
///     MyWidget2(),
///   ],
/// )
/// ```
@Deprecated(
  'Use ZBox instead. '
  'StyledStack has been replaced with ZBox for better naming consistency. '
  'This widget will be removed in v2.0.0.',
)
class StyledStack extends StyledWidget {
  const StyledStack({
    this.children = const <Widget>[],
    super.inherit,
    super.key,
    super.style,
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // The withMix method applies the current styling context and creates a StackSpecWidget.
    return withMix(context, (context) {
      final spec = StackSpec.of(context);

      return spec(children: children);
    });
  }
}

class StackSpecWidget extends StatelessWidget {
  const StackSpecWidget({
    this.spec,
    this.children,
    this.orderOfModifiers = const [],
    super.key,
  });

  final List<Widget>? children;
  final StackSpec? spec;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    // The Stack widget is used here, applying the resolved styles from StackSpec.
    return RenderSpecModifiers(
      spec: spec ?? const StackSpec(),
      orderOfModifiers: orderOfModifiers,
      child: Stack(
        alignment: spec?.alignment ?? _defaultStack.alignment,
        textDirection: spec?.textDirection,
        fit: spec?.fit ?? _defaultStack.fit,
        clipBehavior: spec?.clipBehavior ?? _defaultStack.clipBehavior,
        children: children ?? const [],
      ),
    );
  }
}

class AnimatedStackSpecWidget extends ImplicitlyAnimatedWidget {
  const AnimatedStackSpecWidget({
    super.key,
    required this.spec,
    required this.children,
    this.orderOfModifiers = const [],
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final StackSpec spec;
  final List<Widget> children;
  final List<Type> orderOfModifiers;

  @override
  AnimatedStackSpecWidgetState createState() => AnimatedStackSpecWidgetState();
}

class AnimatedStackSpecWidgetState
    extends AnimatedWidgetBaseState<AnimatedStackSpecWidget> {
  StackSpecTween? _specTween;

  @override
  // ignore: avoid-dynamic
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _specTween = visitor(
      _specTween,
      widget.spec,
      // ignore: avoid-dynamic
      (dynamic value) => StackSpecTween(begin: value as StackSpec),
    ) as StackSpecTween?;
  }

  @override
  Widget build(BuildContext context) {
    final spec = _specTween!.evaluate(animation);

    return StackSpecWidget(
      spec: spec,
      orderOfModifiers: widget.orderOfModifiers,
      children: widget.children,
    );
  }
}

/// [ZBox] - A styled widget that combines the functionalities of [Box] and [StyledStack].
///
/// This widget is designed to apply a `Style` to a stack layout, making it a combination
/// of a box and a stack. It is ideal for scenarios where you need to create a stacked layout
/// with specific styling and alignment, encapsulated within a box-like structure.
///
/// Parameters:
///   - [children]: The list of widgets to stack and style.
///   - [inherit]: Determines whether the [ZBox] should inherit styles from its ancestors.
///     Inherits from [StyledWidget].
///   - [key]: The key for the widget. Inherits from [StyledWidget].
///   - [style]: The [Style] to be applied. Inherits from [StyledWidget].
class ZBox extends StyledWidget {
  const ZBox({
    this.children = const <Widget>[],
    super.inherit,
    super.key,
    super.style,
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // The withMix method is used to apply the styling context to both the box and the stack.
    return withMix(context, (mix) {
      final boxSpec = BoxSpec.of(mix);
      final stackSpec = StackSpec.of(mix);

      return boxSpec(child: stackSpec(children: children));
    });
  }
}

// Default Stack used as a fallback
// for styling properties in StackSpecWidget.

// TODO: This is a temporary solution to avoid errors with more recent versions of Flutter.
// ignore: prefer_const_constructors
final _defaultStack = Stack();
