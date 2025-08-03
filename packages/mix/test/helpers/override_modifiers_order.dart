import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

Future<void> testOverrideModifiersOrder(
  WidgetTester tester, {
  required Widget Function(Style, List<Type>) widgetBuilder,
}) async {
  final style = Style.box(
    BoxMix(
      modifierConfig: WidgetDecoratorConfig(
        decorators: [
          VisibilityWidgetDecoratorMix(visible: true),
          OpacityWidgetDecoratorMix(opacity: 1.0),
          TransformWidgetDecoratorMix(),
          AspectRatioWidgetDecoratorMix(aspectRatio: 2.0),
          AlignWidgetDecoratorMix(alignment: Alignment.center),
          PaddingWidgetDecoratorMix(
            padding: EdgeInsetsDirectionalMix(top: 10.0),
          ),
        ],
      ),
    ),
  );
  const orderOfModifiersOnlySpecs = [
    AlignWidgetDecorator,
    AspectRatioWidgetDecorator,
    TransformWidgetDecorator,
    OpacityWidgetDecorator,
    VisibilityWidgetDecorator,
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
    AlignWidgetDecorator,
    AspectRatioWidgetDecoratorMix,
    TransformWidgetDecoratorMix,
    OpacityWidgetDecorator,
    VisibilityWidgetDecoratorMix,
  ];
  await verifyDescendants(
    widgetBuilder(style, orderOfModifiersSpecsAndAttributes),
    style,
    orderOfModifiersSpecsAndAttributes,
    tester,
  );

  // JUST ATTRIBUTES
  const orderOfModifiersOnlyAttributes = [
    AlignWidgetDecoratorMix,
    AspectRatioWidgetDecoratorMix,
    TransformWidgetDecoratorMix,
    OpacityWidgetDecoratorMix,
    VisibilityWidgetDecoratorMix,
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
