import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

testOverrideModifiersOrder(
  WidgetTester tester, {
  required Widget Function(StyleAttribute, List<Type>) widgetBuilder,
}) async {
  final style = Style(
    VisibilityModifierAttribute(visible: Prop(true)),
    OpacityModifierAttribute(opacity: Prop(1.0)),
    const TransformModifierAttribute(),
    AspectRatioModifierAttribute(aspectRatio: Prop(2.0)),
    AlignModifierAttribute(alignment: Prop(Alignment.center)),
    PaddingModifierAttribute(
      padding: MixProp(EdgeInsetsDirectionalMix.only(top: 10.0)),
    ),
  );
  const orderOfModifiersOnlySpecs = [
    AlignModifier,
    AspectRatioModifier,
    TransformModifier,
    OpacityModifier,
    VisibilityModifier,
  ];

  // JUST SPECS
  await verifyDescendants(
    widgetBuilder(style, orderOfModifiersOnlySpecs),
    style,
    orderOfModifiersOnlySpecs,
    tester,
  );

  // SPECS + ATTRIBUTES
  const orderOfModifiersSpecsAndAttributes = [
    AlignModifier,
    AspectRatioModifierAttribute,
    TransformModifierAttribute,
    OpacityModifier,
    VisibilityModifierAttribute,
  ];
  await verifyDescendants(
    widgetBuilder(style, orderOfModifiersSpecsAndAttributes),
    style,
    orderOfModifiersSpecsAndAttributes,
    tester,
  );

  // JUST ATTRIBUTES
  const orderOfModifiersOnlyAttributes = [
    AlignModifierAttribute,
    AspectRatioModifierAttribute,
    TransformModifierAttribute,
    OpacityModifierAttribute,
    VisibilityModifierAttribute,
  ];

  await verifyDescendants(
    widgetBuilder(style, orderOfModifiersOnlyAttributes),
    style,
    orderOfModifiersOnlyAttributes,
    tester,
  );
}

Future<void> verifyDescendants(
  Widget widget,
  StyleAttribute style,
  List<Type> orderOfModifiers,
  WidgetTester tester,
) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

  expect(find.byType(widget.runtimeType), findsOneWidget);

  expect(
    find.descendant(
      of: find.byType(widget.runtimeType),
      matching: find.byType(Align),
    ),
    findsOneWidget,
  );

  expect(
    find.descendant(of: find.byType(Align), matching: find.byType(AspectRatio)),
    findsOneWidget,
  );

  expect(
    find.descendant(
      of: find.byType(AspectRatio),
      matching: find.byType(Transform),
    ),
    findsOneWidget,
  );

  expect(
    find.descendant(of: find.byType(Transform), matching: find.byType(Opacity)),
    findsOneWidget,
  );

  expect(
    find.descendant(of: find.byType(Opacity), matching: find.byType(Padding)),
    findsOneWidget,
  );
}
