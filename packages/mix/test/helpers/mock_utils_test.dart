import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'mock_utils.dart';

void main() {
  group('Mock Utils', () {
    group('UtilityTestAttribute', () {
      test('creates attribute with Prop value', () {
        final attr = UtilityTestAttribute(Prop(Colors.red));

        expect(attr.value, isA<Prop<Color>>());
        expect(attr.value!.value, Colors.red);
      });

      test('resolves correctly', () {
        final attr = UtilityTestAttribute(Prop(Colors.blue));
        final resolved = attr.resolveSpec(mockContext);

        expect(resolved, isA<MockSpec>());
        expect(resolved.resolvedValue, Colors.blue);
      });

      test('merges correctly', () {
        final first = UtilityTestAttribute(Prop(Colors.red));
        final second = UtilityTestAttribute(Prop(Colors.blue));

        final merged = first.merge(second);

        expect(merged.value, isA<Prop<Color>>());
        expect(merged.value!.value, Colors.blue);
      });

      test('handles null merge', () {
        final attr = UtilityTestAttribute(Prop(Colors.green));
        final merged = attr.merge(null);

        expect(merged, same(attr));
      });
    });

    group('UtilityTestAttribute with MixProp', () {
      test('creates attribute with MixProp value', () {
        final shadowMix = BoxShadowMix.only(
          color: Colors.black,
          blurRadius: 5.0,
        );
        final attr = UtilityTestAttribute(MixProp(shadowMix));

        expect(attr.value, isA<MixProp<BoxShadow>>());
      });

      test('resolves correctly', () {
        final shadowMix = BoxShadowMix.only(
          color: Colors.red,
          blurRadius: 10.0,
        );
        final attr = UtilityTestAttribute(MixProp(shadowMix));
        final resolved = attr.resolveSpec(mockContext);

        expect(resolved, isA<MockSpec>());
        expect(resolved.resolvedValue, isA<BoxShadow>());

        final shadow = resolved.resolvedValue as BoxShadow;
        expect(shadow.color, Colors.red);
        expect(shadow.blurRadius, 10.0);
      });

      test('merges correctly', () {
        final firstShadow = BoxShadowMix.only(color: Colors.red);
        final secondShadow = BoxShadowMix.only(color: Colors.blue);

        final first = UtilityTestAttribute(MixProp(firstShadow));
        final second = UtilityTestAttribute(MixProp(secondShadow));

        final merged = first.merge(second);

        expect(merged.value, isA<MixProp<BoxShadow>>());
      });

      test('handles null merge', () {
        final shadowMix = BoxShadowMix.only(color: Colors.green);
        final attr = UtilityTestAttribute(MixProp(shadowMix));
        final merged = attr.merge(null);

        expect(merged, same(attr));
      });
    });

    group('MockBuildContext', () {
      test('provides basic context functionality', () {
        final context = MockBuildContext();

        expect(context.mounted, true);
        expect(context.debugDoingBuild, false);
        expect(context.size, const Size(800, 600));
      });

      test('can be created with custom MixScopeData', () {
        final customData = MixScopeData.empty();
        final context = createMockContext(mixScopeData: customData);

        expect(context, isA<MockBuildContext>());
      });
    });

    group('MockSpec', () {
      test('creates with resolved value', () {
        const spec = MockSpec(resolvedValue: 'test');

        expect(spec.resolvedValue, 'test');
      });

      test('lerp returns other spec', () {
        const spec1 = MockSpec(resolvedValue: 'first');
        const spec2 = MockSpec(resolvedValue: 'second');

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped, spec2);
      });

      test('copyWith updates resolved value', () {
        const spec = MockSpec(resolvedValue: 'original');
        final copied = spec.copyWith(resolvedValue: 'updated');

        expect(copied.resolvedValue, 'updated');
      });
    });

    group('Utility Functions', () {
      test('createTestAttribute creates UtilityTestAttribute', () {
        final attr = createTestAttribute(Colors.purple);

        expect(attr, isA<UtilityTestAttribute>());
        expect(attr.value, isA<Prop<Color>>());
      });

      test('createTestDtoAttribute creates UtilityTestDtoAttribute', () {
        final constraintsMix = BoxConstraintsMix.only(maxWidth: 100);
        final attr = createTestDtoAttribute(constraintsMix);

        expect(attr, isA<UtilityTestAttribute>());
        expect(attr.value, isA<MixProp<BoxConstraints>>());
      });

      test('resolveMockProp resolves Prop correctly', () {
        final prop = Prop(Colors.cyan);
        final resolved = resolveMockProp(prop);

        expect(resolved, Colors.cyan);
      });

      test('resolveMockMix resolves Mix correctly', () {
        final constraintsMix = BoxConstraintsMix.only(maxHeight: 200);
        final resolved = resolveMockMix(constraintsMix);

        expect(resolved, isA<BoxConstraints>());
        expect(resolved.maxHeight, 200);
      });
    });

    group('Constants', () {
      test('emptyMixData is available', () {
        expect(emptyMixData, isA<MixScopeData>());
      });

      test('EmptyMixData (backward compatibility) is available', () {
        expect(EmptyMixData, isA<MockBuildContext>());
      });

      test('mockContext is available', () {
        expect(mockContext, isA<MockBuildContext>());
      });
    });
  });
}
