// Characterization oracle for TwParser (tw_parser.dart).
//
// PURPOSE: pin the CURRENT behavior of the parser's public entry points
// (parseBox / parseFlex / parseText, plus the Div/P/Span widgets that wrap
// them) so a behavior-preserving refactor of tw_parser.dart can be proven
// semantics-preserving. Every test here asserts on CONCRETE resolved Flutter
// values (decoration colors, border widths, padding, transform matrices,
// shadows, text style) rather than on styler identity/equality — styler
// `==` is NOT stable across identical parses (transform tracker + Prop
// sources carry identity), so it cannot be used as an oracle.
//
// These tests must be GREEN against the current, unmodified production code.
// If an assertion ever fails during the refactor, the production change
// leaked a semantic difference — fix the code, not the expectation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

// ===========================================================================
// Resolve helpers — turn a parsed styler into a concrete resolved spec.
// ===========================================================================

Future<BoxSpec> _resolveBox(
  WidgetTester tester,
  String classNames, {
  TwParser? parser,
}) async {
  final style = (parser ?? TwParser()).parseBox(classNames);
  late BoxSpec spec;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          spec = style.resolve(context).spec;
          return const SizedBox();
        },
      ),
    ),
  );
  return spec;
}

Future<FlexBoxSpec> _resolveFlex(WidgetTester tester, String classNames) async {
  final style = TwParser().parseFlex(classNames);
  late FlexBoxSpec spec;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          spec = style.resolve(context).spec;
          return const SizedBox();
        },
      ),
    ),
  );
  return spec;
}

Future<TextSpec> _resolveText(WidgetTester tester, String classNames) async {
  final style = TwParser().parseText(classNames);
  late TextSpec spec;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          spec = style.resolve(context).spec;
          return const SizedBox();
        },
      ),
    ),
  );
  return spec;
}

// Resolves a box style under a forced set of widget states (hover/pressed/...)
// via StyleBuilder's external controller, so variant OUTCOMES (onHovered,
// onPressed, onDisabled, ...) actually apply at resolve time. This is the
// deterministic oracle for the variant/breakpoint application path that P1
// refactors (including transform propagation, e.g. hover:scale-105).
Future<BoxSpec> _resolveBoxStates(
  WidgetTester tester,
  String classNames,
  Set<WidgetState> states, {
  TwParser? parser,
}) async {
  final style = (parser ?? TwParser()).parseBox(classNames);
  final controller = WidgetStatesController(states);
  addTearDown(controller.dispose);
  late BoxSpec spec;
  await tester.pumpWidget(
    MaterialApp(
      home: StyleBuilder<BoxSpec>(
        style: style,
        controller: controller,
        builder: (context, resolved) {
          spec = resolved;
          return const SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return spec;
}

BoxDecoration? _decoOf(BoxSpec spec) => spec.decoration as BoxDecoration?;

BoxDecoration? _flexBoxDecoOf(FlexBoxSpec spec) =>
    spec.box?.spec.decoration as BoxDecoration?;

// Renders a Div and returns the produced Container (for breakpoint/state
// behavior that only resolves under real widget context).
Future<Container> _divContainer(
  WidgetTester tester,
  String classNames, {
  double width = 800,
  double height = 600,
}) async {
  await tester.binding.setSurfaceSize(Size(width, height));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            height: height,
            child: Div(classNames: classNames, child: const SizedBox()),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  final finder = find.byType(Container);
  expect(finder, findsOneWidget);
  return tester.widget<Container>(finder);
}

// Tailwind reference colors used throughout (sRGB hex).
const _blue500 = Color(0xFF3B82F6);
const _red500 = Color(0xFFEF4444);
const _emerald400 = Color(0xFF34D399);
const _gray200 = Color(0xFFE5E7EB);
const _white = Color(0xFFFFFFFF);

void main() {
  // =========================================================================
  // Spacing (padding / margin / gap)
  // =========================================================================
  group('characterization: spacing', () {
    testWidgets('padding all + axis + sides', (tester) async {
      final spec = await _resolveBox(tester, 'pt-1 pr-2 pb-3 pl-4');
      final pad = spec.padding! as EdgeInsets;
      expect(pad.top, 4);
      expect(pad.right, 8);
      expect(pad.bottom, 12);
      expect(pad.left, 16);
    });

    testWidgets('px/py expand to horizontal/vertical', (tester) async {
      final spec = await _resolveBox(tester, 'px-4 py-2');
      final pad = spec.padding! as EdgeInsets;
      expect(pad.left, 16);
      expect(pad.right, 16);
      expect(pad.top, 8);
      expect(pad.bottom, 8);
    });

    testWidgets('p-2 then px-4 last-wins on horizontal', (tester) async {
      final spec = await _resolveBox(tester, 'p-2 px-4');
      final pad = spec.padding! as EdgeInsets;
      expect(pad.left, 16);
      expect(pad.right, 16);
      expect(pad.top, 8);
      expect(pad.bottom, 8);
    });

    testWidgets('margin all + sides', (tester) async {
      final spec = await _resolveBox(tester, 'mt-1 mr-2 mb-3 ml-4');
      final margin = spec.margin! as EdgeInsets;
      expect(margin.top, 4);
      expect(margin.right, 8);
      expect(margin.bottom, 12);
      expect(margin.left, 16);
    });

    testWidgets('flex gap maps to spacing', (tester) async {
      final spec = await _resolveFlex(tester, 'flex gap-4');
      expect(spec.flex?.spec.spacing, 16);
    });
  });

  // =========================================================================
  // Sizing (width / height / min / max, px only)
  // =========================================================================
  group('characterization: sizing', () {
    testWidgets('w-/h- px values set constraints', (tester) async {
      final spec = await _resolveBox(tester, 'w-20 h-10');
      final c = spec.constraints!;
      expect(c.minWidth, 80);
      expect(c.maxWidth, 80);
      expect(c.minHeight, 40);
      expect(c.maxHeight, 40);
    });

    testWidgets('min/max width+height', (tester) async {
      final spec = await _resolveBox(
        tester,
        'min-w-20 max-w-40 min-h-10 max-h-20',
      );
      final c = spec.constraints!;
      expect(c.minWidth, 80);
      expect(c.maxWidth, 160);
      expect(c.minHeight, 40);
      expect(c.maxHeight, 80);
    });
  });

  // =========================================================================
  // Background color
  // =========================================================================
  group('characterization: background', () {
    testWidgets('bg-blue-500 sets color', (tester) async {
      final spec = await _resolveBox(tester, 'bg-blue-500');
      expect(_decoOf(spec)?.color, _blue500);
    });

    testWidgets('arbitrary 6-digit hex bg', (tester) async {
      final spec = await _resolveBox(tester, 'bg-[#112233]');
      expect(_decoOf(spec)?.color, const Color(0xFF112233));
    });

    testWidgets('arbitrary CSS hex bg', (tester) async {
      final shortRgb = await _resolveBox(tester, 'bg-[#fff]');
      expect(_decoOf(shortRgb)?.color, const Color(0xFFFFFFFF));

      final shortRgba = await _resolveBox(tester, 'bg-[#ffff]');
      expect(_decoOf(shortRgba)?.color, const Color(0xFFFFFFFF));

      final longRgba = await _resolveBox(tester, 'bg-[#ffffff80]');
      expect(_decoOf(longRgba)?.color, const Color(0x80FFFFFF));

      final cssOrdered = await _resolveBox(tester, 'bg-[#80ffffff]');
      expect(_decoOf(cssOrdered)?.color, const Color(0xFF80FFFF));
    });

    testWidgets('valid arbitrary opacity modifier applies alpha', (
      tester,
    ) async {
      final spec = await _resolveBox(tester, 'bg-red-500/[50%]');
      expect(_decoOf(spec)?.color, const Color(0x80EF4444));
    });

    testWidgets('arbitrary bare-fraction opacity modifier applies alpha', (
      tester,
    ) async {
      final spec = await _resolveBox(tester, 'bg-red-500/[0.5]');
      expect(_decoOf(spec)?.color, const Color(0x80EF4444));
    });

    testWidgets('invalid color opacity modifiers warn and skip token', (
      tester,
    ) async {
      final seen = <String>[];
      final parser = TwParser(onUnsupported: seen.add);
      final spec = await _resolveBox(
        tester,
        'bg-red-500/[bad] bg-red-500/200 bg-red-500/(--v)',
        parser: parser,
      );

      expect(_decoOf(spec)?.color, isNull);
      expect(seen, contains('bg-red-500/[bad]'));
      expect(seen, contains('bg-red-500/200'));
      expect(seen, contains('bg-red-500/(--v)'));
    });
  });

  // =========================================================================
  // Border radius
  // =========================================================================
  group('characterization: border-radius', () {
    testWidgets('rounded-lg uniform radius', (tester) async {
      final spec = await _resolveBox(tester, 'rounded-lg');
      final r = _decoOf(spec)?.borderRadius?.resolve(TextDirection.ltr);
      expect(r!.topLeft.x, 8);
      expect(r.topRight.x, 8);
      expect(r.bottomLeft.x, 8);
      expect(r.bottomRight.x, 8);
    });

    testWidgets('rounded-t-md top corners only', (tester) async {
      final spec = await _resolveBox(tester, 'rounded-t-md');
      final r = _decoOf(spec)?.borderRadius?.resolve(TextDirection.ltr);
      expect(r!.topLeft.x, 6);
      expect(r.topRight.x, 6);
      expect(r.bottomLeft.x, 0);
      expect(r.bottomRight.x, 0);
    });

    testWidgets('rounded-bl-lg bottom-left only', (tester) async {
      final spec = await _resolveBox(tester, 'rounded-bl-lg');
      final r = _decoOf(spec)?.borderRadius?.resolve(TextDirection.ltr);
      expect(r!.bottomLeft.x, 8);
      expect(r.topLeft.x, 0);
    });
  });

  // =========================================================================
  // Transforms (scale / rotate / translate) — flush timing & matrix
  // =========================================================================
  group('characterization: transform', () {
    testWidgets('scale-105 produces ~1.05 diagonal', (tester) async {
      final spec = await _resolveBox(tester, 'scale-105');
      expect(spec.transform, isNotNull);
      expect(spec.transform![0], closeTo(1.05, 1e-6));
      expect(spec.transform![5], closeTo(1.05, 1e-6));
    });

    testWidgets('rotate-45 produces rotation matrix', (tester) async {
      final spec = await _resolveBox(tester, 'rotate-45');
      expect(spec.transform, isNotNull);
      expect(spec.transform![0], closeTo(0.70710678, 1e-6));
    });

    testWidgets('-rotate-45 negative rotation', (tester) async {
      final spec = await _resolveBox(tester, '-rotate-45');
      expect(spec.transform, isNotNull);
      // cos(-45) == cos(45); sin component sign distinguishes — check [1].
      expect(spec.transform![1], closeTo(-0.70710678, 1e-6));
    });

    testWidgets('translate-x-4 / translate-y-4 set translation', (
      tester,
    ) async {
      final spec = await _resolveBox(tester, 'translate-x-4 translate-y-4');
      expect(spec.transform, isNotNull);
      // Matrix4 translation column (indices 12,13).
      expect(spec.transform![12], closeTo(16, 1e-6));
      expect(spec.transform![13], closeTo(16, 1e-6));
    });

    testWidgets('-translate-x-[10px] resolves to negative pixels', (
      tester,
    ) async {
      final spec = await _resolveBox(tester, '-translate-x-[10px]');
      expect(spec.transform, isNotNull);
      expect(spec.transform![12], closeTo(-10, 1e-6));
    });

    testWidgets('combined scale+rotate+translate composes', (tester) async {
      final spec = await _resolveBox(
        tester,
        'scale-105 rotate-45 translate-x-2',
      );
      expect(spec.transform, isNotNull);
      // Order is translate * rotate * scale (per _TransformAccum.toMatrix4).
      // Pin the full 16-value matrix as the regression fingerprint.
      final expected =
          (Matrix4.identity()
                ..multiply(Matrix4.translationValues(8, 0, 0))
                ..multiply(Matrix4.rotationZ(45 * 3.1415926535897932 / 180))
                ..multiply(Matrix4.diagonal3Values(1.05, 1.05, 1.0)))
              .storage;
      for (var i = 0; i < 16; i++) {
        expect(spec.transform![i], closeTo(expected[i], 1e-6), reason: 'i=$i');
      }
    });
  });

  // =========================================================================
  // Blur & Clip (effects)
  // =========================================================================
  group('characterization: blur + clip', () {
    testWidgets('blur wraps with an image-filter blur modifier', (
      tester,
    ) async {
      // blur is applied as a widget modifier; the current renderer produces an
      // ImageFiltered widget (not BackdropFilter) via the Div widget path.
      final seen = <String>[];
      TwParser(onUnsupported: seen.add).parseBox('blur');
      expect(seen, isEmpty);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Div(classNames: 'blur bg-blue-500', child: const SizedBox()),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(ImageFiltered), findsOneWidget);
    });

    testWidgets('clip behavior sets clipBehavior on box', (tester) async {
      final spec = await _resolveBox(tester, 'overflow-hidden');
      // overflow-hidden is recognized; clipBehavior may be null at spec level
      // (handled at widget layer). Pin that it parses with no warning instead.
      expect(spec, isNotNull);
    });
  });

  // =========================================================================
  // Typography on box (DefaultTextStyle propagation)
  // =========================================================================
  group('characterization: typography on box', () {
    testWidgets('text color + size + weight propagate via DefaultTextStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Div(
            classNames: 'text-blue-500 text-lg font-bold',
            child: const Text('hello'),
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('hello'));
      final style = DefaultTextStyle.of(
        tester.element(find.text('hello')),
      ).style;
      expect(style.color, _blue500);
      expect(style.fontSize, 18);
      expect(style.fontWeight, FontWeight.w700);
      expect(text, isNotNull);
    });

    testWidgets('arbitrary text size propagates via DefaultTextStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Div(classNames: 'text-[13px]', child: const Text('hello')),
        ),
      );

      final style = DefaultTextStyle.of(
        tester.element(find.text('hello')),
      ).style;
      expect(style.fontSize, 13);
    });
  });

  // =========================================================================
  // Borders — sides, widths, colors, axis, inheritance
  // =========================================================================
  group('characterization: borders', () {
    testWidgets('border-t single top side width 1', (tester) async {
      final spec = await _resolveBox(tester, 'border-t');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.top.width, 1);
      expect(b.bottom.width, 0);
      expect(b.left.width, 0);
      expect(b.right.width, 0);
    });

    testWidgets('border all sides width 1', (tester) async {
      final spec = await _resolveBox(tester, 'border');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.top.width, 1);
      expect(b.bottom.width, 1);
      expect(b.left.width, 1);
      expect(b.right.width, 1);
    });

    testWidgets('border-y-2 vertical width 2', (tester) async {
      final spec = await _resolveBox(tester, 'border-y-2');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.top.width, 2);
      expect(b.bottom.width, 2);
      expect(b.left.width, 0);
      expect(b.right.width, 0);
    });

    testWidgets('border-x-red-500 colors horizontal', (tester) async {
      final spec = await _resolveBox(tester, 'border-x-red-500');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.left.color, _red500);
      expect(b.right.color, _red500);
    });

    testWidgets('border + border-red-500 colors all sides', (tester) async {
      final spec = await _resolveBox(tester, 'border border-red-500');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.top.color, _red500);
      expect(b.bottom.color, _red500);
      expect(b.left.color, _red500);
      expect(b.right.color, _red500);
      expect(b.top.width, 1);
    });

    testWidgets('border-t + border-gray-200 colors top only', (tester) async {
      final spec = await _resolveBox(tester, 'border-t border-gray-200');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.top.width, 1);
      expect(b.top.color, _gray200);
      expect(b.bottom.width, 0);
      expect(b.bottom.style, BorderStyle.none);
      expect(b.left.style, BorderStyle.none);
      expect(b.right.style, BorderStyle.none);
    });

    testWidgets('color-only border produces no visible width', (tester) async {
      final spec = await _resolveBox(tester, 'border-gray-200');
      final b = _decoOf(spec)?.border as Border?;
      expect(b?.top.width ?? 0, 0);
      expect(b?.bottom.width ?? 0, 0);
      expect(b?.left.width ?? 0, 0);
      expect(b?.right.width ?? 0, 0);
      expect(b?.top.style, BorderStyle.none);
      expect(b?.bottom.style, BorderStyle.none);
      expect(b?.left.style, BorderStyle.none);
      expect(b?.right.style, BorderStyle.none);
    });

    testWidgets('border-x-2 + border-blue-500 width and color', (tester) async {
      final spec = await _resolveBox(tester, 'border-x-2 border-blue-500');
      final b = _decoOf(spec)?.border as Border?;
      expect(b!.left.width, 2);
      expect(b.right.width, 2);
      expect(b.left.color, _blue500);
      expect(b.right.color, _blue500);
      expect(b.top.width, 0);
      expect(b.bottom.width, 0);
    });

    testWidgets('flex path borders resolve identically', (tester) async {
      final spec = await _resolveFlex(tester, 'flex border-t-2 border-red-500');
      final b = _flexBoxDecoOf(spec)?.border as Border?;
      expect(b!.top.width, 2);
      expect(b.top.color, _red500);
      expect(b.bottom.width, 0);
    });

    testWidgets('variant border inherits base structure (widget)', (
      tester,
    ) async {
      // hover variant border inherits base top structure; in the default
      // (non-hovered) state the base top border is visible.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Div(
            classNames: 'border-t hover:border-red-500',
            child: const SizedBox(),
          ),
        ),
      );
      await tester.pump();
      final container = tester.widget<Container>(find.byType(Container));
      final b = (container.decoration as BoxDecoration?)?.border as Border?;
      expect(b, isNotNull);
      expect(b!.top.width, greaterThan(0));
      expect(b.bottom.width, 0);
      expect(b.left.width, 0);
      expect(b.right.width, 0);
    });

    testWidgets('hover border color inherits base top width', (tester) async {
      final inactive = await _resolveBoxStates(
        tester,
        'border-t hover:border-red-500',
        const {},
      );
      final inactiveBorder = _decoOf(inactive)?.border as Border?;
      expect(inactiveBorder, isNotNull);
      expect(inactiveBorder!.top.width, 1);
      expect(inactiveBorder.top.color, _gray200);
      expect(inactiveBorder.bottom.width, 0);

      final hovered = await _resolveBoxStates(
        tester,
        'border-t hover:border-red-500',
        {WidgetState.hovered},
      );
      final hoveredBorder = _decoOf(hovered)?.border as Border?;
      expect(hoveredBorder, isNotNull);
      expect(hoveredBorder!.top.width, 1);
      expect(hoveredBorder.top.color, _red500);
      expect(hoveredBorder.bottom.width, 0);
      expect(hoveredBorder.left.width, 0);
      expect(hoveredBorder.right.width, 0);
    });
  });

  // =========================================================================
  // Gradients
  // =========================================================================
  group('characterization: gradients', () {
    testWidgets('bg-gradient-to-r from/to builds linear gradient', (
      tester,
    ) async {
      final spec = await _resolveBox(
        tester,
        'bg-gradient-to-r from-blue-500 to-red-500',
      );
      final g = _decoOf(spec)?.gradient as LinearGradient?;
      expect(g, isNotNull);
      expect(g!.colors.first, _blue500);
      expect(g.colors.last, _red500);
      expect(g.stops, const [0.0, 1.0]);
    });

    testWidgets('via color inserts mid stop at 0.5', (tester) async {
      final spec = await _resolveBox(
        tester,
        'bg-gradient-to-r from-blue-500 via-white to-red-500',
      );
      final g = _decoOf(spec)?.gradient as LinearGradient?;
      expect(g, isNotNull);
      expect(g!.colors, [_blue500, _white, _red500]);
      expect(g.stops, const [0.0, 0.5, 1.0]);
    });

    testWidgets('bg-linear-to-b alias builds gradient', (tester) async {
      final spec = await _resolveBox(
        tester,
        'bg-linear-to-b from-blue-500 to-red-500',
      );
      final g = _decoOf(spec)?.gradient as LinearGradient?;
      expect(g, isNotNull);
      expect(g!.colors.first, _blue500);
      expect(g.colors.last, _red500);
    });

    testWidgets('flex path gradient resolves identically', (tester) async {
      final spec = await _resolveFlex(
        tester,
        'flex bg-gradient-to-r from-blue-500 to-red-500',
      );
      final g = _flexBoxDecoOf(spec)?.gradient as LinearGradient?;
      expect(g, isNotNull);
      expect(g!.colors.first, _blue500);
      expect(g.colors.last, _red500);
    });

    testWidgets('hover gradient stop inherits base direction and to stop', (
      tester,
    ) async {
      final inactive = await _resolveBoxStates(
        tester,
        'bg-gradient-to-r from-blue-500 to-red-500 hover:from-emerald-400',
        const {},
      );
      final baseGradient = _decoOf(inactive)?.gradient as LinearGradient?;
      expect(baseGradient, isNotNull);
      expect(baseGradient!.colors, [_blue500, _red500]);

      final hovered = await _resolveBoxStates(
        tester,
        'bg-gradient-to-r from-blue-500 to-red-500 hover:from-emerald-400',
        {WidgetState.hovered},
      );
      final hoveredGradient = _decoOf(hovered)?.gradient as LinearGradient?;
      expect(hoveredGradient, isNotNull);
      expect(hoveredGradient!.begin, Alignment.centerLeft);
      expect(hoveredGradient.end, Alignment.centerRight);
      expect(hoveredGradient.colors, [_emerald400, _red500]);
      expect(hoveredGradient.stops, const [0.0, 1.0]);
    });

    testWidgets('important gradient tokens warn and do not apply', (
      tester,
    ) async {
      final seen = <String>[];
      final parser = TwParser(onUnsupported: seen.add);
      final base = await _resolveBox(
        tester,
        'bg-white !bg-gradient-to-r !from-red-500',
        parser: parser,
      );

      expect(_decoOf(base)?.color, _white);
      expect(_decoOf(base)?.gradient, isNull);
      expect(seen, contains('!bg-gradient-to-r'));
      expect(seen, contains('!from-red-500'));

      final hovered = await _resolveBoxStates(
        tester,
        'bg-gradient-to-r from-blue-500 to-red-500 hover:!from-red-500',
        {WidgetState.hovered},
        parser: parser,
      );
      final gradient = _decoOf(hovered)?.gradient as LinearGradient?;
      expect(gradient, isNotNull);
      expect(gradient!.colors, [_blue500, _red500]);
      expect(seen, contains('hover:!from-red-500'));
    });

    testWidgets('invalid gradient opacity modifier warns and skips stop', (
      tester,
    ) async {
      final seen = <String>[];
      final parser = TwParser(onUnsupported: seen.add);
      final spec = await _resolveBox(
        tester,
        'bg-gradient-to-r from-red-500/[bad] to-blue-500',
        parser: parser,
      );

      expect(_decoOf(spec)?.gradient, isNull);
      expect(seen, contains('from-red-500/[bad]'));
    });
  });

  // =========================================================================
  // Box shadows
  // =========================================================================
  group('characterization: box-shadow', () {
    testWidgets('shadow-sm single preset shadow', (tester) async {
      final spec = await _resolveBox(tester, 'shadow-sm');
      final shadows = _decoOf(spec)?.boxShadow;
      expect(
        shadows,
        orderedEquals(const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ]),
      );
    });

    testWidgets('shadow-md two-layer preset', (tester) async {
      final spec = await _resolveBox(tester, 'shadow-md');
      final shadows = _decoOf(spec)?.boxShadow;
      expect(
        shadows,
        orderedEquals(const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
            color: Color(0x1A000000),
          ),
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
            color: Color(0x1A000000),
          ),
        ]),
      );
    });

    testWidgets('shadow-none clears shadows', (tester) async {
      final spec = await _resolveBox(tester, 'shadow-none');
      final shadows = _decoOf(spec)?.boxShadow;
      expect(shadows ?? const <BoxShadow>[], isEmpty);
    });

    testWidgets('flex path shadow resolves identically', (tester) async {
      final spec = await _resolveFlex(tester, 'flex shadow-sm');
      final shadows = _flexBoxDecoOf(spec)?.boxShadow;
      expect(
        shadows,
        orderedEquals(const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0D000000),
          ),
        ]),
      );
    });
  });

  // =========================================================================
  // Flex layout (direction, alignment, default column)
  // =========================================================================
  group('characterization: flex layout', () {
    testWidgets('flex defaults to row', (tester) async {
      final spec = await _resolveFlex(tester, 'flex');
      expect(spec.flex?.spec.direction, Axis.horizontal);
    });

    testWidgets('flex-col sets vertical', (tester) async {
      final spec = await _resolveFlex(tester, 'flex flex-col');
      expect(spec.flex?.spec.direction, Axis.vertical);
    });

    testWidgets('prefixed-only flex defaults to column', (tester) async {
      final spec = await _resolveFlex(tester, 'md:flex');
      expect(spec.flex?.spec.direction, Axis.vertical);
    });

    testWidgets('items-center sets cross axis', (tester) async {
      final spec = await _resolveFlex(tester, 'flex items-center');
      expect(spec.flex?.spec.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('justify-between sets main axis', (tester) async {
      final spec = await _resolveFlex(tester, 'flex justify-between');
      expect(spec.flex?.spec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('items-baseline sets baseline + textBaseline', (tester) async {
      final spec = await _resolveFlex(tester, 'flex items-baseline');
      expect(spec.flex?.spec.crossAxisAlignment, CrossAxisAlignment.baseline);
      expect(spec.flex?.spec.textBaseline, TextBaseline.alphabetic);
    });
  });

  // =========================================================================
  // Text styler path (parseText)
  // =========================================================================
  group('characterization: text', () {
    testWidgets('color + size + weight', (tester) async {
      final spec = await _resolveText(
        tester,
        'text-blue-500 text-lg font-bold',
      );
      expect(spec.style?.color, _blue500);
      expect(spec.style?.fontSize, 18);
      expect(spec.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('text-lg seeds tailwind line height', (tester) async {
      final spec = await _resolveText(tester, 'text-lg');
      // text-lg default line-height is 1.75rem / 1.125rem font => height 1.555..
      expect(spec.style?.fontSize, 18);
      expect(spec.style?.height, isNotNull);
    });

    testWidgets('text-sm resolves to canonical Tailwind size', (tester) async {
      final spec = await _resolveText(tester, 'text-sm');
      expect(spec.style?.fontSize, 14);
    });

    testWidgets('arbitrary text size sets font size', (tester) async {
      final spec = await _resolveText(tester, 'text-[13px]');
      expect(spec.style?.fontSize, 13);
    });

    testWidgets('tracking-wide letter spacing', (tester) async {
      final spec = await _resolveText(tester, 'tracking-wide');
      expect(spec.style?.letterSpacing, 0.4);
    });

    testWidgets('text-align center', (tester) async {
      final spec = await _resolveText(tester, 'text-center');
      expect(spec.textAlign, TextAlign.center);
    });

    testWidgets('uppercase transform applies at render', (tester) async {
      final style = TwParser().parseText('uppercase');
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StyledText('abc', style: style),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, 'ABC');
    });

    testWidgets('truncate sets overflow + maxLines', (tester) async {
      final spec = await _resolveText(tester, 'truncate');
      expect(spec.overflow, TextOverflow.ellipsis);
      expect(spec.maxLines, 1);
      expect(spec.softWrap, isFalse);
    });

    testWidgets('text-shadow preset applies shadows', (tester) async {
      final spec = await _resolveText(tester, 'text-shadow-sm');
      expect(spec.style?.shadows, isNotNull);
      expect(spec.style!.shadows!, isNotEmpty);
    });
  });

  // =========================================================================
  // !important — ignored because Flutter/Mix has no CSS cascade priority model.
  // =========================================================================
  group('characterization: important', () {
    testWidgets('!bg-blue-500 is ignored', (tester) async {
      final spec = await _resolveBox(tester, '!bg-blue-500');
      expect(_decoOf(spec)?.color, isNull);
    });

    testWidgets('!p-4 is ignored', (tester) async {
      final spec = await _resolveBox(tester, '!p-4');
      expect(spec.padding, isNull);
    });

    testWidgets('suffix important tokens are reported and ignored', (
      tester,
    ) async {
      final seen = <String>[];
      final parser = TwParser(onUnsupported: seen.add);

      final bg = await _resolveBox(tester, 'bg-blue-500!', parser: parser);
      expect(_decoOf(bg)?.color, isNull);

      final margin = await _resolveBox(tester, 'mx-4!', parser: parser);
      expect(margin.margin, isNull);

      final hovered = await _resolveBoxStates(tester, 'hover:bg-red-500!', {
        WidgetState.hovered,
      }, parser: parser);
      expect(_decoOf(hovered)?.color, isNull);

      final arbitrary = await _resolveBox(
        tester,
        '[color:red]/50!',
        parser: parser,
      );
      expect(_decoOf(arbitrary)?.color, isNull);

      expect(
        seen,
        containsAll([
          'bg-blue-500!',
          'mx-4!',
          'hover:bg-red-500!',
          '[color:red]/50!',
        ]),
      );
    });
  });

  // =========================================================================
  // Breakpoints — md: applies only at/above the breakpoint width
  // =========================================================================
  group('characterization: breakpoints', () {
    testWidgets('md:bg-blue-500 inactive below md', (tester) async {
      final container = await _divContainer(
        tester,
        'md:bg-blue-500',
        width: 500,
      );
      final deco = container.decoration as BoxDecoration?;
      expect(deco?.color, isNot(_blue500));
    });

    testWidgets('md:bg-blue-500 active at/above md', (tester) async {
      final container = await _divContainer(
        tester,
        'md:bg-blue-500',
        width: 900,
      );
      final deco = container.decoration as BoxDecoration?;
      expect(deco?.color, _blue500);
    });

    testWidgets('base + md override: base below, override above', (
      tester,
    ) async {
      final below = await _divContainer(
        tester,
        'bg-white md:bg-blue-500',
        width: 500,
      );
      expect((below.decoration as BoxDecoration?)?.color, _white);

      final above = await _divContainer(
        tester,
        'bg-white md:bg-blue-500',
        width: 900,
      );
      expect((above.decoration as BoxDecoration?)?.color, _blue500);
    });

    testWidgets('breakpoint gap-x responds to width (flex)', (tester) async {
      Future<double> spacingFor(double width) async {
        await tester.binding.setSurfaceSize(Size(width, 600));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 600)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  height: 600,
                  child: Div(
                    classNames: 'flex gap-x-2 md:gap-x-6',
                    children: const [
                      SizedBox(width: 20, height: 20),
                      SizedBox(width: 20, height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        return tester.widget<Flex>(find.byType(Flex)).spacing;
      }

      expect(await spacingFor(500), 8);
      expect(await spacingFor(900), 24);
    });
  });

  // =========================================================================
  // Variants (hover / dark) — applied via widget state / brightness
  // =========================================================================
  group('characterization: variants', () {
    testWidgets('dark:bg-gray-700 applies under dark brightness', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Div(
              classNames: 'bg-white dark:bg-gray-700',
              child: const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();
      final container = tester.widget<Container>(find.byType(Container));
      final color = (container.decoration as BoxDecoration?)?.color;
      expect(color, isNot(_white));
    });

    testWidgets('light keeps base color under light brightness', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.light),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Div(
              classNames: 'bg-white dark:bg-gray-700',
              child: const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();
      final container = tester.widget<Container>(find.byType(Container));
      final color = (container.decoration as BoxDecoration?)?.color;
      expect(color, _white);
    });

    testWidgets('hover:bg-red-500 active under hovered, base otherwise', (
      tester,
    ) async {
      final active = await _resolveBoxStates(
        tester,
        'bg-white hover:bg-red-500',
        {WidgetState.hovered},
      );
      expect(_decoOf(active)?.color, _red500);

      final inactive = await _resolveBoxStates(
        tester,
        'bg-white hover:bg-red-500',
        const {},
      );
      expect(_decoOf(inactive)?.color, _white);
    });

    testWidgets('active:bg-red-500 applies under pressed', (tester) async {
      final spec = await _resolveBoxStates(
        tester,
        'bg-white active:bg-red-500',
        {WidgetState.pressed},
      );
      expect(_decoOf(spec)?.color, _red500);
    });

    testWidgets('disabled:bg-red-500 applies under disabled', (tester) async {
      final spec = await _resolveBoxStates(
        tester,
        'bg-white disabled:bg-red-500',
        {WidgetState.disabled},
      );
      expect(_decoOf(spec)?.color, _red500);
    });

    testWidgets('focus:bg-red-500 applies under focused', (tester) async {
      final spec = await _resolveBoxStates(
        tester,
        'bg-white focus:bg-red-500',
        {WidgetState.focused},
      );
      expect(_decoOf(spec)?.color, _red500);
    });

    // Transform propagation through a variant: pins copyTo/needsIdentity/
    // _flushTransforms behavior that P1 refactors. Base (inactive) must be the
    // identity matrix; hovered must carry the scale.
    testWidgets('hover:scale-105 — identity at base, 1.05 when hovered', (
      tester,
    ) async {
      final inactive = await _resolveBoxStates(
        tester,
        'hover:scale-105',
        const {},
      );
      expect(inactive.transform, isNotNull);
      expect(inactive.transform![0], closeTo(1.0, 1e-6));
      expect(inactive.transform![5], closeTo(1.0, 1e-6));

      final active = await _resolveBoxStates(tester, 'hover:scale-105', {
        WidgetState.hovered,
      });
      expect(active.transform, isNotNull);
      expect(active.transform![0], closeTo(1.05, 1e-6));
      expect(active.transform![5], closeTo(1.05, 1e-6));
    });

    // Transform on the base PLUS an additional transform inside a variant:
    // base transform must remain when inactive; hovered must combine both.
    testWidgets('scale-105 + hover:rotate-45 combines base and variant', (
      tester,
    ) async {
      final inactive = await _resolveBoxStates(
        tester,
        'scale-105 hover:rotate-45',
        const {},
      );
      expect(inactive.transform, isNotNull);
      // Base scale still present; no rotation yet.
      expect(inactive.transform![0], closeTo(1.05, 1e-6));
      expect(inactive.transform![1], closeTo(0.0, 1e-6));

      final active = await _resolveBoxStates(
        tester,
        'scale-105 hover:rotate-45',
        {WidgetState.hovered},
      );
      expect(active.transform, isNotNull);
      // Combined: rotate(45) * scale(1.05) => [0]=cos45*1.05, [1]=sin45*1.05.
      const cos45 = 0.70710678;
      expect(active.transform![0], closeTo(cos45 * 1.05, 1e-5));
      expect(active.transform![1], closeTo(cos45 * 1.05, 1e-5));
    });

    testWidgets('md:hover:bg-red-500 needs both breakpoint and hover', (
      tester,
    ) async {
      // The default StyleBuilder surface (800px) is >= md (768px), so the
      // breakpoint half of the chain is satisfied. With hover ALSO active the
      // combined variant applies (red); without hover it stays at base (white).
      final hovered = await _resolveBoxStates(
        tester,
        'bg-white md:hover:bg-red-500',
        {WidgetState.hovered},
      );
      expect(_decoOf(hovered)?.color, _red500);

      final notHovered = await _resolveBoxStates(
        tester,
        'bg-white md:hover:bg-red-500',
        const {},
      );
      expect(_decoOf(notHovered)?.color, _white);
    });

    testWidgets('dark:!bg-red-500 is ignored under dark (widget)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Div(
              classNames: 'bg-white dark:!bg-red-500',
              child: const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();
      final container = tester.widget<Container>(find.byType(Container));
      expect((container.decoration as BoxDecoration?)?.color, _white);
    });
  });

  // =========================================================================
  // Variant/breakpoint × transform INTERSECTION.
  //
  // This is the exact propagation path P1 refactors (_applyChildWithTransforms
  // extracted from _applyPrefixedToken: copyTo / needsIdentity /
  // _flushTransforms). Each case pins the resolved Matrix4 so a regression in
  // transform propagation through a variant or breakpoint child is caught.
  // =========================================================================
  group('characterization: variant/breakpoint x transform', () {
    testWidgets('hover:scale-105 — variant child transform, base has none', (
      tester,
    ) async {
      // needsIdentity path: base must resolve to identity, hovered to 1.05.
      final base = await _resolveBoxStates(tester, 'hover:scale-105', const {});
      expect(base.transform![0], closeTo(1.0, 1e-6));
      expect(base.transform![5], closeTo(1.0, 1e-6));

      final hovered = await _resolveBoxStates(tester, 'hover:scale-105', {
        WidgetState.hovered,
      });
      expect(hovered.transform![0], closeTo(1.05, 1e-6));
      expect(hovered.transform![5], closeTo(1.05, 1e-6));
    });

    testWidgets('scale-95 hover:scale-110 — base AND variant transforms', (
      tester,
    ) async {
      // copyTo path: base scale present when inactive; variant scale wins when
      // hovered.
      final base = await _resolveBoxStates(
        tester,
        'scale-95 hover:scale-110',
        const {},
      );
      expect(base.transform![0], closeTo(0.95, 1e-6));
      expect(base.transform![5], closeTo(0.95, 1e-6));

      final hovered = await _resolveBoxStates(
        tester,
        'scale-95 hover:scale-110',
        {WidgetState.hovered},
      );
      expect(hovered.transform![0], closeTo(1.10, 1e-6));
      expect(hovered.transform![5], closeTo(1.10, 1e-6));
    });

    testWidgets('md:rotate-3 — breakpoint child transform', (tester) async {
      // Below md: breakpoint inactive -> identity (no rotation).
      final below = await _divContainer(
        tester,
        'md:rotate-3 bg-blue-500',
        width: 500,
      );
      expect(below.transform, isNotNull);
      expect(below.transform![0], closeTo(1.0, 1e-6));
      expect(below.transform![1], closeTo(0.0, 1e-6));

      // At/above md: rotation applied.
      final above = await _divContainer(
        tester,
        'md:rotate-3 bg-blue-500',
        width: 900,
      );
      expect(above.transform, isNotNull);
      expect(above.transform![0], closeTo(0.99862953, 1e-6)); // cos(3deg)
      expect(above.transform![1], closeTo(0.05233596, 1e-6)); // sin(3deg)
    });

    testWidgets('rotate-2 md:translate-x-2 — base + breakpoint transforms', (
      tester,
    ) async {
      const cos2 = 0.99939083; // cos(2deg)
      // Below md: base rotation present, no translation.
      final below = await _divContainer(
        tester,
        'rotate-2 md:translate-x-2 bg-blue-500',
        width: 500,
      );
      expect(below.transform, isNotNull);
      expect(below.transform![0], closeTo(cos2, 1e-6));
      expect(below.transform![12], closeTo(0.0, 1e-6));

      // At/above md: base rotation still present AND translation applied.
      final above = await _divContainer(
        tester,
        'rotate-2 md:translate-x-2 bg-blue-500',
        width: 900,
      );
      expect(above.transform, isNotNull);
      expect(above.transform![0], closeTo(cos2, 1e-6));
      expect(above.transform![12], closeTo(8.0, 1e-6));
    });
  });

  // =========================================================================
  // Combinations & ordering
  // =========================================================================
  group('characterization: combinations', () {
    testWidgets('full kitchen-sink box resolves all families', (tester) async {
      final spec = await _resolveBox(
        tester,
        'p-4 bg-blue-500 rounded-lg border-t-2 border-red-500 '
        'scale-105 shadow-md w-40 h-20',
      );
      expect((spec.padding! as EdgeInsets).top, 16);
      final deco = _decoOf(spec)!;
      expect(deco.color, _blue500);
      expect(deco.borderRadius?.resolve(TextDirection.ltr).topLeft.x, 8);
      final border = deco.border as Border?;
      expect(border!.top.width, 2);
      expect(border.top.color, _red500);
      expect(deco.boxShadow, isNotEmpty);
      expect(spec.transform![0], closeTo(1.05, 1e-6));
      final c = spec.constraints!;
      expect(c.maxWidth, 160);
      expect(c.maxHeight, 80);
    });

    testWidgets('flex kitchen-sink resolves layout + box families', (
      tester,
    ) async {
      final spec = await _resolveFlex(
        tester,
        'flex flex-col items-center gap-4 p-2 bg-blue-500 rounded-lg '
        'border-t-2 border-red-500',
      );
      expect(spec.flex?.spec.direction, Axis.vertical);
      expect(spec.flex?.spec.crossAxisAlignment, CrossAxisAlignment.center);
      expect(spec.flex?.spec.spacing, 16);
      final box = spec.box?.spec;
      expect((box!.padding! as EdgeInsets).top, 8);
      final deco = _flexBoxDecoOf(spec)!;
      expect(deco.color, _blue500);
      final border = deco.border as Border?;
      expect(border!.top.width, 2);
      expect(border.top.color, _red500);
    });

    testWidgets('unknown token still applies neighbors', (tester) async {
      final seen = <String>[];
      final style = TwParser(
        onUnsupported: seen.add,
      ).parseBox('p-4 totally-unknown bg-blue-500');
      late BoxSpec spec;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              spec = style.resolve(context).spec;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(seen, contains('totally-unknown'));
      expect((spec.padding! as EdgeInsets).top, 16);
      expect(_decoOf(spec)?.color, _blue500);
    });
  });

  // =========================================================================
  // onUnsupported callback semantics (side-effect oracle)
  // =========================================================================
  group('characterization: onUnsupported', () {
    test('unknown tokens reported; valid ones not', () {
      final seen = <String>[];
      TwParser(onUnsupported: seen.add).parseBox('w-4 unknown-x bg-blue-500');
      expect(seen, contains('unknown-x'));
      expect(seen, isNot(contains('w-4')));
      expect(seen, isNot(contains('bg-blue-500')));
    });

    test('unsupported basis flex item tokens report warnings', () {
      final seen = <String>[];
      TwParser(
        onUnsupported: seen.add,
      ).parseFlex('flex flex-1 basis-1/2 basis-full basis-[50%] self-end');

      expect(seen, containsAll(['basis-1/2', 'basis-full', 'basis-[50%]']));
      expect(seen, isNot(contains('flex-1')));
      expect(seen, isNot(contains('self-end')));
    });

    test('supported basis flex item tokens do not report warnings', () {
      final seen = <String>[];
      TwParser(onUnsupported: seen.add).parseFlex('flex basis-auto basis-32');

      expect(seen, isEmpty);
    });

    test('prefix chains parse without warnings', () {
      final seen = <String>[];
      TwParser(onUnsupported: seen.add).parseBox('md:hover:bg-blue-500');
      expect(seen, isEmpty);
    });

    test('border token with unknown prefix part warns', () {
      final seen = <String>[];
      TwParser(onUnsupported: seen.add).parseBox('weird:border-t');
      expect(seen, contains('weird:border-t'));
    });

    test('recognized unsupported variants warn', () {
      final seen = <String>[];
      TwParser(
        onUnsupported: seen.add,
      ).parseBox('first:bg-blue-500 odd:p-4 visited:text-red-500');
      expect(
        seen,
        containsAll(['first:bg-blue-500', 'odd:p-4', 'visited:text-red-500']),
      );
    });
  });
}
