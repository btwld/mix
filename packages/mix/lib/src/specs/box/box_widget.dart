import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../mix.dart';

part 'box_widget.g.dart';

/// [Box] is equivalent to Flutter's [Container], it provides
/// styling capabilities through the Mix framework. It can be used to
/// create visually styled boxes with decoration, padding, margins, transforms,
/// and constraints.
///
///
/// You can use [BoxStyler] to create styles with a fluent API. Example:
///
/// ```dart
/// final style = BoxStyler()
///   .width(200)
///   .height(100)
///   .color(Colors.blue)
///   .borderRounded(12)
///   .padding(16);
///
/// Box(style: style, child: Text('Hello Mix'))
/// ```
///
class Box extends StyleWidget<BoxSpec> {
  /// Child widget to display inside the box.
  final Widget? child;

  const Box({
    super.style = const BoxStyler.create(),
    super.styleSpec,
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context, BoxSpec spec) {
    return Container(
      alignment: spec.alignment,
      padding: spec.padding,
      decoration: spec.decoration,
      foregroundDecoration: spec.foregroundDecoration,
      constraints: spec.constraints,
      margin: spec.margin,
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior ?? .none,
      child: child,
    );
  }
}

@MixWidget('Card')
final _style = BoxStyler()
    .width(200)
    .height(100)
    .color(Color.fromARGB(255, 255, 251, 251));

@MixWidget('CardV')
final _styleV = FlexBoxStyler()
    .width(200)
    .height(100)
    .color(Color.fromARGB(255, 255, 251, 251));

@MixWidget('CardH')
final _styleH = FlexBoxStyler()
    .width(200)
    .height(100)
    .color(Color.fromARGB(255, 255, 251, 251));

@MixWidget('H1', stylable: true)
final _styleH1 = TextStyler()
    .fontSize(24)
    .fontWeight(.bold)
    .color(Color(0xFF000000));

@MixWidget('Badge', stylable: true)
BoxStyler badge(String label, {Color color = const Color(0xFF000000)}) =>
    BoxStyler()
        .padding(.all(8))
        .borderRadius(.circular(4))
        .color(color)
        .textStyle(
          TextStyler().fontSize(12).fontWeight(.bold).color(Color(0xFFFFFFFF)),
        );
