import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

enum ButtonVariant with EnumVariant { primary, secondary, outlined }

enum SizeVariant with EnumVariant { small, medium, large }

void main() {
  group('EnumVariant', () {
    group('name and key', () {
      test('returns the enum value name', () {
        expect(ButtonVariant.primary.name, 'primary');
        expect(ButtonVariant.secondary.name, 'secondary');
        expect(ButtonVariant.outlined.name, 'outlined');
      });

      test('key equals name', () {
        for (final variant in ButtonVariant.values) {
          expect(variant.key, equals(variant.name));
        }
      });

      test('works with different enum types', () {
        expect(SizeVariant.small.name, 'small');
        expect(SizeVariant.medium.name, 'medium');
        expect(SizeVariant.large.name, 'large');
      });
    });

    group('implements NamedVariant', () {
      test('is a NamedVariant', () {
        expect(ButtonVariant.primary, isA<NamedVariant>());
      });

      test('is a Variant', () {
        expect(ButtonVariant.primary, isA<Variant>());
      });
    });

    group('equality', () {
      test('same enum values are equal', () {
        final a = ButtonVariant.primary;
        final b = ButtonVariant.primary;

        expect(a, equals(b));
        expect(identical(a, b), isTrue);
      });

      test('different enum values are not equal', () {
        expect(ButtonVariant.primary, isNot(equals(ButtonVariant.secondary)));
      });

      test('enum variants from different enums are not equal', () {
        // Both have a name that could overlap but are different types
        expect(SizeVariant.small, isNot(equals(ButtonVariant.primary)));
      });

      test('is equal to a NamedVariant with the same name', () {
        const namedPrimary = NamedVariant('primary');
        expect(ButtonVariant.primary, equals(namedPrimary));
      });
    });

    group('VariantStyle integration', () {
      test('can be used in VariantStyle', () {
        final style = BoxStyler().width(100.0);
        final variantStyle = VariantStyle(ButtonVariant.primary, style);

        expect(variantStyle.variant, ButtonVariant.primary);
        expect(variantStyle.mergeKey, 'primary');
      });

      test('different enum values create different mergeKeys', () {
        final primaryStyle = VariantStyle(
          ButtonVariant.primary,
          BoxStyler().width(100.0),
        );
        final secondaryStyle = VariantStyle(
          ButtonVariant.secondary,
          BoxStyler().width(200.0),
        );

        expect(primaryStyle.mergeKey, isNot(equals(secondaryStyle.mergeKey)));
      });
    });

    group('applyVariants integration', () {
      test('applies matching enum variant style', () {
        final style = BoxStyler()
            .variant(ButtonVariant.primary, BoxStyler().width(100.0))
            .variant(ButtonVariant.secondary, BoxStyler().width(200.0));

        final resolved = style.applyVariants([ButtonVariant.primary]);
        final context = MockBuildContext();
        final spec = resolved.resolve(context);

        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.maxWidth, 100.0);
      });

      test('applies multiple enum variants', () {
        final style = BoxStyler()
            .variant(ButtonVariant.primary, BoxStyler().width(100.0))
            .variant(SizeVariant.large, BoxStyler().height(200.0));

        final resolved = style.applyVariants([
          ButtonVariant.primary,
          SizeVariant.large,
        ]);
        final context = MockBuildContext();
        final spec = resolved.resolve(context);

        expect(spec.constraints?.minWidth, 100.0);
        expect(spec.constraints?.maxWidth, 100.0);
        expect(spec.constraints?.minHeight, 200.0);
        expect(spec.constraints?.maxHeight, 200.0);
      });

      test('does not apply non-matching enum variants', () {
        final style = BoxStyler()
            .variant(ButtonVariant.primary, BoxStyler().width(100.0))
            .variant(ButtonVariant.secondary, BoxStyler().width(200.0));

        final resolved = style.applyVariants([ButtonVariant.secondary]);
        final context = MockBuildContext();
        final spec = resolved.resolve(context);

        expect(spec.constraints?.minWidth, 200.0);
        expect(spec.constraints?.maxWidth, 200.0);
      });
    });
  });
}
