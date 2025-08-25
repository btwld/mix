import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('NamedVariant', () {
    group('Constructor', () {
      test('creates NamedVariant with correct name and key', () {
        const variant = NamedVariant('primary');

        expect(variant.name, 'primary');
        expect(variant.key, 'primary');
        expect(variant, isA<Variant>());
      });

      test('creates different variants with different names', () {
        const primary = NamedVariant('primary');
        const secondary = NamedVariant('secondary');
        const large = NamedVariant('large');

        expect(primary.name, 'primary');
        expect(secondary.name, 'secondary');
        expect(large.name, 'large');

        expect(primary.key, 'primary');
        expect(secondary.key, 'secondary');
        expect(large.key, 'large');
      });

      test('accepts empty string name', () {
        const variant = NamedVariant('');

        expect(variant.name, '');
        expect(variant.key, '');
      });

      test('accepts special characters in name', () {
        const specialChars = NamedVariant('primary-large_v2.0');

        expect(specialChars.name, 'primary-large_v2.0');
        expect(specialChars.key, 'primary-large_v2.0');
      });

      test('accepts unicode characters in name', () {
        const unicode = NamedVariant('préféré');

        expect(unicode.name, 'préféré');
        expect(unicode.key, 'préféré');
      });
    });

    group('Key property', () {
      test('key equals name', () {
        const testNames = [
          'primary',
          'secondary',
          'large',
          'small',
          'outlined',
          'filled',
          'custom-variant',
          'variant_with_underscores',
          '123numeric',
        ];

        for (final name in testNames) {
          final variant = NamedVariant(name);
          expect(variant.key, equals(variant.name));
          expect(variant.key, name);
        }
      });

      test('key is consistent across instances', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('primary');

        expect(variant1.key, equals(variant2.key));
        expect(variant1.key, 'primary');
      });
    });

    group('Equality and hashCode', () {
      test('equal NamedVariants have same hashCode', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('primary');

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different names are not equal', () {
        const primary = NamedVariant('primary');
        const secondary = NamedVariant('secondary');

        expect(primary, isNot(equals(secondary)));
        expect(primary.hashCode, isNot(equals(secondary.hashCode)));
      });

      test('identical instances are equal', () {
        const variant = NamedVariant('primary');

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });

      test('case sensitive equality', () {
        const lower = NamedVariant('primary');
        const upper = NamedVariant('PRIMARY');
        const mixed = NamedVariant('Primary');

        expect(lower, isNot(equals(upper)));
        expect(lower, isNot(equals(mixed)));
        expect(upper, isNot(equals(mixed)));
      });

      test('whitespace sensitive equality', () {
        const normal = NamedVariant('primary');
        const withSpace = NamedVariant('primary ');
        const withTab = NamedVariant('\tprimary');

        expect(normal, isNot(equals(withSpace)));
        expect(normal, isNot(equals(withTab)));
        expect(withSpace, isNot(equals(withTab)));
      });
    });

    group('Const constructor behavior', () {
      test('const constructor creates compile-time constants', () {
        const variant1 = NamedVariant('primary');
        const variant2 = NamedVariant('primary');

        // Const instances with same value should be identical
        expect(identical(variant1, variant2), isTrue);
        expect(variant1, same(variant2));
      });

      test('const and non-const instances are equal but not identical', () {
        const constVariant = NamedVariant('primary');
        final nonConstVariant = NamedVariant('primary');

        expect(constVariant, equals(nonConstVariant));
        expect(identical(constVariant, nonConstVariant), isFalse);
      });
    });

    group('NamedVariant independence', () {
      test('multiple NamedVariants are independent', () {
        const primary = NamedVariant('primary');
        const large = NamedVariant('large');
        const outlined = NamedVariant('outlined');

        expect(primary.key, 'primary');
        expect(large.key, 'large');
        expect(outlined.key, 'outlined');

        expect(primary, isNot(equals(large)));
        expect(primary, isNot(equals(outlined)));
        expect(large, isNot(equals(outlined)));
      });

      test('NamedVariants do not automatically apply based on context', () {
        const primary = NamedVariant('primary');
        const secondary = NamedVariant('secondary');

        // NamedVariants are manual - they only apply when explicitly included
        expect(primary, isA<NamedVariant>());
        expect(secondary, isA<NamedVariant>());
        expect(primary, isNot(isA<ContextVariant>()));
        expect(secondary, isNot(isA<ContextVariant>()));
      });
    });

    group('Integration with other variant types', () {
      test('NamedVariants are distinct from WidgetStateVariants', () {
        const primary = NamedVariant('primary');
        final hovered = WidgetStateVariant(WidgetState.hovered);

        expect(primary, isA<NamedVariant>());
        expect(hovered, isA<WidgetStateVariant>());
        expect(primary.key, isNot(equals(hovered.key)));
      });

      test('NamedVariants are distinct from ContextVariants', () {
        const primary = NamedVariant('primary');
        final darkMode = ContextVariant('dark', (context) => true);

        expect(primary, isA<NamedVariant>());
        expect(darkMode, isA<ContextVariant>());
        expect(primary.key, isNot(equals(darkMode.key)));
      });

      test('works alongside predefined variants', () {
        const custom = NamedVariant('custom');

        // Can be used with widget state variants
        final hover = ContextVariant.widgetState(WidgetState.hovered);
        expect(custom, isA<NamedVariant>());
        expect(hover, isA<WidgetStateVariant>());

        // Can be used with context variants
        final dark = ContextVariant.brightness(Brightness.dark);
        expect(custom, isA<NamedVariant>());
        expect(dark, isA<ContextVariant>());
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be used in VariantSpecAttribute wrapper', () {
        const primaryVariant = NamedVariant('primary');
        final style = BoxStyle.width(100.0);
        final variantAttr = VariantStyle(primaryVariant, style);

        expect(variantAttr.variant, primaryVariant);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, 'primary');
      });

      test('different NamedVariants create different mergeKeys', () {
        const primaryVariant = NamedVariant('primary');
        const secondaryVariant = NamedVariant('secondary');

        final primaryStyle = VariantStyle(
          primaryVariant,
          BoxStyle.width(100.0),
        );

        final secondaryStyle = VariantStyle(
          secondaryVariant,
          BoxStyle.width(150.0),
        );

        expect(primaryStyle.mergeKey, 'primary');
        expect(secondaryStyle.mergeKey, 'secondary');
        expect(primaryStyle.mergeKey, isNot(equals(secondaryStyle.mergeKey)));
      });

      test('merges correctly when variants match', () {
        const primaryVariant = NamedVariant('primary');

        final style1 = VariantStyle(primaryVariant, BoxStyle.width(100.0));

        final style2 = VariantStyle(primaryVariant, BoxStyle.height(200.0));

        final merged = style1.merge(style2);

        expect(merged.variant, primaryVariant);
        final mergedBox = merged.value as BoxStyle;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('does not merge when variants differ', () {
        const primaryVariant = NamedVariant('primary');
        const secondaryVariant = NamedVariant('secondary');

        final primaryStyle = VariantStyle(
          primaryVariant,
          BoxStyle.width(100.0),
        );

        final secondaryStyle = VariantStyle(
          secondaryVariant,
          BoxStyle.height(200.0),
        );

        final merged = primaryStyle.merge(secondaryStyle);

        expect(merged, same(primaryStyle));
        final mergedBox = merged.value as BoxStyle;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 0.0);
        expect(constraints?.maxHeight, double.infinity);
      });
    });

    group('Predefined NamedVariants', () {
      test('predefined named variants exist and have correct properties', () {
        expect(primary, isA<NamedVariant>());
        expect(secondary, isA<NamedVariant>());
        expect(outlined, isA<NamedVariant>());

        expect(primary.name, 'primary');
        expect(secondary.name, 'secondary');
        expect(outlined.name, 'outlined');

        expect(primary.key, 'primary');
        expect(secondary.key, 'secondary');
        expect(outlined.key, 'outlined');
      });

      test('predefined variants are const instances', () {
        // Should be able to use in const contexts
        const primaryCopy = NamedVariant('primary');
        const secondaryCopy = NamedVariant('secondary');

        expect(primary, equals(primaryCopy));
        expect(secondary, equals(secondaryCopy));

        // Const instances should be identical
        expect(identical(primary, primaryCopy), isTrue);
        expect(identical(secondary, secondaryCopy), isTrue);
      });
    });

    group('Context behavior', () {
      test('NamedVariants never match context automatically', () {
        const primary = NamedVariant('primary');
        // NamedVariants don't have context-based conditions
        // They're only activated when explicitly included in namedVariants
        expect(primary, isA<NamedVariant>());
        expect(primary, isNot(isA<ContextVariant>()));
      });

      test('NamedVariants require explicit inclusion to be active', () {
        const primary = NamedVariant('primary');
        const large = NamedVariant('large');

        // NamedVariants are manual - they don't have when() method
        // They're only active when explicitly included in namedVariants set
        expect(primary, isA<NamedVariant>());
        expect(large, isA<NamedVariant>());
        expect(primary.key, 'primary');
        expect(large.key, 'large');
      });
    });

    group('Edge cases and validation', () {
      test('handles very long names', () {
        final longName = 'a' * 1000; // 1000 character name
        final variant = NamedVariant(longName);

        expect(variant.name, longName);
        expect(variant.key, longName);
        expect(variant.name.length, 1000);
      });

      test('handles names with numbers', () {
        const variant1 = NamedVariant('variant1');
        const variant2 = NamedVariant('2ndVariant');
        const numeric = NamedVariant('12345');

        expect(variant1.name, 'variant1');
        expect(variant2.name, '2ndVariant');
        expect(numeric.name, '12345');
      });

      test('immutability of name property', () {
        const variant = NamedVariant('primary');

        expect(variant.name, 'primary');
        // Name should not be modifiable (enforced by final keyword)
        expect(() => variant.name, returnsNormally);
      });

      test('string representation is useful for debugging', () {
        const variant = NamedVariant('primary');

        // toString should provide meaningful output
        final stringRep = variant.toString();
        expect(stringRep, isA<String>());
        expect(stringRep, isNotEmpty);
      });
    });

    group('Common usage patterns', () {
      test('semantic variant names work correctly', () {
        const semanticVariants = [
          NamedVariant('primary'),
          NamedVariant('secondary'),
          NamedVariant('success'),
          NamedVariant('warning'),
          NamedVariant('error'),
          NamedVariant('info'),
        ];

        for (final variant in semanticVariants) {
          expect(variant.name, isA<String>());
          expect(variant.name, isNotEmpty);
          expect(variant.key, equals(variant.name));
        }
      });

      test('size variant names work correctly', () {
        const sizeVariants = [
          NamedVariant('xs'),
          NamedVariant('sm'),
          NamedVariant('md'),
          NamedVariant('lg'),
          NamedVariant('xl'),
          NamedVariant('2xl'),
        ];

        for (final variant in sizeVariants) {
          expect(variant.name, isA<String>());
          expect(variant.key, equals(variant.name));
        }
      });

      test('style variant names work correctly', () {
        const styleVariants = [
          NamedVariant('filled'),
          NamedVariant('outlined'),
          NamedVariant('ghost'),
          NamedVariant('link'),
        ];

        for (final variant in styleVariants) {
          expect(variant.name, isA<String>());
          expect(variant.key, equals(variant.name));
        }
      });
    });
  });
}
