import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

const _red500 = Color(0xFFFB2C36);
const _blue500 = Color(0xFF2B7FFF);

Future<void> _pumpAtTopLeft(
  WidgetTester tester,
  Widget child, {
  double width = 800,
  Brightness brightness = Brightness.light,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: Size(width, 400),
        platformBrightness: brightness,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  );
  await tester.pump();
}

Finder _containerInside(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(Container));

Color? _decorationColor(WidgetTester tester, Key key) {
  final finder = _containerInside(key);
  expect(finder, findsOneWidget);
  final container = tester.widget<Container>(finder);
  return (container.decoration as BoxDecoration?)?.color;
}

EdgeInsetsGeometry? _padding(WidgetTester tester, Key key) {
  final finder = _containerInside(key);
  expect(finder, findsOneWidget);
  return tester.widget<Container>(finder).padding;
}

Future<(Color?, EdgeInsetsGeometry?)> _baseSnapshot(
  WidgetTester tester,
  String classNames,
) async {
  const subject = Key('base-order-subject');
  await _pumpAtTopLeft(tester, Div(key: subject, classNames: classNames));
  return (_decorationColor(tester, subject), _padding(tester, subject));
}

Future<Color?> _hoveredColor(WidgetTester tester, String classNames) async {
  const subject = Key('hover-order-subject');
  await _pumpAtTopLeft(tester, Div(key: subject, classNames: classNames));
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: const Offset(-100, -100));
  await mouse.moveTo(tester.getCenter(_containerInside(subject)));
  await tester.pump();
  final color = _decorationColor(tester, subject);
  await mouse.removePointer();
  return color;
}

Future<Color?> _stackedVariantColor(
  WidgetTester tester,
  String stackedVariant, {
  required double width,
  required bool hovered,
}) async {
  tester.view.physicalSize = Size(width, 400);
  const subject = Key('stacked-variant-subject');
  await tester.pumpWidget(
    MediaQuery.fromView(
      view: tester.view,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: Div(
            key: subject,
            classNames: 'w-20 h-20 bg-red-500 $stackedVariant:bg-blue-500',
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  TestGesture? mouse;
  if (hovered) {
    mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(-100, -100));
    await mouse.moveTo(tester.getCenter(_containerInside(subject)));
    await tester.pump();
  }

  final color = _decorationColor(tester, subject);
  await mouse?.removePointer();
  return color;
}

Future<(Color?, List<String>)> _variantSnapshot(
  WidgetTester tester,
  String classNames, {
  required Brightness brightness,
}) async {
  const subject = Key('theme-variant-subject');
  final warnings = <String>[];
  await _pumpAtTopLeft(
    tester,
    Div(
      key: subject,
      classNames: classNames,
      onDiagnostic: (diagnostic) => warnings.add(diagnostic.token),
    ),
    brightness: brightness,
  );
  return (_decorationColor(tester, subject), warnings);
}

Future<void> _expectDiagnostic(WidgetTester tester, String token) async {
  const subject = Key('silent-drop-subject');
  final diagnostics = <TwDiagnostic>[];
  await _pumpAtTopLeft(
    tester,
    Div(
      key: subject,
      classNames: 'w-20 h-20 bg-red-500 $token',
      onDiagnostic: diagnostics.add,
    ),
  );

  expect(_decorationColor(tester, subject), _red500);
  expect(diagnostics.map((diagnostic) => diagnostic.token), contains(token));
}

void main() {
  testWidgets('E1 conflicting utilities resolve independently of token order', (
    tester,
  ) async {
    final forwardBase = await _baseSnapshot(
      tester,
      'w-20 h-20 bg-red-500 bg-blue-500 p-2 p-4',
    );
    final reverseBase = await _baseSnapshot(
      tester,
      'w-20 h-20 bg-blue-500 bg-red-500 p-4 p-2',
    );
    final forwardHover = await _hoveredColor(
      tester,
      'w-20 h-20 hover:bg-red-500 hover:bg-blue-500',
    );
    final reverseHover = await _hoveredColor(
      tester,
      'w-20 h-20 hover:bg-blue-500 hover:bg-red-500',
    );

    expect(
      [reverseBase.$1, reverseBase.$2, reverseHover],
      [forwardBase.$1, forwardBase.$2, forwardHover],
    );
  });

  testWidgets('E2 md:hover and hover:md require both stacked conditions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    Future<List<Color?>> observationsFor(String variant) async {
      return <Color?>[
        await _stackedVariantColor(tester, variant, width: 600, hovered: false),
        await _stackedVariantColor(tester, variant, width: 600, hovered: true),
        await _stackedVariantColor(
          tester,
          variant,
          width: 1000,
          hovered: false,
        ),
        await _stackedVariantColor(tester, variant, width: 1000, hovered: true),
      ];
    }

    final observations = <String, List<Color?>>{
      'hover control': await observationsFor('hover'),
      'breakpoint control': await observationsFor('md'),
      'md:hover': await observationsFor('md:hover'),
      'hover:md': await observationsFor('hover:md'),
    };
    expect(observations, {
      'hover control': [_red500, _blue500, _red500, _blue500],
      'breakpoint control': [_red500, _red500, _blue500, _blue500],
      'md:hover': [_red500, _red500, _red500, _blue500],
      'hover:md': [_red500, _red500, _red500, _blue500],
    });
  });

  testWidgets('E3 dark follows brightness without aliasing theme-midnight', (
    tester,
  ) async {
    final darkInLight = await _variantSnapshot(
      tester,
      'w-20 h-20 bg-red-500 dark:bg-blue-500',
      brightness: Brightness.light,
    );
    final darkInDark = await _variantSnapshot(
      tester,
      'w-20 h-20 bg-red-500 dark:bg-blue-500',
      brightness: Brightness.dark,
    );
    const midnightToken = 'theme-midnight:bg-blue-500';
    final midnightInLight = await _variantSnapshot(
      tester,
      'w-20 h-20 bg-red-500 $midnightToken',
      brightness: Brightness.light,
    );
    final midnightInDark = await _variantSnapshot(
      tester,
      'w-20 h-20 bg-red-500 $midnightToken',
      brightness: Brightness.dark,
    );

    expect(
      [
        darkInLight.$1,
        darkInDark.$1,
        midnightInLight.$1,
        midnightInDark.$1,
        midnightInDark.$2,
      ],
      [
        _red500,
        _blue500,
        _red500,
        _red500,
        [midnightToken],
      ],
    );
  });

  testWidgets('E4 important modifier emits a diagnostic', (tester) async {
    await _expectDiagnostic(tester, '!bg-blue-500');
  });

  for (final testCase in <(String, String)>[
    ('arbitrary property', '[color:red]'),
    ('container variant', '@md:bg-blue-500'),
    ('group variant', 'group-hover:bg-blue-500'),
    ('peer variant', 'peer-hover:bg-blue-500'),
  ]) {
    testWidgets('E4 ${testCase.$1} emits a diagnostic', (tester) async {
      await _expectDiagnostic(tester, testCase.$2);
    });
  }
}
