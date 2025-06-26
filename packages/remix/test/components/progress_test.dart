import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import '../utils/interaction_tests.dart';

void main() {
  group('RxProgress', () {
    group('Constructor', () {
      const value = 0.5;
      const variants = [Variant('primary')];
      final style = RxProgressStyle();

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxProgress(
          value: value,
          variants: variants,
          style: style,
        );

        expect(widget.value, value);
        expect(widget.variants, variants);
        expect(widget.style, style);
      });

      testWidgets('should render correct UI output',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxProgress(
            value: value,
          ),
        );
      });
    });
  });
}
