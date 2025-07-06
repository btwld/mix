import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Test attribute that uses Mixable<Color>
final class TestColorAttribute extends SpecAttribute<Color> {
  final Mixable<Color> color;

  const TestColorAttribute(this.color);

  @override
  TestColorAttribute merge(covariant TestColorAttribute other) {
    return TestColorAttribute(color.merge(other.color));
  }

  @override
  List<Object?> get props => [color];

  @override
  Color resolve(MixContext mix) => color.resolve(mix);
}

// Test utility using NewMixUtility
final class TestColorUtility extends NewMixUtility<TestColorAttribute, Color> {
  const TestColorUtility(super.builder);

  // Basic color methods
  TestColorAttribute red() => call(Colors.red);
  TestColorAttribute blue() => call(Colors.blue);
  TestColorAttribute green() => call(Colors.green);

  // Token method (inherited from NewMixUtility)
  // TestColorAttribute token(MixableToken<Color> token) => token(token);
}

void main() {
  group('NewMixUtility Tests', () {
    late TestColorUtility colorUtility;

    setUp(() {
      colorUtility = const TestColorUtility(TestColorAttribute.new);
    });

    test('call() method creates attribute with Mixable.value', () {
      final attribute = colorUtility.call(Colors.red);

      expect(attribute, isA<TestColorAttribute>());
      expect(attribute.color, isA<Mixable<Color>>());

      // Test that it resolves to the correct color
      final resolved = attribute.resolve(EmptyMixData);
      expect(resolved, Colors.red);
    });

    test('token() method creates attribute with Mixable.token', () {
      const testToken = MixableToken<Color>('test-color');
      final attribute = colorUtility.token(testToken);

      expect(attribute, isA<TestColorAttribute>());
      expect(attribute.color, isA<Mixable<Color>>());
    });

    test('composite() method creates attribute with Mixable.composite', () {
      final mixables = [
        const Mixable.value(Colors.red),
        const Mixable.value(Colors.blue),
      ];
      final attribute = colorUtility.composite(mixables);

      expect(attribute, isA<TestColorAttribute>());
      expect(attribute.color, isA<Mixable<Color>>());
    });

    test('convenience methods work correctly', () {
      final redAttribute = colorUtility.red();
      final blueAttribute = colorUtility.blue();
      final greenAttribute = colorUtility.green();

      expect(redAttribute.resolve(EmptyMixData), Colors.red);
      expect(blueAttribute.resolve(EmptyMixData), Colors.blue);
      expect(greenAttribute.resolve(EmptyMixData), Colors.green);
    });

    test('only() method throws UnimplementedError by default', () {
      expect(() => colorUtility.only(), throwsUnimplementedError);
    });

    testWidgets('token resolution works with MixScope', (tester) async {
      const testToken = MixableToken<Color>('primary-color');

      await tester.pumpWithMixScope(
        Container(),
        theme: MixScopeData.static(tokens: {testToken: Colors.purple}),
      );

      final buildContext = tester.element(find.byType(Container));
      final mixData = MixContext.create(buildContext, Style());

      final attribute = colorUtility.token(testToken);
      final resolved = attribute.resolve(mixData);

      expect(resolved, Colors.purple);
    });
  });
}
