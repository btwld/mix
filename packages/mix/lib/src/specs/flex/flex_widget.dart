// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/spec_widget.dart';
import '../../core/animated_spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'flex_spec.dart';

/// A flexible layout widget enhanced with `Style` for simplified styling.
///
/// `StyledFlex` extends the capabilities of the Flutter `Flex` widget by integrating
/// `Style`, allowing for more streamlined styling. This widget is ideal for creating
/// flexible layouts (either rows or columns) with enhanced styling capabilities.
///
/// The `direction` parameter determines the layout orientation, while the `children`
/// parameter takes a list of widgets. The `Style` integration allows for applying
/// consistent styles across all child widgets easily.
///
/// Example Usage:
/// ```dart
/// StyledFlex(
///   direction: Axis.horizontal,
///   style: yourStyle,
///   children: [Widget1(), Widget2(), Widget3()],
/// );
/// ```
@Deprecated(
  'Use FlexBox instead. '
  'StyledFlex has been replaced with FlexBox for better naming consistency. '
  'This widget will be removed in v2.0.0.\n\n'
  'Migration example:\n'
  '// Before\n'
  'StyledFlex(direction: Axis.horizontal, style: myStyle, children: [...])\n'
  '// After\n'
  'FlexBox(direction: Axis.horizontal, style: myStyle, children: [...])',
)
class StyledFlex extends StyledWidget {
  const StyledFlex({
    super.style,
    super.key,
    super.inherit,
    required this.direction,
    this.children = const <Widget>[],
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return withMix(context, (context) {
      final spec = FlexSpec.of(context);

      return spec(direction: direction, children: children);
    });
  }
}

class FlexSpecWidget extends SpecWidget<FlexSpec> {
  const FlexSpecWidget({
    super.key,
    super.spec,
    required this.children,
    required this.direction,
    this.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;
  final List<Type> orderOfModifiers;

  Axis get _definitiveDirection => spec?.direction ?? direction;

  List<Widget> _buildChildren(double? gap) {
    if (gap == null) return children;

    if (children.isEmpty) return [];

    return List.generate(children.length + children.length - 1, (index) {
      if (index.isEven) return children[index ~/ 2];

      return _definitiveDirection == Axis.horizontal
          ? SizedBox(width: gap)
          : SizedBox(height: gap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gap = spec?.gap;
    final flexWidget = Flex(
      direction: _definitiveDirection,
      mainAxisAlignment:
          spec?.mainAxisAlignment ?? _defaultFlex.mainAxisAlignment,
      mainAxisSize: spec?.mainAxisSize ?? _defaultFlex.mainAxisSize,
      crossAxisAlignment:
          spec?.crossAxisAlignment ?? _defaultFlex.crossAxisAlignment,
      textDirection: spec?.textDirection ?? _defaultFlex.textDirection,
      verticalDirection:
          spec?.verticalDirection ?? _defaultFlex.verticalDirection,
      textBaseline: spec?.textBaseline ?? _defaultFlex.textBaseline,
      clipBehavior: spec?.clipBehavior ?? _defaultFlex.clipBehavior,
      children: _buildChildren(gap),
    );

    return spec == null
        ? flexWidget
        : RenderSpecModifiers(
            spec: spec!,
            orderOfModifiers: orderOfModifiers,
            child: flexWidget,
          );
  }
}

class AnimatedFlexSpecWidget extends ImplicitlyAnimatedSpecWidget<FlexSpec> {
  const AnimatedFlexSpecWidget({
    super.key,
    required super.spec,
    required this.children,
    required this.direction,
    this.orderOfModifiers = const [],
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final List<Widget> children;
  final Axis direction;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, FlexSpec animatedSpec) {
    return FlexSpecWidget(
      spec: animatedSpec,
      direction: direction,
      orderOfModifiers: orderOfModifiers,
      children: children,
    );
  }
}

/// A horizontal layout widget leveraging `Style` for advanced styling.
///
/// `StyledRow` is a specialized form of `StyledFlex` that defaults to a horizontal
/// direction (i.e., `Axis.horizontal`). It benefits from `Style` integration,
/// enabling more efficient and consistent styling across its children.
///
/// Inherits all the styling and layout properties of `StyledFlex`, with a simplified
/// interface for horizontal layouts.
///
/// Example Usage:
/// ```dart
/// StyledRow(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
@Deprecated(
  'Use HBox instead. '
  'StyledRow has been replaced with HBox for better naming consistency. '
  'This widget will be removed in v2.0.0.\n\n'
  'Migration example:\n'
  '// Before\n'
  'StyledRow(style: myStyle, children: [...])\n'
  '// After\n'
  'HBox(style: myStyle, children: [...])',
)
class StyledRow extends StyledFlex {
  const StyledRow({
    super.style,
    super.key,
    super.inherit,
    required super.children,
  }) : super(direction: Axis.horizontal);
}

/// A vertical layout widget enhanced with `Style` for easy styling.
///
/// `StyledColumn` is a vertical variant of `StyledFlex`, employing `Style` for
/// an improved styling experience. It's designed for vertical arrangements of widgets,
/// providing a consistent and easy-to-manage styling approach.
///
/// Inherits the comprehensive styling capabilities of `StyledFlex`, tailored for
/// vertical layouts.
///
/// Example Usage:
/// ```dart
/// StyledColumn(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
@Deprecated(
  'Use VBox instead. '
  'StyledColumn has been replaced with VBox for better naming consistency. '
  'This widget will be removed in v2.0.0.\n\n'
  'Migration example:\n'
  '// Before\n'
  'StyledColumn(style: myStyle, children: [...])\n'
  '// After\n'
  'VBox(style: myStyle, children: [...])',
)
class StyledColumn extends StyledFlex {
  const StyledColumn({
    super.style,
    super.key,
    super.inherit,
    super.children,
  }) : super(direction: Axis.vertical);
}

final _defaultFlex = Flex(direction: Axis.horizontal, children: const []);
