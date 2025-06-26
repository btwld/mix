import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import '../utils/interaction_tests.dart';

void main() {
  group('RxSpinner', () {
    group('Constructor', () {
      const variants = [Variant('primary')];
      final style = RxSpinnerStyle();

      testWidgets('should initialize with correct properties',
          (WidgetTester tester) async {
        final widget = RxSpinner(
          variants: variants,
          style: style,
        );

        expect(widget.variants, variants);
        expect(widget.style, style);
      });

      testWidgets('should render correct UI output',
          (WidgetTester tester) async {
        await tester.pumpRxWidget(
          const RxSpinner(),
        );

        expect(find.byType(RxSpinner), findsOneWidget);
      });
    });
  });
}
