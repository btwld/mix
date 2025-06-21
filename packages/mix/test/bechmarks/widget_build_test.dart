// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../helpers/testing_utils.dart';

class _StyledContainerExample extends StatelessWidget {
  const _StyledContainerExample();

  @override
  Widget build(BuildContext context) {
    final paddingAttr = $box.padding(10);
    final marginAttr = $box.margin(15);
    final alignmentAttr = $box.alignment.center();
    final clipAttr = $box.clipBehavior.hardEdge();

    final borderAttribute = $box.border.all(
      color: Colors.red,
      style: BorderStyle.solid,
      width: 1,
    );

    final radiusAttribute = $box.borderRadius(10);

    final colorAttribute = $box.color(Colors.red);

    final style = Style(
      paddingAttr,
      marginAttr,
      alignmentAttr,
      clipAttr,
      borderAttribute,
      radiusAttribute,
      colorAttribute,
    );

    return Box(
      style: style,
      child: const SizedBox(width: 100, height: 100),
    );
  }
}

class ContainerExample extends StatelessWidget {
  const ContainerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(
          color: Colors.red,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(15),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: 100, height: 100),
    );
  }
}

void main() {
  testWidgets('Is fast enough', (WidgetTester tester) async {
    const iterationCount = 10000;

    Future<int> buildWidget(Widget widget) async {
      return await tester.runAsync<int>(() async {
            final stopwatch = Stopwatch()..start();
            for (int i = 0; i < iterationCount; i++) {
              await tester.pumpWidget(widget);
            }
            stopwatch.stop();

            return stopwatch.elapsedMilliseconds;
          }) ??
          0;
    }

    // warm up
    await buildWidget(ContainerExample());
    await buildWidget(_StyledContainerExample());

    final containerTime = await buildWidget(ContainerExample());

    final styledContainerTime = await buildWidget(Box());

    final elapsedStyledContainerTime = styledContainerTime / iterationCount;
    final elapsedContainerTime = containerTime / iterationCount;

    expect(
      elapsedStyledContainerTime,
      lessThan(elapsedContainerTime + 0.4),
      reason:
          'Box is more than 1 percent slower. It is $elapsedStyledContainerTime ms slower, which is ${(((elapsedStyledContainerTime / elapsedContainerTime) * 100) - 100).toStringAsFixed(2)}% slower.',
    );
  });

  // test perfromance for Style.create
  test('Style.create', () {
    const iterations = 10000;
    final stopwatch = Stopwatch()..start();
    Style style = Style();
    for (int i = 0; i < iterations; i++) {
      style = Style.create([
        $box.padding(10),
        $box.margin(15),
        $box.alignment.center(),
        $box.clipBehavior.hardEdge(),
        $box.border.all(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 1,
        ),
        $box.borderRadius(10),
        $box.color(Colors.red),
      ]);
    }
    stopwatch.stop();

    // final elapsedTime = stopwatch.elapsedMilliseconds / iterations;
    expect(style.isNotEmpty, true);
  });

  // test performance for MixData.create
  test('MixData.create', () {
    const iterations = 10000;
    final stopwatch = Stopwatch()..start();
    MixContext mixData = EmptyMixData;
    for (int i = 0; i < iterations; i++) {
      mixData = MixContext.create(
        MockBuildContext(),
        Style(
          $box.padding(10),
          $box.margin(15),
          $box.alignment.center(),
          $box.clipBehavior.hardEdge(),
          $box.border.all(
            color: Colors.red,
            style: BorderStyle.solid,
            width: 1,
          ),
          $box.borderRadius(10),
          $box.color(Colors.red),
        ),
      );
    }

    stopwatch.stop();
    final timeElapsed = stopwatch.elapsedMilliseconds / iterations;

    log('MixData.create: $timeElapsed ms');
    expect(mixData.attributes.isNotEmpty, true);
  });
}

class StyleWidgetExpensiveAttributge extends StatelessWidget {
  const StyleWidgetExpensiveAttributge({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingAttr = $box.padding(10);
    final marginAttr = $box.margin(15);
    final alignmentAttr = $box.alignment.center();
    final clipAttr = $box.clipBehavior.hardEdge();

    final colorAttribute = $box.color(Colors.red);

    Style buildStyle() {
      return Style(
        paddingAttr,
        marginAttr,
        alignmentAttr,
        clipAttr,
        // borderAttribute,
        // radiusAttribute,
        colorAttribute,
      );
    }

    Style mergedStyle = buildStyle();

    // merge 100 times buildStyles()
    for (int i = 0; i < 10000; i++) {
      mergedStyle = mergedStyle.merge(buildStyle());
    }

    return Box(
      style: mergedStyle,
      child: const SizedBox(width: 100, height: 100),
    );
  }
}
