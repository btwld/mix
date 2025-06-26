import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/components/form/slider/slider.dart';
import '../utils/interaction_tests.dart';

void main() {
  group('RxSlider', () {
    group('Constructor', () {
      const min = 0.0;
      const max = 100.0;
      const value = 50.0;
      const enabled = true;
      final style = RxSliderStyle();
      void onChanged(double value) {}
      const variants = [Variant('primary')];

      testWidgets('should initialize with correct properties', (tester) async {
        final slider = RxSlider(
          min: min,
          max: max,
          value: value,
          enabled: enabled,
          style: style,
          onChanged: onChanged,
          variants: variants,
        );

        await tester.pumpRxWidget(slider);

        expect(slider.min, min);
        expect(slider.max, max);
        expect(slider.value, value);
        expect(slider.enabled, enabled);
        expect(slider.style, style);
        expect(slider.onChanged, onChanged);
        expect(slider.variants, variants);
      });

      testWidgets('should render correct UI output', (tester) async {
        final slider = RxSlider(
          min: min,
          max: max,
          value: value,
          onChanged: onChanged,
        );

        await tester.pumpRxWidget(slider);

        final sliderFinder = find.byType(RxSlider);
        expect(sliderFinder, findsOneWidget);
      });
    });

    testWidgets('should call onChangeStart when drag begins', (tester) async {
      double? startValue;
      double value = 50.0;
      final slider = StatefulBuilder(builder: (context, setState) {
        return RxSlider(
          min: 0.0,
          max: 100.0,
          value: value,
          onChangeStart: (newValue) => startValue = newValue,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
        );
      });

      await tester.pumpRxWidget(slider);

      final center = tester.getCenter(find.byType(RxSlider));
      final gesture = await tester.startGesture(center);
      await gesture.moveTo(Offset(center.dx + 50, center.dy));
      await tester.pumpAndSettle();

      expect(startValue, equals(50.0));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('should call onChangeEnd when drag ends', (tester) async {
      double? endValue;
      double value = 50.0;
      final slider = StatefulBuilder(builder: (context, setState) {
        return RxSlider(
          min: 0.0,
          max: 100.0,
          value: value,
          onChangeEnd: (newValue) {
            endValue = newValue;
          },
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
        );
      });

      await tester.pumpRxWidget(slider);

      final center = tester.getCenter(find.byType(RxSlider));
      final gesture = await tester.startGesture(center);
      await gesture.moveTo(Offset(center.dx + 50, center.dy));

      await tester.pumpAndSettle();

      await gesture.up();
      await tester.pumpAndSettle();

      expect(endValue, isNotNull);
      expect(endValue!, greaterThan(50.0));
    });

    group('interactions', () {
      Future<void> testSliderDrag(
        WidgetTester tester, {
        required bool enabled,
        required bool shouldCallOnChanged,
      }) async {
        double? changedValue;
        final slider = RxSlider(
          min: 0.0,
          max: 100.0,
          value: 50.0,
          enabled: enabled,
          onChanged: (value) => changedValue = value,
        );

        await tester.pumpRxWidget(slider);

        final center = tester.getCenter(find.byType(RxSlider));
        final gesture = await tester.startGesture(center);
        await gesture.moveTo(Offset(center.dx + 50, center.dy));
        await tester.pumpAndSettle();

        if (shouldCallOnChanged) {
          expect(changedValue, isNotNull);
          expect(changedValue!, greaterThan(50.0));
        } else {
          expect(changedValue, isNull);
        }

        await gesture.up();
        await tester.pumpAndSettle();
      }

      testWidgets('should call onChanged when dragged', (tester) async {
        await testSliderDrag(tester, enabled: true, shouldCallOnChanged: true);
      });

      testWidgets('should not call onChanged when disabled and dragged',
          (tester) async {
        await testSliderDrag(tester,
            enabled: false, shouldCallOnChanged: false);
      });

      testHoverWidget('should handle hover state correctly', () {
        return RxSlider(
          min: 0.0,
          max: 100.0,
          value: 50.0,
          onChanged: (value) {},
        );
      }, shouldExpectHover: true);

      testFocusWidget('should handle focus state correctly', (focusNode) {
        return RxSlider(
          min: 0.0,
          max: 100.0,
          value: 50.0,
          focusNode: focusNode,
          onChanged: (value) {},
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should not handle focus state when disabled',
          (focusNode) {
        return RxSlider(
          min: 0.0,
          max: 100.0,
          value: 50.0,
          focusNode: focusNode,
          enabled: false,
          onChanged: (value) {},
        );
      }, shouldExpectFocus: false);
    });
  });
}
