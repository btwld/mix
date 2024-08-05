import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

// Act as an expert in dart and someone with deep understanding of effective dart documentation guidelines. You have been tasked to create comments in the code that help document it for other developers and users when they look at the code. Your comments should be detailed complete, but still concise.
void main() {
  const onXSmall = OnBreakpointTokenVariant(BreakpointToken.xsmall);
  const onSmall = OnBreakpointTokenVariant(BreakpointToken.small);
  const onMedium = OnBreakpointTokenVariant(BreakpointToken.medium);
  const onLarge = OnBreakpointTokenVariant(BreakpointToken.large);

  group('OnBreakpointToken Utils', () {
    const xSmallScreenWidth = Size(320, 480);
    const smallScreenWidth = Size(640, 480);
    const mediumScreenWidth = Size(1240, 768);
    const largeScreenWidth = Size(1440, 900);
    testWidgets('xSmall screen context variant', (tester) async {
      await tester.pumpWidget(createMediaQuery(xSmallScreenWidth));
      var context = tester.element(find.byType(Container));

      expect(onXSmall.when(context), true, reason: 'xsmall');
      expect(onSmall.when(context), false, reason: 'small');
      expect(onMedium.when(context), false, reason: 'medium');
      expect(onLarge.when(context), false, reason: 'large');
    });

    test('Check equality', () {
      const xsmall1 = OnBreakpointTokenVariant(BreakpointToken.xsmall);
      const xsmall2 = OnBreakpointTokenVariant(BreakpointToken.xsmall);
      const small1 = OnBreakpointTokenVariant(BreakpointToken.small);
      const small2 = OnBreakpointTokenVariant(BreakpointToken.small);
      const medium1 = OnBreakpointTokenVariant(BreakpointToken.medium);
      const medium2 = OnBreakpointTokenVariant(BreakpointToken.medium);
      const large1 = OnBreakpointTokenVariant(BreakpointToken.large);
      const large2 = OnBreakpointTokenVariant(BreakpointToken.large);

      expect(xsmall1, equals(xsmall2));
      expect(xsmall1, isNot(equals(small1)));
      expect(xsmall1, isNot(equals(medium1)));
      expect(xsmall1, isNot(equals(large1)));

      expect(small1, equals(small2));
      expect(small1, isNot(equals(xsmall1)));
      expect(small1, isNot(equals(medium1)));
      expect(small1, isNot(equals(large1)));

      expect(medium1, equals(medium2));
      expect(medium1, isNot(equals(xsmall1)));
      expect(medium1, isNot(equals(small1)));
      expect(medium1, isNot(equals(large1)));

      expect(large1, equals(large2));
      expect(large1, isNot(equals(xsmall1)));
      expect(large1, isNot(equals(small1)));
      expect(large1, isNot(equals(medium1)));
    });

    testWidgets('small screen context variant', (tester) async {
      tester.view.physicalSize = smallScreenWidth;
      await tester.pumpWidget(createMediaQuery(smallScreenWidth));
      var context = tester.element(find.byType(Container));

      expect(onXSmall.when(context), false, reason: 'xsmall');
      expect(onSmall.when(context), true, reason: 'small');
      expect(onMedium.when(context), false, reason: 'medium');
      expect(onLarge.when(context), false, reason: 'large');

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('medium screen context variant', (tester) async {
      tester.view.physicalSize = mediumScreenWidth;
      await tester.pumpWidget(createMediaQuery(mediumScreenWidth));
      var context = tester.element(find.byType(Container));

      expect(onXSmall.when(context), false, reason: 'xsmall');
      expect(onSmall.when(context), false, reason: 'small');
      expect(onMedium.when(context), true, reason: 'medium');
      expect(onLarge.when(context), false, reason: 'large');
    });

    testWidgets('large screen context variant', (tester) async {
      tester.view.physicalSize = largeScreenWidth;
      await tester.pumpWidget(createMediaQuery(largeScreenWidth));
      var context = tester.element(find.byType(Container));

      expect(onXSmall.when(context), false, reason: 'xsmall');
      expect(onSmall.when(context), false, reason: 'small');
      expect(onMedium.when(context), false, reason: 'medium');
      expect(onLarge.when(context), true, reason: 'large');

      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test merge
    test('OnBreakpointTokenVariant mergeKey', () {
      final style = Style(
        VariantAttribute<OnBreakpointTokenVariant>(
          const OnBreakpointTokenVariant(BreakpointToken.small),
          Style(),
        ),
        VariantAttribute<OnBreakpointTokenVariant>(
          const OnBreakpointTokenVariant(BreakpointToken.medium),
          Style(),
        ),
      );

      expect(style.values.length, 2);
    });
  });
  group('OnBreakpoint Variant', () {
    testWidgets('OnBreakPointVariant', (tester) async {
      const size1 = Size(50, 100);
      const size2 = Size(150, 200);
      const size3 = Size(250, 300);
      const size4 = Size(400, 400);
      tester.view.physicalSize = size1;

      await tester.pumpWidget(createMediaQuery(size1));
      var context = tester.element(find.byType(Container));
      const breakpoint1 = OnBreakPointVariant(
        Breakpoint(maxWidth: 100, minWidth: 50),
      );
      const breakpoint2 = OnBreakPointVariant(
        Breakpoint(maxWidth: 200, minWidth: 50),
      );
      const breakpoint3 = OnBreakPointVariant(
        Breakpoint(maxWidth: 300, minWidth: 50),
      );

      expect(breakpoint1.when(context), true, reason: 'size1 breakpoint1');
      expect(breakpoint2.when(context), true, reason: 'size1 breakpoint2');
      expect(breakpoint3.when(context), true, reason: 'size1 breakpoint3');

      tester.view.resetPhysicalSize();

      tester.view.physicalSize = size2;

      await tester.pumpWidget(createMediaQuery(size2));

      context = tester.element(find.byType(Container));

      expect(breakpoint1.when(context), false, reason: 'size2 breakpoint1');
      expect(breakpoint2.when(context), true, reason: 'size2 breakpoint2');
      expect(breakpoint3.when(context), true, reason: 'size2 breakpoint3');

      tester.view.resetPhysicalSize();

      tester.view.physicalSize = size3;

      await tester.pumpWidget(createMediaQuery(size3));
      context = tester.element(find.byType(Container));

      expect(breakpoint1.when(context), false, reason: 'size3 breakpoint1');
      expect(breakpoint2.when(context), false, reason: 'size3 breakpoint2');
      expect(breakpoint3.when(context), true, reason: 'size3 breakpoint3');

      tester.view.resetPhysicalSize();

      tester.view.physicalSize = size4;

      await tester.pumpWidget(createMediaQuery(size4));

      context = tester.element(find.byType(Container));

      expect(breakpoint1.when(context), false, reason: 'size4 breakpoint1');
      expect(breakpoint2.when(context), false, reason: 'size4 breakpoint2');
      expect(breakpoint3.when(context), false, reason: 'size4 breakpoint3');
      addTearDown(tester.view.resetPhysicalSize);
    });

    // Test merge
    test('OnBreakPointVariant mergeKey', () {
      final style = Style(
        VariantAttribute<OnBreakPointVariant>(
          const OnBreakPointVariant(
            Breakpoint(maxWidth: 100, minWidth: 50),
          ),
          Style(),
        ),
        VariantAttribute<OnBreakPointVariant>(
          const OnBreakPointVariant(
            Breakpoint(maxWidth: 200, minWidth: 50),
          ),
          Style(),
        ),
      );

      expect(style.values.length, 2);
    });

    test('OnBreakPoint equality', () {
      const breakpoint1 = OnBreakPointVariant(
        Breakpoint(maxWidth: 100, minWidth: 50),
      );
      const breakpoint2 = OnBreakPointVariant(
        Breakpoint(maxWidth: 100, minWidth: 50),
      );
      const breakpoint3 = OnBreakPointVariant(
        Breakpoint(maxWidth: 200, minWidth: 50),
      );
      const breakpoint4 = OnBreakPointVariant(
        Breakpoint(maxWidth: 200, minWidth: 50),
      );

      expect(breakpoint1, equals(breakpoint2));
      expect(breakpoint1, isNot(equals(breakpoint3)));
      expect(breakpoint1, isNot(equals(breakpoint4)));
    });
  });
}
