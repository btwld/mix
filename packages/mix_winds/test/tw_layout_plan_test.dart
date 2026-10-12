import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/src/translate/tw_translator.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/tw_layout_plan.dart';

TwCompiledLayoutPlan _boxPlan(String classes) =>
    TwParser().compileBox(classes).layoutPlan as TwCompiledLayoutPlan;

TwCompiledLayoutPlan _flexPlan(String classes) =>
    TwParser().compileFlex(classes).layoutPlan as TwCompiledLayoutPlan;

TwCompiledLayoutPlan _iconPlan(String classes) =>
    TwParser().compileIcon(classes).layoutPlan as TwCompiledLayoutPlan;

void main() {
  group('responsive selection', () {
    test('nested breakpoints require every minimum width', () {
      for (final prefix in ['lg:md', 'md:lg']) {
        final plan = _boxPlan('$prefix:w-16 $prefix:mb-4');

        expect(plan.dimensions.width.select(800), isNull, reason: prefix);
        expect(plan.externalMargin.select(800), isNull, reason: prefix);
        expect(
          plan.dimensions.width.select(1024),
          const TwDimensionIntent.fixed(64),
          reason: prefix,
        );
        expect(
          plan.externalMargin.select(1024),
          const TwInsets(bottom: 16),
          reason: prefix,
        );
      }
    });

    test('selects the greatest breakpoint not exceeding explicit width', () {
      final values = TwResponsiveValue<String>([
        const TwResponsiveEntry(minWidth: 1024, value: 'lg'),
        const TwResponsiveEntry(minWidth: 0, value: 'base'),
        const TwResponsiveEntry(minWidth: 768, value: 'md-old'),
        const TwResponsiveEntry(minWidth: 768, value: 'md'),
      ]);

      expect(values.select(-1), isNull);
      expect(values.select(0), 'base');
      expect(values.select(767.9), 'base');
      expect(values.select(768), 'md');
      expect(values.select(2000), 'lg');
      expect(values.select(.nan), isNull);
    });

    test('compiles typed dimension intents at breakpoint boundaries', () {
      final plan = _boxPlan('w-16 md:w-full lg:w-1/2');

      expect(
        plan.dimensions.width.select(500),
        const TwDimensionIntent.fixed(64),
      );
      expect(plan.dimensions.width.select(768), const TwDimensionIntent.full());
      expect(
        plan.dimensions.width.select(1200),
        const TwDimensionIntent.fraction(0.5),
      );
      expect(plan.dimensions.height.isEmpty, isTrue);
      expect(plan.isEmpty, isFalse);
    });

    test('normalizes static viewport dimension utilities', () {
      final plan = _boxPlan('w-screen h-screen');

      expect(plan.dimensions.width.select(0), const TwDimensionIntent.screen());
      expect(
        plan.dimensions.height.select(0),
        const TwDimensionIntent.screen(),
      );
      expect(plan.isEmpty, isFalse);
    });
  });

  group('flex semantics', () {
    test('resolves container axis, gap axes, and explicit items', () {
      final plan = _flexPlan(
        'flex gap-2 md:flex-col md:gap-x-4 md:gap-y-6 md:items-start',
      );

      final base = plan.flexContainer.resolve(500);
      expect(base.axis, TwFlexAxis.horizontal);
      expect(base.mainGap, 8);
      expect(base.crossGap, isNull);
      expect(base.implicitCrossAxisPolicy, TwImplicitCrossAxisPolicy.none);

      final md = plan.flexContainer.resolve(800);
      expect(md.axis, TwFlexAxis.vertical);
      expect(md.mainGap, 24);
      expect(md.crossGap, 16);
      expect(md.implicitCrossAxisPolicy, TwImplicitCrossAxisPolicy.none);
    });

    test('keeps prefixed-only flex fallback vertical below breakpoint', () {
      final plan = _flexPlan('md:flex');

      expect(plan.flexContainer.isFlexContainer, isTrue);
      expect(plan.flexContainer.resolve(500).axis, TwFlexAxis.vertical);
      expect(plan.flexContainer.resolve(800).axis, TwFlexAxis.horizontal);
    });

    test('detects responsive implicit vertical alignment as runtime work', () {
      final plan = _flexPlan('flex md:flex-col');

      expect(
        plan.flexContainer.resolve(500).implicitCrossAxisPolicy,
        TwImplicitCrossAxisPolicy.none,
      );
      expect(
        plan.flexContainer.resolve(800).implicitCrossAxisPolicy,
        TwImplicitCrossAxisPolicy.stretchWhenBoundedStartWhenUnbounded,
      );
      expect(plan.isEmpty, isFalse);
    });

    test('longhands override shorthand independent of class order', () {
      for (final classes in [
        'flex-1 md:flex-1 md:basis-32 md:grow-0',
        'md:grow-0 md:basis-32 md:flex-1 flex-1',
      ]) {
        final plan = _boxPlan(classes);
        final base = plan.flexItem.resolve(500);
        expect(base.basis, TwFlexBasis.zero);
        expect(base.grow, 1);
        expect(base.zeroBasisGrow, 1);

        final md = plan.flexItem.resolve(800);
        expect(md.basis, const TwFlexBasis.fixed(128));
        expect(md.grow, 0);
        expect(md.behavior, const TwFlexBehavior(flex: 0, fit: .loose));
        expect(md.zeroBasisGrow, isNull);
      }
    });

    test('basis-0 plus grow carries explicit zero-basis semantics', () {
      final item = _boxPlan('basis-0 grow').flexItem.resolve(0);

      expect(item.basis, TwFlexBasis.zero);
      expect(item.grow, 1);
      expect(item.zeroBasisGrow, 1);
      expect(item.behavior, const TwFlexBehavior(flex: 1, fit: .tight));
    });
  });

  group('zero-basis insets', () {
    testWidgets('inline parent padding follows the emitted box groups', (
      tester,
    ) async {
      const classes = 'md:mb-4 px-5 md:px-10 sm:px-2';
      final compilation = TwTranslator(
        config: TwConfig.standard(),
      ).compileForWidget(classes, .inline);
      final plan = compilation.parentLayoutPlan;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: Directionality(
            textDirection: .ltr,
            child: Builder(
              builder: (context) {
                final padding = compilation.boxStyler!
                    .build(context)
                    .spec
                    .padding!;
                expect(
                  plan.padding.select(800)!.mainExtent(.horizontal),
                  padding.horizontal,
                );

                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('plan padding and border project the emitted box groups', (
      tester,
    ) async {
      for (final classes in [
        'p-4 px-2 md:p-8 lg:pl-1',
        'border-blue-500 md:border-4 lg:border-l-2',
        'border-2 md:border-x-4 md:border-red-500 lg:border-t-0',
        'hover:p-6 md:p-3 dark:border-4 md:border-2',
      ]) {
        final compilation = TwTranslator(
          config: TwConfig.standard(),
        ).compileForWidget(classes, .boxOrFlex);
        final plan = compilation.parentLayoutPlan;
        for (final width in [600.0, 800.0, 1200.0]) {
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: Size(width, 600)),
              child: Directionality(
                textDirection: .ltr,
                child: Builder(
                  builder: (context) {
                    final spec = compilation.boxStyler!.build(context).spec;
                    final padding = spec.padding?.resolve(.ltr) ?? .zero;
                    final border =
                        (spec.decoration as BoxDecoration?)?.border as Border?;
                    final planPadding =
                        plan.padding.select(width) ?? const TwInsets();
                    final planBorder =
                        plan.border.select(width) ?? const TwInsets();
                    final reason = '$classes at $width';

                    expect(planPadding.left, padding.left, reason: reason);
                    expect(planPadding.top, padding.top, reason: reason);
                    expect(planPadding.right, padding.right, reason: reason);
                    expect(planPadding.bottom, padding.bottom, reason: reason);
                    expect(
                      planBorder.left,
                      border?.left.width ?? 0,
                      reason: reason,
                    );
                    expect(
                      planBorder.top,
                      border?.top.width ?? 0,
                      reason: reason,
                    );
                    expect(
                      planBorder.right,
                      border?.right.width ?? 0,
                      reason: reason,
                    );
                    expect(
                      planBorder.bottom,
                      border?.bottom.width ?? 0,
                      reason: reason,
                    );

                    return const SizedBox();
                  },
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull, reason: '$classes at $width');
        }
      }
    });

    testWidgets('dropped text margin cannot establish variant merge order', (
      tester,
    ) async {
      // TextStylers do not emit padding. Use supported font sizes to exercise
      // the text target's dropped-margin path and compare its emitted order.
      const classes = 'md:mb-4 sm:text-sm md:text-lg';
      final compilation = TwTranslator(
        config: TwConfig.standard(),
      ).compileForWidget(classes, .text);
      final withoutMargin = TwParser().compileText('sm:text-sm md:text-lg');
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: Directionality(
            textDirection: .ltr,
            child: Builder(
              builder: (context) {
                expect(
                  compilation.textStyler!.build(context).spec,
                  withoutMargin.styler.build(context).spec,
                );

                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(
        compilation.parentLayoutPlan.externalMargin.select(800),
        const TwInsets(bottom: 16),
      );
      expect(compilation.diagnostics, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('variant groups preserve equal flex content widths', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(900, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(800, 600)),
          child: Directionality(
            textDirection: .ltr,
            child: Div(
              classNames: 'flex',
              children: [
                Div(
                  classNames: 'flex-1 md:mb-4 px-5 md:px-10 sm:px-2',
                  child: SizedBox(key: Key('first')),
                ),
                Div(
                  classNames: 'flex-1',
                  child: SizedBox(key: Key('second')),
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byKey(const Key('first'))).width,
        closeTo(tester.getSize(find.byKey(const Key('second'))).width, 0.01),
      );
    });

    test('negative arbitrary margins preserve earlier positive margins', () {
      final box = _boxPlan('mb-2 md:mb-[-4px]');
      final icon = _iconPlan('me-2 md:me-[-4px]');

      expect(box.externalMargin.select(800), const TwInsets(bottom: 8));
      expect(
        box.zeroBasisOuterExtent(.vertical, marginWidth: 800, styleWidth: 800),
        8,
      );
      expect(icon.iconLogicalMargin.select(800), const TwLogicalInsets(end: 8));
    });

    test('cascades responsive margin, padding, and border sides', () {
      final plan = _boxPlan(
        'm-2 p-2 border md:mx-4 md:pt-4 md:border-x-2 lg:ml-8',
      );

      expect(
        plan.zeroBasisOuterExtent(
          .horizontal,
          marginWidth: 500,
          styleWidth: 500,
        ),
        34,
      );
      expect(
        plan.zeroBasisOuterExtent(
          .horizontal,
          marginWidth: 800,
          styleWidth: 800,
        ),
        52,
      );
      expect(
        plan.zeroBasisOuterExtent(.vertical, marginWidth: 800, styleWidth: 800),
        42,
      );
      expect(
        plan.zeroBasisOuterExtent(
          .horizontal,
          marginWidth: 1200,
          styleWidth: 1200,
        ),
        68,
      );
      expect(
        plan.externalMargin.select(1200),
        const TwInsets(left: 32, top: 8, right: 16, bottom: 8),
      );
    });

    test('keeps style-only padding and border auxiliary to portability', () {
      final plan = _boxPlan('p-4 border-2');

      expect(plan.padding.isEmpty, isFalse);
      expect(plan.isEmpty, isTrue);
      expect(
        plan.zeroBasisOuterExtent(.horizontal, marginWidth: 0, styleWidth: 0),
        36,
      );
    });

    test('tracks icon logical and box physical margins independently', () {
      final iconPlan = _iconPlan('ms-2 me-1 ml-4 hover:me-8 md:mr-6');
      final boxPlan = _boxPlan('ml-4 md:mr-6');

      expect(
        iconPlan.iconLogicalMargin.select(500),
        const TwLogicalInsets(start: 8, end: 4, left: 16),
      );
      expect(
        iconPlan.iconLogicalMargin.select(800),
        const TwLogicalInsets(start: 8, end: 4, left: 16, right: 24),
      );
      expect(
        boxPlan.externalMargin.select(800),
        const TwInsets(left: 16, right: 24),
      );
    });
  });
}
