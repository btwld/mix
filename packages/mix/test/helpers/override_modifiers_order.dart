import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

Future<void> testOverrideModifiersOrder(
  WidgetTester tester, {
  required Widget Function(Style, List<Type>) widgetBuilder,
}) async {
  final style = Style.box(
    modifiers: [
      VisibilityModifierAttribute(visible: true),
      OpacityModifierAttribute(opacity: 1.0),
      TransformModifierAttribute(),
      AspectRatioModifierAttribute(aspectRatio: 2.0),
      AlignModifierAttribute(alignment: Alignment.center),
      PaddingModifierAttribute(padding: EdgeInsetsDirectionalMix(top: 10.0)),
    ],
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
  Style style,
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
