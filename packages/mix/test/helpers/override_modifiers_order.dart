import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

testOverrideModifiersOrder(
  WidgetTester tester, {
  required Widget Function(Style, List<Type>) widgetBuilder,
}) async {
  final style = Style(
    const VisibilityModifierSpecAttribute(visible: true),
    const OpacityModifierSpecAttribute(opacity: 1),
    const TransformModifierSpecAttribute(),
    const AspectRatioModifierSpecAttribute(aspectRatio: 2),
    const ClipOvalModifierSpecAttribute(),
    PaddingModifierSpecAttribute(padding: EdgeInsetsDirectionalDto(top: 10)),
  );
  const orderOfModifiersOnlySpecs = [
    ClipOvalModifierSpec,
    AspectRatioModifierSpec,
    TransformModifierSpec,
    OpacityModifierSpec,
    VisibilityModifierSpec,
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
    ClipOvalModifierSpec,
    AspectRatioModifierSpecAttribute,
    TransformModifierSpecAttribute,
    OpacityModifierSpec,
    VisibilityModifierSpecAttribute,
  ];
  await verifyDescendants(
    widgetBuilder(style, orderOfModifiersSpecsAndAttributes),
    style,
    orderOfModifiersSpecsAndAttributes,
    tester,
  );

  // JUST ATTRIBUTES
  const orderOfModifiersOnlyAttributes = [
    ClipOvalModifierSpecAttribute,
    AspectRatioModifierSpecAttribute,
    TransformModifierSpecAttribute,
    OpacityModifierSpecAttribute,
    VisibilityModifierSpecAttribute,
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
  await tester.pumpMaterialApp(
    widget,
  );

  expect(find.byType(widget.runtimeType), findsOneWidget);

  expect(
    find.descendant(
      of: find.byType(widget.runtimeType),
      matching: find.byType(ClipOval),
    ),
    findsOneWidget,
  );

  expect(
    find.descendant(
      of: find.byType(ClipOval),
      matching: find.byType(AspectRatio),
    ),
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
    find.descendant(
      of: find.byType(Transform),
      matching: find.byType(Opacity),
    ),
    findsOneWidget,
  );

  expect(
    find.descendant(
      of: find.byType(Opacity),
      matching: find.byType(Padding),
    ),
    findsOneWidget,
  );
}
