import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  final style = BoxStyler()
      .color(Colors.red)
      .onHovered(.color(Colors.green))
      .onPressed(.color(Colors.blue));

  Widget styledBox({WidgetStatesController? controller}) {
    return StyleBuilder<BoxSpec>(
      style: style,
      controller: controller,
      builder: (_, spec) => ColoredBox(
        key: const Key('styled-box'),
        color: (spec.decoration as BoxDecoration).color!,
      ),
    );
  }

  Color resolvedColor(WidgetTester tester) {
    return tester.widget<ColoredBox>(find.byKey(const Key('styled-box'))).color;
  }

  testWidgets('override takes precedence over an explicit controller', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.pressed});
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateStyleOverride(
          states: const {WidgetState.hovered},
          child: styledBox(controller: controller),
        ),
      ),
    );

    expect(resolvedColor(tester), Colors.green);
  });

  testWidgets('override supports the scrolledUnder widget state', (
    tester,
  ) async {
    final scrolledUnderStyle = BoxStyler()
        .color(Colors.red)
        .variant(
          WidgetStateVariant(WidgetState.scrolledUnder),
          BoxStyler().color(Colors.green),
        );

    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateStyleOverride(
          states: const {WidgetState.scrolledUnder},
          child: StyleBuilder<BoxSpec>(
            style: scrolledUnderStyle,
            builder: (_, spec) => ColoredBox(
              key: const Key('styled-box'),
              color: (spec.decoration as BoxDecoration).color!,
            ),
          ),
        ),
      ),
    );

    expect(resolvedColor(tester), Colors.green);
  });

  testWidgets('override survives a nested Pressable state provider', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateStyleOverride(
          states: const {WidgetState.pressed},
          child: Pressable(child: styledBox()),
        ),
      ),
    );

    expect(resolvedColor(tester), Colors.blue);
  });

  testWidgets('changing override states rebuilds style resolution', (
    tester,
  ) async {
    final states = ValueNotifier<Set<WidgetState>>(const {});
    addTearDown(states.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<Set<WidgetState>>(
          valueListenable: states,
          builder: (_, value, child) =>
              WidgetStateStyleOverride(states: value, child: child!),
          child: styledBox(),
        ),
      ),
    );
    expect(resolvedColor(tester), Colors.red);

    states.value = const {WidgetState.hovered};
    await tester.pump();

    expect(resolvedColor(tester), Colors.green);
  });

  testWidgets('controller behavior is unchanged without an override', (
    tester,
  ) async {
    final controller = WidgetStatesController({WidgetState.pressed});
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(home: styledBox(controller: controller)),
    );

    expect(resolvedColor(tester), Colors.blue);
  });

  testWidgets('inherited provider behavior is unchanged without an override', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetStateProvider(
          states: const {WidgetState.hovered},
          child: styledBox(),
        ),
      ),
    );

    expect(resolvedColor(tester), Colors.green);
  });
}
