import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Directionality Utils', () {
    testWidgets('onRTL context variant', (tester) async {
      await tester.pumpWidget(createDirectionality(TextDirection.rtl));
      var context = tester.element(find.byType(Container));

      expect(onRTL.when(context), true, reason: 'rtl');
      expect(onLTR.when(context), false, reason: 'ltr');
    });

    testWidgets('onLTR context variant', (tester) async {
      await tester.pumpWidget(createDirectionality(TextDirection.ltr));
      var context = tester.element(find.byType(Container));

      expect(onRTL.when(context), false, reason: 'rtl');
      expect(onLTR.when(context), true, reason: 'ltr');
    });
    test('have correct variant names', () {
      expect(onRTL.name, 'on-rtl');
      expect(onLTR.name, 'on-ltr');
    });
  });
}
