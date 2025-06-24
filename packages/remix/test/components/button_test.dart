import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxButton', () {
    group('Constructor', () {
      const child = SizedBox(
        width: 100,
        height: 100,
        child: Icon(Icons.star),
      );
      const label = 'Raw Button';
      const icon = Icons.star;
      const variants = [Variant('warning')];
      final focusNode = FocusNode();
      Widget spinnerBuilder(context) => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );

      testWidgets(
          'Should initialize RxButton.raw with correct properties and display child widget',
          (WidgetTester tester) async {
        final widget = RxButton.raw(
          enabled: true,
          loading: false,
          enableHapticFeedback: true,
          onPressed: () {},
          variants: variants,
          style: RxButtonStyle(),
          focusNode: focusNode,
          spinnerBuilder: spinnerBuilder,
          child: child,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.enabled, isTrue);
        expect(widget.loading, isFalse);
        expect(widget.enableHapticFeedback, isTrue);
        expect(widget.variants, variants);
        expect(widget.style, RxButtonStyle());
        expect(widget.child, child);
        expect(widget.focusNode, focusNode);
        expect(widget.spinnerBuilder, spinnerBuilder);

        expect(find.byWidget(child), findsOneWidget);
      });

      testWidgets(
          'Should initialize RxButton with correct properties and display child widget',
          (WidgetTester tester) async {
        final widget = RxButton(
          label: label,
          icon: icon,
          enabled: true,
          loading: false,
          enableHapticFeedback: true,
          onPressed: () {},
          variants: variants,
          style: RxButtonStyle(),
          focusNode: focusNode,
          spinnerBuilder: spinnerBuilder,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.enabled, isTrue);
        expect(widget.loading, isFalse);
        expect(widget.enableHapticFeedback, isTrue);
        expect(widget.variants, variants);
        expect(widget.style, RxButtonStyle());
        expect(widget.focusNode, focusNode);
        expect(widget.spinnerBuilder, spinnerBuilder);

        expect(find.text(label), findsOneWidget);
        expect(find.byIcon(icon), findsOneWidget);
      });

      testWidgets(
          'Should initialize RxButton.icon with correct properties and display icon',
          (WidgetTester tester) async {
        final widget = RxButton.icon(
          icon,
          enabled: true,
          loading: false,
          enableHapticFeedback: true,
          onPressed: () {},
          variants: variants,
          style: RxButtonStyle(),
          focusNode: focusNode,
          spinnerBuilder: spinnerBuilder,
        );

        await tester.pumpRxWidget(widget);

        expect(widget.enabled, isTrue);
        expect(widget.loading, isFalse);
        expect(widget.enableHapticFeedback, isTrue);
        expect(widget.variants, variants);
        expect(widget.style, RxButtonStyle());
        expect(widget.focusNode, focusNode);
        expect(widget.spinnerBuilder, spinnerBuilder);

        expect(find.byIcon(icon), findsOneWidget);
        expect(find.byType(Text), findsNothing);
      });
    });

    testWidgets('Should create button with icon in different positions',
        (WidgetTester tester) async {
      for (var position in [IconPosition.start, IconPosition.end]) {
        await tester.pumpRxWidget(
          RxButton(
            label: 'Test Button',
            icon: Icons.arrow_forward,
            iconPosition: position,
            onPressed: () {},
          ),
        );

        expect(find.text('Test Button'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

        final findPosition = position == IconPosition.start
            ? FindPosition.first
            : FindPosition.last;

        final iconWidget = findWidgetInFlex<Icon>(
          tester,
          parentType: RxButton,
          widgetType: Icon,
          findPosition: findPosition,
        );

        expect(iconWidget.icon, Icons.arrow_forward);
      }
    });

    testWidgets('Should create button with custom spinner',
        (WidgetTester tester) async {
      for (var loadingState in [true, false]) {
        await tester.pumpRxWidget(
          RxButton(
            label: 'Custom Spinner',
            loading: loadingState,
            spinnerBuilder: (context) => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            onPressed: () {},
          ),
        );

        expect(find.text('Custom Spinner'), findsOneWidget);
        if (loadingState) {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        } else {
          expect(find.byType(CircularProgressIndicator), findsNothing);
        }
      }
    });

    testWidgets('Should apply custom style correctly',
        (WidgetTester tester) async {
      await tester.pumpRxWidget(
        RxButton(
          label: 'Styled Button',
          style: RxButtonStyle()
            ..container.color.red()
            ..textStyle.color.purple()
            ..container.borderRadius.circular(8),
          onPressed: () {},
        ),
      );

      final buttonFinder = find.byType(RxButton);
      final textFinder = find.byType(RichText);

      expect(buttonFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);

      // Find the Container widget inside the RxButton
      final containerFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(Container),
      );
      final buttonContainer = tester.widget<Container>(containerFinder);

      // Verify Container color and borderRadius
      final decoration = buttonContainer.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.red));
      expect(decoration.borderRadius, equals(BorderRadius.circular(8)));

      // Verify the Text widget color
      final textWidget = tester.widget<RichText>(textFinder);
      expect(textWidget.text.style?.color, equals(Colors.purple));
    });

    group('Interaction', () {
      testTapWidget(
          'Should be clickable when enabled is true and onPressed is not null',
          (holder) {
        return RxButton(
          label: 'Test Button',
          onPressed: () => holder.value = true,
        );
      }, shouldExpectPress: true);

      testTapWidget('Should be unclickable when enabled is false', (value) {
        return RxButton(
          label: 'Test Button',
          onPressed: () => value.value = true,
          enabled: false,
        );
      }, shouldExpectPress: false);

      testTapWidget('Should be unclickable when onPressed is null', (value) {
        return RxButton(
          label: 'Test Button',
          onPressed: null,
        );
      }, shouldExpectPress: false);

      testHoverWidget('Should be hoverable when enabled', () {
        return RxButton(
          label: 'Test Button',
          onPressed: () {},
        );
      }, shouldExpectHover: true);

      testHoverWidget('Should not react to hover when disabled', () {
        return RxButton(
          label: 'Test Button',
          onPressed: () {},
          enabled: false,
        );
      }, shouldExpectHover: false);

      testFocusWidget('Should be focusable when enabled', (focusNode) {
        return RxButton(
          label: 'Test Button',
          focusNode: focusNode,
          onPressed: () {},
        );
      }, shouldExpectFocus: true);

      testFocusWidget('Should not be focusable when disabled', (focusNode) {
        return RxButton(
          label: 'Test Button',
          focusNode: focusNode,
          onPressed: () {},
          enabled: false,
        );
      }, shouldExpectFocus: false);
    });
  });
}
