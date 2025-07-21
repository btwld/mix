import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  // ShadowMix tests
  group('ShadowMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor with raw values', () {
        final mix = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(mix.blurRadius, resolvesTo(10.0));
        expect(mix.color, resolvesTo(Colors.blue));
        expect(mix.offset, resolvesTo(const Offset(10, 10)));
      });

      test('main constructor with Prop values', () {
        final mix = ShadowMix(
          blurRadius: Prop(5.0),
          color: Prop(Colors.red),
          offset: Prop(const Offset(5, 5)),
        );

        expect(mix.blurRadius, resolvesTo(5.0));
        expect(mix.color, resolvesTo(Colors.red));
        expect(mix.offset, resolvesTo(const Offset(5, 5)));
      });

      test('value constructor from Shadow', () {
        const shadow = Shadow(
          blurRadius: 15.0,
          color: Colors.green,
          offset: Offset(15, 15),
        );
        final mix = ShadowMix.value(shadow);

        expect(mix.blurRadius, resolvesTo(shadow.blurRadius));
        expect(mix.color, resolvesTo(shadow.color));
        expect(mix.offset, resolvesTo(shadow.offset));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns ShadowMix for non-null Shadow', () {
        const shadow = Shadow(blurRadius: 8.0, color: Colors.purple);
        final mix = ShadowMix.maybeValue(shadow);

        expect(mix, isNotNull);
        expect(mix?.blurRadius, resolvesTo(shadow.blurRadius));
        expect(mix?.color, resolvesTo(shadow.color));
      });

      test('maybeValue returns null for null Shadow', () {
        final mix = ShadowMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to Shadow with all properties', () {
        final mix = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );

        expect(
          dto,
          resolvesTo(
            const Shadow(
              blurRadius: 10.0,
              color: Colors.blue,
              offset: Offset(10, 10),
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = ShadowMix();

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.blurRadius, 0.0);
        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
      });

      test('resolves with partial properties', () {
        final mix = ShadowMix.only(color: Colors.red);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.color, Colors.red);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.offset, Offset.zero);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another ShadowMix - all properties', () {
        final mix1 = ShadowMix.only(
          blurRadius: 10.0,
          color: Colors.blue,
          offset: const Offset(10, 10),
        );
        final mix2 = ShadowMix.only(
          blurRadius: 20.0,
          color: Colors.red,
          offset: const Offset(20, 20),
        );

        final merged = dto1.merge(mix2);

        expect(merged.blurRadius, resolvesTo(20.0));
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, resolvesTo(const Offset(20, 20)));
      });

      test('merge with another ShadowMix - partial properties', () {
        final mix1 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);
        final mix2 = ShadowMix.only(color: Colors.red);

        final merged = dto1.merge(mix2);

        expect(merged.blurRadius, resolvesTo(10.0));
        expect(merged.color, resolvesTo(Colors.red));
        expect(merged.offset, isNull);
      });

      test('merge with null returns original', () {
        final mix = ShadowMix.only(blurRadius: 5.0, color: Colors.purple);

        final merged = mix.merge(null);

        expect(merged, equals(mix));
      });
    });

    // Equality Tests
    group('Equality Tests', () {
      test('equality works correctly', () {
        final mix1 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);
        final mix2 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);

        expect(mix1, equals(mix2));
      });

      test('inequality works correctly', () {
        final mix1 = ShadowMix.only(blurRadius: 10.0, color: Colors.blue);
        final mix2 = ShadowMix.only(blurRadius: 10.0, color: Colors.red);

        expect(mix1, isNot(equals(mix2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles zero blur radius', () {
        final mix = ShadowMix.only(blurRadius: 0.0, color: Colors.black);

        expect(mix.blurRadius, resolvesTo(0.0));
      });

      test('handles negative blur radius', () {
        final mix = ShadowMix.only(blurRadius: -5.0, color: Colors.black);

        expect(mix.blurRadius, resolvesTo(-5.0));
      });

      test('handles transparent color', () {
        final mix = ShadowMix.only(color: Colors.transparent, blurRadius: 10.0);

        expect(mix.color, resolvesTo(Colors.transparent));
      });
    });
  });

  // BoxShadowMix tests
  group('BoxShadowMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor with raw values', () {
        final mix = BoxShadowMix.only(
          color: Colors.red,
          offset: const Offset(5, 5),
          blurRadius: 8.0,
          spreadRadius: 2.0,
        );

        expect(mix.color, resolvesTo(Colors.red));
        expect(mix.offset, resolvesTo(const Offset(5, 5)));
        expect(mix.blurRadius, resolvesTo(8.0));
        expect(mix.spreadRadius, resolvesTo(2.0));
      });

      test('main constructor with Prop values', () {
        final mix = BoxShadowMix(
          color: Prop(Colors.red),
          offset: Prop(const Offset(5, 5)),
          blurRadius: Prop(8.0),
          spreadRadius: Prop(3.0),
        );

        expect(mix.color, resolvesTo(Colors.red));
        expect(mix.offset, resolvesTo(const Offset(5, 5)));
        expect(mix.blurRadius, resolvesTo(8.0));
        expect(mix.spreadRadius, resolvesTo(5.0));
      });

      test('value constructor from BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.grey,
          offset: Offset(3, 3),
          blurRadius: 6.0,
          spreadRadius: 1.0,
        );
        final mix = BoxShadowMix.value(boxShadow);

        expect(mix.color, resolvesTo(boxShadow.color));
        expect(mix.offset, resolvesTo(boxShadow.offset));
        expect(mix.blurRadius, resolvesTo(boxShadow.blurRadius));
        expect(mix.spreadRadius, resolvesTo(boxShadow.spreadRadius));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns BoxShadowMix for non-null BoxShadow', () {
        const boxShadow = BoxShadow(
          color: Colors.grey,
          blurRadius: 10.0,
          spreadRadius: 2.0,
        );
        final mix = BoxShadowMix.maybeValue(boxShadow);

        expect(mix, isNotNull);
        expect(mix?.color, resolvesTo(boxShadow.color));
        expect(mix?.blurRadius, resolvesTo(boxShadow.blurRadius));
        expect(mix?.spreadRadius, resolvesTo(boxShadow.spreadRadius));
      });

      test('maybeValue returns null for null BoxShadow', () {
        final mix = BoxShadowMix.maybeValue(null);
        expect(mix, isNull);
      });

      test('fromElevation creates correct shadows', () {
        final shadows = BoxShadowMix.fromElevation(ElevationShadow.four);

        expect(shadows.length, 2);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to BoxShadow with all properties', () {
        final mix = BoxShadowMix.only(
          color: Colors.grey,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
          spreadRadius: 1.0,
        );

        expect(
          dto,
          resolvesTo(
            const BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = BoxShadowMix();

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.color, const Color(0xFF000000));
        expect(resolved.offset, Offset.zero);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.spreadRadius, 0.0);
      });

      test('resolves with partial properties', () {
        final mix = BoxShadowMix.only(color: Colors.red, spreadRadius: 3.0);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.color, Colors.red);
        expect(resolved.spreadRadius, 3.0);
        expect(resolved.blurRadius, 0.0);
        expect(resolved.offset, Offset.zero);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another BoxShadowMix - all properties', () {
        final mix1 = BoxShadowMix.only(
          color: Colors.blue,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final mix2 = BoxShadowMix.only(color: Colors.green, blurRadius: 15.0);

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.green));
        expect(merged.blurRadius, resolvesTo(15.0));
        expect(merged.spreadRadius, resolvesTo(2.0));
      });

      test('merge with another BoxShadowMix - partial properties', () {
        final mix1 = BoxShadowMix.only(color: Colors.blue, spreadRadius: 5.0);
        final mix2 = BoxShadowMix.only(color: Colors.blue, spreadRadius: 10.0);

        final merged = dto1.merge(mix2);

        expect(merged.color, resolvesTo(Colors.blue));
        expect(merged.spreadRadius, resolvesTo(10.0));
        expect(merged.blurRadius, isNull);
        expect(merged.offset, isNull);
      });

      test('merge with null returns original', () {
        final mix = BoxShadowMix.only(color: Colors.black, blurRadius: 10.0);

        final merged = mix.merge(null);

        expect(merged, equals(mix));
      });
    });

    // Equality Tests
    group('Equality Tests', () {
      test('equality works correctly', () {
        final mix1 = BoxShadowMix.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final mix2 = BoxShadowMix.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );

        expect(mix1, equals(mix2));
      });

      test('inequality works correctly', () {
        final mix1 = BoxShadowMix.only(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );
        final mix2 = BoxShadowMix.only(
          color: Colors.black,
          blurRadius: 5.0,
          spreadRadius: 2.0,
        );

        expect(mix1, isNot(equals(mix2)));
      });
    });

    // Utility Tests
    group('Utility Tests', () {
      test('merge behavior preserves later values', () {
        final baseShadow = BoxShadowMix.only(
          color: Colors.black,
          blurRadius: 5.0,
        );
        final overrideShadow = BoxShadowMix.only(
          color: Colors.red,
          spreadRadius: 3.0,
        );
        final finalShadow = BoxShadowMix.only(offset: const Offset(2, 4));

        final result = baseShadow.merge(overrideShadow).merge(finalShadow);

        expect(result.color, resolvesTo(Colors.red));
        expect(result.blurRadius, resolvesTo(5.0));
        expect(result.spreadRadius, resolvesTo(3.0));
        expect(result.offset, resolvesTo(const Offset(2, 4)));
      });
    });
  });
}
