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

// FlexBox Example
class _StyledFlexExample extends StatelessWidget {
  const _StyledFlexExample();

  @override
  Widget build(BuildContext context) {
    return FlexBox(
      style: Style(
        $flex.direction.row(),
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// Row Example (Flutter Native)
class RowExample extends StatelessWidget {
  const RowExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 10), // Gap
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// HBox Example
class _HBoxExample extends StatelessWidget {
  const _HBoxExample();

  @override
  Widget build(BuildContext context) {
    return HBox(
      style: Style(
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// VBox Example
class _VBoxExample extends StatelessWidget {
  const _VBoxExample();

  @override
  Widget build(BuildContext context) {
    return VBox(
      style: Style(
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// Column Example (Flutter Native)
class ColumnExample extends StatelessWidget {
  const ColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(height: 10), // Gap
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// ZBox Example
class _ZBoxExample extends StatelessWidget {
  const _ZBoxExample();

  @override
  Widget build(BuildContext context) {
    return ZBox(
      style: Style(
        $stack.alignment.center(),
      ),
      children: const [
        SizedBox(width: 100, height: 100, child: ColoredBox(color: Colors.red)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.yellow)),
      ],
    );
  }
}

// Stack Example (Flutter Native)
class StackExample extends StatelessWidget {
  const StackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        SizedBox(width: 100, height: 100, child: ColoredBox(color: Colors.red)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.yellow)),
      ],
    );
  }
}

// Deprecated StyledFlex for comparison
class _DeprecatedStyledFlexExample extends StatelessWidget {
  const _DeprecatedStyledFlexExample();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    return StyledFlex(
      direction: Axis.horizontal,
      style: Style(
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// Deprecated StyledRow for comparison
class _DeprecatedStyledRowExample extends StatelessWidget {
  const _DeprecatedStyledRowExample();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    return StyledRow(
      style: Style(
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// Deprecated StyledColumn for comparison
class _DeprecatedStyledColumnExample extends StatelessWidget {
  const _DeprecatedStyledColumnExample();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    return StyledColumn(
      style: Style(
        $flex.mainAxisAlignment.center(),
        $flex.crossAxisAlignment.center(),
        $flex.gap(10),
      ),
      children: const [
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.blue)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.green)),
      ],
    );
  }
}

// Deprecated StyledStack for comparison
class _DeprecatedStyledStackExample extends StatelessWidget {
  const _DeprecatedStyledStackExample();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    return StyledStack(
      style: Style(
        $stack.alignment.center(),
      ),
      children: const [
        SizedBox(width: 100, height: 100, child: ColoredBox(color: Colors.red)),
        SizedBox(width: 50, height: 50, child: ColoredBox(color: Colors.yellow)),
      ],
    );
  }
}

void main() {
  const iterationCount = 1000; // Reduced for faster test runs, increase for more accuracy
  group('Widget Build Benchmarks', () {
    Future<double> benchmarkWidget(WidgetTester tester, Widget widget) async {
      // Warm up
      for (int i = 0; i < 100; i++) {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      }
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < iterationCount; i++) {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      }
      stopwatch.stop();
      return stopwatch.elapsedMicroseconds / iterationCount;
    }

    testWidgets('Container vs Box', (WidgetTester tester) async {
      final containerTime = await benchmarkWidget(tester, const ContainerExample());
      final boxTime = await benchmarkWidget(tester, const _StyledContainerExample());

      log('Avg Container build time: ${containerTime.toStringAsFixed(2)} µs');
      log('Avg Box build time: ${boxTime.toStringAsFixed(2)} µs');
      expect(boxTime, lessThan(containerTime * 1.5),
          reason: 'Box should not be significantly slower than Container.');
    });

    testWidgets('Row vs FlexBox vs HBox', (WidgetTester tester) async {
      final rowTime = await benchmarkWidget(tester, const RowExample());
      final flexBoxTime = await benchmarkWidget(tester, const _StyledFlexExample());
      final hBoxTime = await benchmarkWidget(tester, const _HBoxExample());
      final deprecatedStyledFlexTime = await benchmarkWidget(tester, const _DeprecatedStyledFlexExample());
      final deprecatedStyledRowTime = await benchmarkWidget(tester, const _DeprecatedStyledRowExample());

      log('Avg Row build time: ${rowTime.toStringAsFixed(2)} µs');
      log('Avg FlexBox build time: ${flexBoxTime.toStringAsFixed(2)} µs');
      log('Avg HBox build time: ${hBoxTime.toStringAsFixed(2)} µs');
      log('Avg DeprecatedStyledFlex build time: ${deprecatedStyledFlexTime.toStringAsFixed(2)} µs');
      log('Avg DeprecatedStyledRow build time: ${deprecatedStyledRowTime.toStringAsFixed(2)} µs');

      expect(flexBoxTime, lessThan(rowTime * 1.5),
          reason: 'FlexBox should not be significantly slower than Row.');
      expect(hBoxTime, lessThan(rowTime * 1.5),
          reason: 'HBox should not be significantly slower than Row.');
    });

    testWidgets('Column vs VBox', (WidgetTester tester) async {
      final columnTime = await benchmarkWidget(tester, const ColumnExample());
      final vBoxTime = await benchmarkWidget(tester, const _VBoxExample());
      final deprecatedStyledColumnTime = await benchmarkWidget(tester, const _DeprecatedStyledColumnExample());

      log('Avg Column build time: ${columnTime.toStringAsFixed(2)} µs');
      log('Avg VBox build time: ${vBoxTime.toStringAsFixed(2)} µs');
      log('Avg DeprecatedStyledColumn build time: ${deprecatedStyledColumnTime.toStringAsFixed(2)} µs');

      expect(vBoxTime, lessThan(columnTime * 1.5),
          reason: 'VBox should not be significantly slower than Column.');
    });

    testWidgets('Stack vs ZBox', (WidgetTester tester) async {
      final stackTime = await benchmarkWidget(tester, const StackExample());
      final zBoxTime = await benchmarkWidget(tester, const _ZBoxExample());
      final deprecatedStyledStackTime = await benchmarkWidget(tester, const _DeprecatedStyledStackExample());

      log('Avg Stack build time: ${stackTime.toStringAsFixed(2)} µs');
      log('Avg ZBox build time: ${zBoxTime.toStringAsFixed(2)} µs');
      log('Avg DeprecatedStyledStack build time: ${deprecatedStyledStackTime.toStringAsFixed(2)} µs');
      expect(zBoxTime, lessThan(stackTime * 1.5),
          reason: 'ZBox should not be significantly slower than Stack.');
    });
  });

  // test perfromance for Style.create
  test('Style.create', () {
    const iterations = 10000;
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
    MixData mixData = EmptyMixData;
    for (int i = 0; i < iterations; i++) {
      mixData = MixData.create(
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
