import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'test_helpers.dart';

Future<StyleSpec<T>> _resolveStyle<T extends Spec<T>>(
  WidgetTester tester,
  Style<T> style, {
  double width = 800,
  double height = 800,
  Brightness brightness = Brightness.light,
  Set<WidgetState> states = const {},
}) async {
  StyleSpec<T>? resolved;

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        platformBrightness: brightness,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
          child: WidgetStateProvider(
            states: states,
            child: Builder(
              builder: (context) {
              resolved = style.build(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return resolved!;
}

Future<BoxSpec> _resolveBoxSpec(
  WidgetTester tester,
  TwParser parser,
  String classNames, {
  double width = 800,
  double height = 800,
  Brightness brightness = Brightness.light,
  Set<WidgetState> states = const {},
}) {
  final styler = parser.parseBox(classNames);
  return _resolveStyle<BoxSpec>(
    tester,
    styler,
    width: width,
    height: height,
    brightness: brightness,
    states: states,
  ).then((spec) => spec.spec);
}

Future<FlexBoxSpec> _resolveFlexSpec(
  WidgetTester tester,
  TwParser parser,
  String classNames, {
  double width = 800,
  double height = 800,
  Brightness brightness = Brightness.light,
  Set<WidgetState> states = const {},
}) {
  final styler = parser.parseFlex(classNames);
  return _resolveStyle<FlexBoxSpec>(
    tester,
    styler,
    width: width,
    height: height,
    brightness: brightness,
    states: states,
  ).then((spec) => spec.spec);
}

class _BorderSnapshot {
  const _BorderSnapshot(this.top, this.right, this.bottom, this.left);

  final BorderSide top;
  final BorderSide right;
  final BorderSide bottom;
  final BorderSide left;
}

_BorderSnapshot _extractBorder(BoxSpec spec) {
  final boxDecoration = spec.decoration as BoxDecoration?;
  final border = boxDecoration?.border;

  if (border is Border) {
    return _BorderSnapshot(
      border.top,
      border.right,
      border.bottom,
      border.left,
    );
  }

  if (border is BorderDirectional) {
    return _BorderSnapshot(
      border.top,
      border.end,
      border.bottom,
      border.start,
    );
  }

  return const _BorderSnapshot(
    BorderSide.none,
    BorderSide.none,
    BorderSide.none,
    BorderSide.none,
  );
}

void main() {
  group('Token Extraction', () {
    testWidgets('handles simple tokens without prefix', (tester) async {
      final helper = ParserTestHelper();
      final spec = await _resolveBoxSpec(tester, helper.parser, 'bg-blue-500');
      final decoration = spec.decoration as BoxDecoration?;

      expect(decoration?.color, helper.parser.config.colorOf('blue-500'));
      helper.expectNoWarnings();
    });

    testWidgets('handles single prefix', (tester) async {
      final helper = ParserTestHelper();

      final baseSpec =
          await _resolveBoxSpec(tester, helper.parser, 'hover:bg-blue-500');

      expect((baseSpec.decoration as BoxDecoration?)?.color, isNull);

      final hoverSpec = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:bg-blue-500',
        states: {WidgetState.hovered},
      );

      expect(
        (hoverSpec.decoration as BoxDecoration?)?.color,
        helper.parser.config.colorOf('blue-500'),
      );
      helper.expectNoWarnings();
    });

    testWidgets('handles variant chains', (tester) async {
      final helper = ParserTestHelper();

      final below = await _resolveBoxSpec(
        tester,
        helper.parser,
        'md:hover:bg-blue-500',
        width: 600,
        states: {WidgetState.hovered},
      );
      expect((below.decoration as BoxDecoration?)?.color, isNull);

      final above = await _resolveBoxSpec(
        tester,
        helper.parser,
        'md:hover:bg-blue-500',
        width: 800,
        states: {WidgetState.hovered},
      );

      expect(
        (above.decoration as BoxDecoration?)?.color,
        helper.parser.config.colorOf('blue-500'),
      );
      helper.expectNoWarnings();
    });

    testWidgets('handles deep variant chains', (tester) async {
      final helper = ParserTestHelper();

      final lightHover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'md:hover:dark:bg-blue-500',
        width: 800,
        states: {WidgetState.hovered},
        brightness: Brightness.light,
      );

      expect((lightHover.decoration as BoxDecoration?)?.color, isNull);

      final darkHover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'md:hover:dark:bg-blue-500',
        width: 800,
        states: {WidgetState.hovered},
        brightness: Brightness.dark,
      );

      expect(
        (darkHover.decoration as BoxDecoration?)?.color,
        helper.parser.config.colorOf('blue-500'),
      );

      final belowBreakpoint = await _resolveBoxSpec(
        tester,
        helper.parser,
        'md:hover:dark:bg-blue-500',
        width: 600,
        states: {WidgetState.hovered},
        brightness: Brightness.dark,
      );

      expect((belowBreakpoint.decoration as BoxDecoration?)?.color, isNull);
      helper.expectNoWarnings();
    });

    testWidgets('handles negative tokens', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(
        tester,
        helper.parser,
        '-rotate-45',
      );

      expect(spec.transform, isNotNull);

      final vector = vm.Vector3(1, 0, 0);
      spec.transform!.transform3(vector);

      final expected = math.sqrt(2) / 2;
      expect(vector.x, closeTo(expected, 1e-6));
      expect(vector.y, closeTo(-expected, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets('handles prefixed negative tokens', (tester) async {
      final helper = ParserTestHelper();

      final base = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:-translate-x-4',
      );

      expect(base.transform, isNotNull);
      final baseVector = vm.Vector3.zero();
      base.transform!.transform3(baseVector);
      expect(baseVector.x, closeTo(0, 1e-6));
      expect(baseVector.y, closeTo(0, 1e-6));

      final hover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:-translate-x-4',
        states: {WidgetState.hovered},
      );

      final hoverVector = vm.Vector3.zero();
      hover.transform!.transform3(hoverVector);

      expect(hoverVector.x, closeTo(-16, 1e-6));
      expect(hoverVector.y, closeTo(0, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets('handles token with no colon', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveFlexSpec(tester, helper.parser, 'flex');

      expect(spec.flex?.spec.direction, Axis.horizontal);
      helper.expectNoWarnings();
    });

    test('handles edge case: empty string', () {
      final helper = ParserTestHelper();

      expect(helper.parser.listTokens(''), isEmpty);
      helper.expectNoWarnings();
    });

    test('handles edge case: whitespace-only', () {
      final helper = ParserTestHelper();

      expect(helper.parser.listTokens('   '), isEmpty);
      helper.expectNoWarnings();
    });

    testWidgets('handles edge case: token is just a colon', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, ':');
      expect(spec.decoration, isNull);
      helper.expectWarning(':');
    });

    testWidgets('handles edge case: leading colon', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, ':bg-blue-500');
      expect(spec.decoration, isNull);
      helper.expectWarning(':bg-blue-500');
    });

    testWidgets('handles edge case: trailing colon', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, 'hover:');
      expect(spec.decoration, isNull);
      expect(helper.unsupported, contains(''));
    });
  });

  group('Longest-Prefix Match Priority', () {
    testWidgets('gap-x-4 matches gap-x- not gap-', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Div(
            classNames: 'flex gap-x-4',
            children: const [SizedBox(), SizedBox()],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);
      expect(flex.spacing, 16);
    });

    testWidgets('gap-y-4 matches gap-y- not gap-', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Div(
            classNames: 'flex-col gap-y-4',
            children: const [SizedBox(), SizedBox()],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);
      expect(flex.spacing, 16);
    });

    testWidgets('border-t-2 matches border-t- not border-', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, 'border-t-2');
      final border =
          (spec.decoration as BoxDecoration?)?.border as Border?;

      expect(border?.top.width, 2);
      expect(border?.right.width, 0);
      expect(border?.bottom.width, 0);
      expect(border?.left.width, 0);
      helper.expectNoWarnings();
    });

    testWidgets('border-x-2 matches border-x- not border-', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, 'border-x-2');
      final border =
          (spec.decoration as BoxDecoration?)?.border as Border?;

      expect(border?.left.width, 2);
      expect(border?.right.width, 2);
      expect(border?.top.width, 0);
      expect(border?.bottom.width, 0);
      helper.expectNoWarnings();
    });

    testWidgets('translate-x-4 matches translate-x- not translate-', (
      tester,
    ) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(
        tester,
        helper.parser,
        'translate-x-4',
      );

      final vector = vm.Vector3.zero();
      spec.transform!.transform3(vector);

      expect(vector.x, closeTo(16, 1e-6));
      expect(vector.y, closeTo(0, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets('rounded-t-lg matches rounded-t- not rounded-', (
      tester,
    ) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(
        tester,
        helper.parser,
        'rounded-t-lg',
      );
      final decoration = spec.decoration as BoxDecoration?;
      final radius = decoration?.borderRadius as BorderRadius?;

      expect(
        radius?.topLeft,
        Radius.circular(helper.parser.config.radiusOf('lg')),
      );
      expect(
        radius?.topRight,
        Radius.circular(helper.parser.config.radiusOf('lg')),
      );
      expect(radius?.bottomLeft, Radius.zero);
      expect(radius?.bottomRight, Radius.zero);
      helper.expectNoWarnings();
    });

    testWidgets('px-4 matches px- not p-', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(tester, helper.parser, 'px-4');
      final padding = spec.padding as EdgeInsets?;

      expect(
        padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      );
      helper.expectNoWarnings();
    });
  });

  group('Transform Identity Injection', () {
    testWidgets('hover:scale-105 injects scale-100 base', (tester) async {
      final helper = ParserTestHelper();

      final base = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:scale-105',
      );
      final baseVec = vm.Vector3(1, 0, 0);
      (base.transform ?? vm.Matrix4.identity()).transform3(baseVec);

      expect(baseVec.x, closeTo(1.0, 1e-6));
      expect(baseVec.y, closeTo(0.0, 1e-6));

      final hover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:scale-105',
        states: {WidgetState.hovered},
      );
      final hoverVec = vm.Vector3(1, 0, 0);
      hover.transform!.transform3(hoverVec);

      expect(hoverVec.x, closeTo(1.05, 1e-6));
      expect(hoverVec.y, closeTo(0.0, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets('hover:rotate-3 without base starts from rotate-0', (
      tester,
    ) async {
      final helper = ParserTestHelper();

      final base = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:rotate-3',
      );
      final baseVec = vm.Vector3(1, 0, 0);
      (base.transform ?? vm.Matrix4.identity()).transform3(baseVec);
      expect(baseVec.x, closeTo(1.0, 1e-6));
      expect(baseVec.y, closeTo(0.0, 1e-6));

      final hover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'hover:rotate-3',
        states: {WidgetState.hovered},
      );
      final hoverVec = vm.Vector3(1, 0, 0);
      hover.transform!.transform3(hoverVec);

      final cos3 = math.cos(3 * math.pi / 180);
      final sin3 = math.sin(3 * math.pi / 180);
      expect(hoverVec.x, closeTo(cos3, 1e-6));
      expect(hoverVec.y, closeTo(sin3, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets('base scale-100 + hover:rotate-45 composes correctly', (
      tester,
    ) async {
      final helper = ParserTestHelper();

      final base = await _resolveBoxSpec(
        tester,
        helper.parser,
        'scale-100 hover:rotate-45',
      );
      final baseVec = vm.Vector3(1, 0, 0);
      base.transform!.transform3(baseVec);
      expect(baseVec.x, closeTo(1.0, 1e-6));
      expect(baseVec.y, closeTo(0.0, 1e-6));

      final hover = await _resolveBoxSpec(
        tester,
        helper.parser,
        'scale-100 hover:rotate-45',
        states: {WidgetState.hovered},
      );
      final hoverVec = vm.Vector3(1, 0, 0);
      hover.transform!.transform3(hoverVec);

      final expected = math.sqrt(2) / 2;
      expect(hoverVec.x, closeTo(expected, 1e-6));
      expect(hoverVec.y, closeTo(expected, 1e-6));
      helper.expectNoWarnings();
    });

    testWidgets(
      'hover:scale-110 hover:rotate-3 combines in hover state',
      (tester) async {
        final helper = ParserTestHelper();

        final base = await _resolveBoxSpec(
          tester,
          helper.parser,
          'hover:scale-110 hover:rotate-3',
        );
        final baseVec = vm.Vector3(1, 0, 0);
        (base.transform ?? vm.Matrix4.identity()).transform3(baseVec);
        expect(baseVec.x, closeTo(1.0, 1e-6));
        expect(baseVec.y, closeTo(0.0, 1e-6));

        final hover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'hover:scale-110 hover:rotate-3',
          states: {WidgetState.hovered},
        );
        final hoverVec = vm.Vector3(1, 0, 0);
        hover.transform!.transform3(hoverVec);

        final cos3 = math.cos(3 * math.pi / 180);
        final sin3 = math.sin(3 * math.pi / 180);
        expect(hoverVec.x, closeTo(cos3 * 1.1, 1e-6));
        expect(hoverVec.y, closeTo(sin3 * 1.1, 1e-6));
        helper.expectNoWarnings();
      },
    );

    testWidgets(
      'scale-100 hover:scale-105 md:hover:scale-110 chains correctly',
      (tester) async {
        final helper = ParserTestHelper();

        final base = await _resolveBoxSpec(
          tester,
          helper.parser,
          'scale-100 hover:scale-105 md:hover:scale-110',
        );
        final baseVec = vm.Vector3(1, 0, 0);
        base.transform!.transform3(baseVec);
        expect(baseVec.x, closeTo(1.0, 1e-6));
        expect(baseVec.y, closeTo(0.0, 1e-6));

        final hover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'scale-100 hover:scale-105 md:hover:scale-110',
          width: 600,
          states: {WidgetState.hovered},
        );
        final hoverVec = vm.Vector3(1, 0, 0);
        hover.transform!.transform3(hoverVec);
        expect(hoverVec.x, closeTo(1.05, 1e-6));
        expect(hoverVec.y, closeTo(0.0, 1e-6));

        final mdHover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'scale-100 hover:scale-105 md:hover:scale-110',
        width: 800,
        states: {WidgetState.hovered},
      );
      final mdHoverVec = vm.Vector3(1, 0, 0);
      mdHover.transform!.transform3(mdHoverVec);
      expect(mdHoverVec.x, closeTo(1.05, 1e-6));
      expect(mdHoverVec.y, closeTo(0.0, 1e-6));
      helper.expectNoWarnings();
    },
    );

    testWidgets(
      'translate-x-4 hover:translate-y-4 inherits x translation',
      (tester) async {
        final helper = ParserTestHelper();

        final base = await _resolveBoxSpec(
          tester,
          helper.parser,
          'translate-x-4 hover:translate-y-4',
        );
        final baseVec = vm.Vector3.zero();
        base.transform!.transform3(baseVec);
        expect(baseVec.x, closeTo(16, 1e-6));
        expect(baseVec.y, closeTo(0, 1e-6));

        final hover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'translate-x-4 hover:translate-y-4',
          states: {WidgetState.hovered},
        );
        final hoverVec = vm.Vector3.zero();
        hover.transform!.transform3(hoverVec);
        expect(hoverVec.x, closeTo(16, 1e-6));
        expect(hoverVec.y, closeTo(16, 1e-6));
        helper.expectNoWarnings();
      },
    );
  });

  group('Border Inheritance Order', () {
    testWidgets(
      'border-2 border-t-4 applies 2px to all sides, 4px to top',
      (tester) async {
        final helper = ParserTestHelper();

        final spec = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border-2 border-t-4',
        );
        final border = _extractBorder(spec);

        expect(border.top.width, 4);
        expect(border.right.width, 2);
        expect(border.bottom.width, 2);
        expect(border.left.width, 2);
        helper.expectNoWarnings();
      },
    );

    testWidgets(
      'border-t-4 border-2 applies 2px to all sides (last wins)',
      (tester) async {
        final helper = ParserTestHelper();

        final spec = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border-t-4 border-2',
        );
        final border = _extractBorder(spec);

        expect(border.top.width, 2);
        expect(border.right.width, 2);
        expect(border.bottom.width, 2);
        expect(border.left.width, 2);
        helper.expectNoWarnings();
      },
    );

    testWidgets(
      'border-red-500 border-t-blue-500 colors correctly',
      (tester) async {
        final helper = ParserTestHelper();

        final spec = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border border-red-500 border-t-blue-500',
        );
        final border = _extractBorder(spec);

        expect(
          border.top.color,
          helper.parser.config.colorOf('blue-500'),
        );
        expect(
          border.right.color,
          helper.parser.config.colorOf('blue-500'),
        );
        expect(
          border.bottom.color,
          helper.parser.config.colorOf('blue-500'),
        );
        expect(
          border.left.color,
          helper.parser.config.colorOf('blue-500'),
        );
        helper.expectNoWarnings();
      },
    );

    testWidgets(
      'hover:border-2 inherits base border color',
      (tester) async {
        final helper = ParserTestHelper();

        final base = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border border-red-500 hover:border-2',
        );
        final baseBorder = _extractBorder(base);
        expect(baseBorder.top.width, 1);
        expect(baseBorder.top.color, helper.parser.config.colorOf('red-500'));

        final hover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border border-red-500 hover:border-2',
          states: {WidgetState.hovered},
        );
        final hoverBorder = _extractBorder(hover);
        expect(hoverBorder.top.width, 2);
        expect(hoverBorder.top.color, helper.parser.config.colorOf('red-500'));
        helper.expectNoWarnings();
      },
    );

    testWidgets('border-x-2 border-y-4 applies correctly', (tester) async {
      final helper = ParserTestHelper();

      final spec = await _resolveBoxSpec(
        tester,
        helper.parser,
        'border-x-2 border-y-4',
      );
      final border = _extractBorder(spec);

      expect(border.left.width, 2);
      expect(border.right.width, 2);
      expect(border.top.width, 4);
      expect(border.bottom.width, 4);
      helper.expectNoWarnings();
    });

    testWidgets(
      'hover:border-blue-500 only changes color, not width',
      (tester) async {
        final helper = ParserTestHelper();

        final base = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border-2 hover:border-blue-500',
        );
        final baseBorder = _extractBorder(base);
        expect(baseBorder.top.width, 2);

        final hover = await _resolveBoxSpec(
          tester,
          helper.parser,
          'border-2 hover:border-blue-500',
          states: {WidgetState.hovered},
        );
        final hoverBorder = _extractBorder(hover);
        expect(hoverBorder.top.width, 2);
        expect(
          hoverBorder.top.color,
          helper.parser.config.colorOf('blue-500'),
        );
        helper.expectNoWarnings();
      },
    );
  });

  group('Flex Breakpoint Defaults', () {
    testWidgets(
      'md:flex-row stays row below md breakpoint (current behavior)',
      (tester) async {
        await pumpSized(
          tester,
          const Div(classNames: 'flex md:flex-row', children: [SizedBox()]),
          width: 600,
        );

        final flex = tester.widget<Flex>(find.byType(Flex));
        expect(flex.direction, Axis.horizontal);
      },
    );

    testWidgets(
      'md:flex-row switches to row at md breakpoint',
      (tester) async {
        await pumpSized(
          tester,
          const Div(classNames: 'flex md:flex-row', children: [SizedBox()]),
          width: 800,
        );

        final flex = tester.widget<Flex>(find.byType(Flex));
        expect(flex.direction, Axis.horizontal);
      },
    );

    testWidgets(
      'flex md:flex-col maintains flex below breakpoint',
      (tester) async {
        await pumpSized(
          tester,
          const Div(classNames: 'flex md:flex-col', children: [SizedBox()]),
          width: 600,
        );

        final flex = tester.widget<Flex>(find.byType(Flex));
        expect(flex.direction, Axis.horizontal);
      },
    );

    testWidgets(
      'flex-row md:flex-col switches directions at breakpoint',
      (tester) async {
        await pumpSized(
          tester,
          const Div(classNames: 'flex-row md:flex-col', children: [SizedBox()]),
          width: 600,
        );
        final flexSmall = tester.widget<Flex>(find.byType(Flex));
        expect(flexSmall.direction, Axis.horizontal);

        await pumpSized(
          tester,
          const Div(classNames: 'flex-row md:flex-col', children: [SizedBox()]),
          width: 800,
        );
        final flexLarge = tester.widget<Flex>(find.byType(Flex));
        expect(flexLarge.direction, Axis.vertical);
      },
    );

    testWidgets('sm:flex lg:flex-row has correct defaults', (tester) async {
      await pumpSized(
        tester,
        const Div(classNames: 'sm:flex lg:flex-row', children: [SizedBox()]),
        width: 500,
      );
      var flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);

      await pumpSized(
        tester,
        const Div(classNames: 'sm:flex lg:flex-row', children: [SizedBox()]),
        width: 800,
      );
      flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);

      await pumpSized(
        tester,
        const Div(classNames: 'sm:flex lg:flex-row', children: [SizedBox()]),
        width: 1200,
      );
      flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);
    });
  });

  group('Config Validation', () {
    test('custom config with custom spacing key validates', () {
      final customConfig = TwConfig.standard().copyWith(
        space: {...TwConfig.standard().space, '13': 52.0},
      );
      final helper = ParserTestHelper(customConfig);

      helper.parser.parseFlex('flex gap-13');
      helper.expectNoWarnings();
    });

    test('custom config with custom color validates', () {
      final customColor = const Color(0xFF8B5CF6);
      final customConfig = TwConfig.standard().copyWith(
        colors: {...TwConfig.standard().colors, 'brand-500': customColor},
      );
      final helper = ParserTestHelper(customConfig);

      helper.parser.parseBox('bg-brand-500');
      helper.expectNoWarnings();
    });

    test('onUnsupported fires for unknown token', () {
      final helper = ParserTestHelper();

      helper.parser.parseBox('unknown-token-xyz');
      helper.expectWarning('unknown-token-xyz');
    });

    test('onUnsupported receives the unsupported token string', () {
      final helper = ParserTestHelper();

      helper.parser.parseBox('foo-bar-baz');
      helper.expectWarning('foo-bar-baz');
    });

    test('onUnsupported fires for invalid duration value', () {
      final helper = ParserTestHelper();

      helper.parser.parseAnimationFromTokens(['duration-999']);
      helper.expectWarning('duration-999');
    });

    test('onUnsupported fires for invalid delay value', () {
      final helper = ParserTestHelper();

      helper.parser.parseAnimationFromTokens(['delay-999']);
      helper.expectWarning('delay-999');
    });

    test('custom duration config should NOT fire onUnsupported', () {
      final customConfig = TwConfig.standard().copyWith(
        durations: {...TwConfig.standard().durations, '2000': 2000},
      );
      final helper = ParserTestHelper(customConfig);

      helper.parser.parseAnimationFromTokens(['duration-2000']);
      helper.expectNoWarnings();
    });

    test('custom scale config should NOT fire onUnsupported', () {
      final customConfig = TwConfig.standard().copyWith(
        scales: {...TwConfig.standard().scales, '200': 2.0},
      );
      final helper = ParserTestHelper(customConfig);

      helper.parser.parseBox('scale-200');
      helper.expectNoWarnings();
    });
  });
}
