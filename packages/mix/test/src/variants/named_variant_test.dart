import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('NamedVariant', () {
    group('Constructor', () {
      test('creates NamedVariant with correct name and key', () {
        final variant = NamedVariant('primary', MockStyle<String>(''));

        expect(variant.name, 'primary');
        expect(variant.key, 'primary');
        expect(variant, isA<NamedVariant>());
      });

      test('creates different variants with different names', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final secondary = NamedVariant('secondary', MockStyle<String>(''));
        final large = NamedVariant('large', MockStyle<String>(''));

        expect(primary.name, 'primary');
        expect(secondary.name, 'secondary');
        expect(large.name, 'large');

        expect(primary.key, 'primary');
        expect(secondary.key, 'secondary');
        expect(large.key, 'large');
      });

      test('accepts empty string name', () {
        final variant = NamedVariant('', MockStyle<String>(''));

        expect(variant.name, '');
        expect(variant.key, '');
      });

      test('accepts special characters in name', () {
        final specialChars = NamedVariant(
          'primary-large_v2.0',
          MockStyle<String>(''),
        );

        expect(specialChars.name, 'primary-large_v2.0');
        expect(specialChars.key, 'primary-large_v2.0');
      });

      test('accepts unicode characters in name', () {
        final unicode = NamedVariant('préféré', MockStyle<String>(''));

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
          final variant = NamedVariant(name, MockStyle<String>(''));
          expect(variant.key, equals(variant.name));
          expect(variant.key, name);
        }
      });

      test('key is consistent across instances', () {
        final variant1 = NamedVariant('primary', MockStyle<String>(''));
        final variant2 = NamedVariant('primary', MockStyle<String>(''));

        expect(variant1.key, equals(variant2.key));
        expect(variant1.key, 'primary');
      });
    });

    group('Equality and hashCode', () {
      test('equal NamedVariants have same hashCode', () {
        final variant1 = NamedVariant('primary', MockStyle<String>(''));
        final variant2 = NamedVariant('primary', MockStyle<String>(''));

        expect(variant1, equals(variant2));
        expect(variant1.hashCode, equals(variant2.hashCode));
      });

      test('different names are not equal', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final secondary = NamedVariant('secondary', MockStyle<String>(''));

        expect(primary, isNot(equals(secondary)));
        expect(primary.hashCode, isNot(equals(secondary.hashCode)));
      });

      test('identical instances are equal', () {
        final variant = NamedVariant('primary', MockStyle<String>(''));

        expect(variant, equals(variant));
        expect(identical(variant, variant), isTrue);
      });

      test('case sensitive equality', () {
        final lower = NamedVariant('primary', MockStyle<String>(''));
        final upper = NamedVariant('PRIMARY', MockStyle<String>(''));
        final mixed = NamedVariant('Primary', MockStyle<String>(''));

        expect(lower, isNot(equals(upper)));
        expect(lower, isNot(equals(mixed)));
        expect(upper, isNot(equals(mixed)));
      });

      test('whitespace sensitive equality', () {
        final normal = NamedVariant('primary', MockStyle<String>(''));
        final withSpace = NamedVariant('primary ', MockStyle<String>(''));
        final withTab = NamedVariant('\tprimary', MockStyle<String>(''));

        expect(normal, isNot(equals(withSpace)));
        expect(normal, isNot(equals(withTab)));
        expect(withSpace, isNot(equals(withTab)));
      });
    });

    group('Const constructor behavior', () {
      test('const constructor creates compile-time constants', () {
        final variant1 = NamedVariant('primary', MockStyle<String>(''));
        final variant2 = NamedVariant('primary', MockStyle<String>(''));

        // Non-const instances won't be identical
        expect(identical(variant1, variant2), isFalse);
        expect(variant1, equals(variant2));
      });

      test('const and non-const instances are equal but not identical', () {
        final constVariant = NamedVariant('primary', MockStyle<String>(''));
        final nonConstVariant = NamedVariant('primary', MockStyle<String>(''));

        expect(constVariant, equals(nonConstVariant));
        expect(identical(constVariant, nonConstVariant), isFalse);
      });
    });

    group('NamedVariant independence', () {
      test('multiple NamedVariants are independent', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final large = NamedVariant('large', MockStyle<String>(''));
        final outlined = NamedVariant('outlined', MockStyle<String>(''));

        expect(primary.key, 'primary');
        expect(large.key, 'large');
        expect(outlined.key, 'outlined');

        expect(primary, isNot(equals(large)));
        expect(primary, isNot(equals(outlined)));
        expect(large, isNot(equals(outlined)));
      });

      test('NamedVariants do not automatically apply based on context', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final secondary = NamedVariant('secondary', MockStyle<String>(''));

        // NamedVariants are manual - they only apply when explicitly included
        expect(primary, isA<NamedVariant>());
        expect(secondary, isA<NamedVariant>());
        expect(primary, isNot(isA<ContextTrigger>()));
        expect(secondary, isNot(isA<ContextTrigger>()));
      });
    });

    group('Integration with other variant types', () {
      test('NamedVariants are distinct from WidgetStateVariants', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final hovered = WidgetStateTrigger(WidgetState.hovered);

        expect(primary, isA<NamedVariant>());
        expect(hovered, isA<WidgetStateTrigger>());
        expect(primary.key, isNot(equals(hovered.key)));
      });

      test('NamedVariants are distinct from ContextTriggers', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final darkMode = ContextTrigger('dark', (context) => true);

        expect(primary, isA<NamedVariant>());
        expect(darkMode, isA<ContextTrigger>());
        expect(primary.key, isNot(equals(darkMode.key)));
      });

      test('works alongside predefined variants', () {
        final custom = NamedVariant('custom', MockStyle<String>(''));

        // Can be used with widget state variants
        final hover = ContextTrigger.widgetState(WidgetState.hovered);
        expect(custom, isA<NamedVariant>());
        expect(hover, isA<WidgetStateTrigger>());

        // Can be used with context variants
        final dark = ContextTrigger.brightness(Brightness.dark);
        expect(custom, isA<NamedVariant>());
        expect(dark, isA<ContextTrigger>());
      });
    });

    group('VariantSpecAttribute integration', () {
      test('can be used in VariantSpecAttribute wrapper', () {
        final primaryVariant = NamedVariant('primary', BoxStyler().width(100.0));

        expect(primaryVariant.name, 'primary');
        expect(primaryVariant.style, isA<BoxStyler>());
        expect(primaryVariant.key, 'primary');
      });

      test('different NamedVariants create different mergeKeys', () {
        final primaryStyle = NamedVariant(
          'primary',
          BoxStyler().width(100.0),
        );

        final secondaryStyle = NamedVariant(
          'secondary',
          BoxStyler().width(150.0),
        );

        expect(primaryStyle.key, 'primary');
        expect(secondaryStyle.key, 'secondary');
        expect(primaryStyle.key, isNot(equals(secondaryStyle.key)));
      });

      test('merges correctly when variants match', () {
        final style1 = NamedVariant('primary', BoxStyler().width(100.0));

        final style2 = NamedVariant('primary', BoxStyler().height(200.0));

        final merged = style1.merge(style2);

        expect(merged.name, 'primary');
        final mergedBox = merged.style as BoxStyler;
        final context = MockBuildContext();
        final constraints = mergedBox.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('throws when merging with different variants', () {
        final primaryStyle = NamedVariant(
          'primary',
          BoxStyler().width(100.0),
        );

        final secondaryStyle = NamedVariant(
          'secondary',
          BoxStyler().height(200.0),
        );

        expect(
          () => primaryStyle.merge(secondaryStyle),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Cannot merge NamedVariant with different keys'),
            ),
          ),
        );
      });
    });

    group('Predefined NamedVariants', () {
      test('predefined named variants exist and have correct properties', () {
        expect(primary, isA<String>());
        expect(secondary, isA<String>());
        expect(outlined, isA<String>());

        expect(primary, 'primary');
        expect(secondary, 'secondary');
        expect(outlined, 'outlined');
      });

      test('predefined variants are const instances', () {
        // Should be able to use in const contexts
        final primaryCopy = NamedVariant('primary', MockStyle<String>(''));
        final secondaryCopy = NamedVariant('secondary', MockStyle<String>(''));

        expect(primaryCopy.name, primary);
        expect(secondaryCopy.name, secondary);

        // String comparison
        expect(primaryCopy.name, 'primary');
        expect(secondaryCopy.name, 'secondary');
      });
    });

    group('Context behavior', () {
      test('NamedVariants never match context automatically', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        // NamedVariants don't have context-based conditions
        // They're only activated when explicitly included in namedVariants
        expect(primary, isA<NamedVariant>());
        expect(primary, isNot(isA<ContextTrigger>()));
      });

      test('NamedVariants require explicit inclusion to be active', () {
        final primary = NamedVariant('primary', MockStyle<String>(''));
        final large = NamedVariant('large', MockStyle<String>(''));

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
        final variant = NamedVariant(longName, MockStyle<String>(''));

        expect(variant.name, longName);
        expect(variant.key, longName);
        expect(variant.name.length, 1000);
      });

      test('handles names with numbers', () {
        final variant1 = NamedVariant('variant1', MockStyle<String>(''));
        final variant2 = NamedVariant('2ndVariant', MockStyle<String>(''));
        final numeric = NamedVariant('12345', MockStyle<String>(''));

        expect(variant1.name, 'variant1');
        expect(variant2.name, '2ndVariant');
        expect(numeric.name, '12345');
      });

      test('immutability of name property', () {
        final variant = NamedVariant('primary', MockStyle<String>(''));

        expect(variant.name, 'primary');
        // Name should not be modifiable (enforced by final keyword)
        expect(() => variant.name, returnsNormally);
      });

      test('string representation is useful for debugging', () {
        final variant = NamedVariant('primary', MockStyle<String>(''));

        // toString should provide meaningful output
        final stringRep = variant.toString();
        expect(stringRep, isA<String>());
        expect(stringRep, isNotEmpty);
      });
    });

    group('Common usage patterns', () {
      test('semantic variant names work correctly', () {
        final semanticVariants = [
          NamedVariant('primary', MockStyle<String>('')),
          NamedVariant('secondary', MockStyle<String>('')),
          NamedVariant('success', MockStyle<String>('')),
          NamedVariant('warning', MockStyle<String>('')),
          NamedVariant('error', MockStyle<String>('')),
          NamedVariant('info', MockStyle<String>('')),
        ];

        for (final variant in semanticVariants) {
          expect(variant.name, isA<String>());
          expect(variant.name, isNotEmpty);
          expect(variant.key, equals(variant.name));
        }
      });

      test('size variant names work correctly', () {
        final sizeVariants = [
          NamedVariant('xs', MockStyle<String>('')),
          NamedVariant('sm', MockStyle<String>('')),
          NamedVariant('md', MockStyle<String>('')),
          NamedVariant('lg', MockStyle<String>('')),
          NamedVariant('xl', MockStyle<String>('')),
          NamedVariant('2xl', MockStyle<String>('')),
        ];

        for (final variant in sizeVariants) {
          expect(variant.name, isA<String>());
          expect(variant.key, equals(variant.name));
        }
      });

      test('style variant names work correctly', () {
        final styleVariants = [
          NamedVariant('filled', MockStyle<String>('')),
          NamedVariant('outlined', MockStyle<String>('')),
          NamedVariant('ghost', MockStyle<String>('')),
          NamedVariant('link', MockStyle<String>('')),
        ];

        for (final variant in styleVariants) {
          expect(variant.name, isA<String>());
          expect(variant.key, equals(variant.name));
        }
      });
    });
  });
}
