import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariantBuilder', () {
    group('Constructor', () {
      test('creates builder with function', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        expect(builder, isA<ContextVariantBuilder<BoxStyle>>());
        expect(builder, isA<Variant>());
        expect(builder.fn, isA<Function>());
      });

      test('accepts different SpecAttribute types', () {
        final boxBuilder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        final flexBuilder = ContextVariantBuilder<FlexStyle>(
          (context) => FlexStyle(),
        );

        expect(boxBuilder, isA<ContextVariantBuilder<BoxStyle>>());
        expect(flexBuilder, isA<ContextVariantBuilder<FlexStyle>>());
      });

      test('stores function correctly', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(200.0);
        }

        final builder = ContextVariantBuilder<BoxStyle>(builderFunction);

        expect(builder.fn, same(builderFunction));
      });

      test('accepts anonymous functions', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().height(50.0),
        );

        expect(builder.fn, isA<Function>());
      });

      test('accepts closures with captured variables', () {
        const capturedWidth = 150.0;
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(capturedWidth),
        );

        expect(builder.fn, isA<Function>());
        final result = builder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, capturedWidth);
        expect(constraints?.maxWidth, capturedWidth);
      });
    });

    group('Key generation', () {
      test('key is based on function hashCode', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(100.0);
        }

        final builder = ContextVariantBuilder<BoxStyle>(builderFunction);

        expect(builder.key, builderFunction.hashCode.toString());
      });

      test('different functions have different keys', () {
        final builder1 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(200.0),
        );

        expect(builder1.key, isNot(equals(builder2.key)));
      });

      test('same function reference has same key', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(100.0);
        }

        final builder1 = ContextVariantBuilder<BoxStyle>(builderFunction);
        final builder2 = ContextVariantBuilder<BoxStyle>(builderFunction);

        expect(builder1.key, equals(builder2.key));
      });

      test('key is consistent across calls', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        final key1 = builder.key;
        final key2 = builder.key;

        expect(key1, equals(key2));
      });
    });

    group('Equality and hashCode', () {
      test('equality based on function reference', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(100.0);
        }

        final builder1 = ContextVariantBuilder<BoxStyle>(builderFunction);
        final builder2 = ContextVariantBuilder<BoxStyle>(builderFunction);

        expect(builder1, equals(builder2));
        expect(builder1.hashCode, equals(builder2.hashCode));
      });

      test('different functions are not equal', () {
        final builder1 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        expect(builder1, isNot(equals(builder2)));
        expect(builder1.hashCode, isNot(equals(builder2.hashCode)));
      });

      test('identical instances are equal', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        expect(builder, equals(builder));
        expect(identical(builder, builder), isTrue);
      });

      test('hashCode is consistent', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        final hashCode1 = builder.hashCode;
        final hashCode2 = builder.hashCode;

        expect(hashCode1, equals(hashCode2));
      });

      test('hashCode matches function hashCode', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(100.0);
        }

        final builder = ContextVariantBuilder<BoxStyle>(builderFunction);

        expect(builder.hashCode, equals(builderFunction.hashCode));
      });
    });

    group('build method', () {
      test('calls function with provided context', () {
        BuildContext? capturedContext;
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          capturedContext = context;
          return BoxStyle().width(100.0);
        });

        final mockContext = MockBuildContext();
        builder.build(mockContext);

        expect(capturedContext, same(mockContext));
      });

      test('returns function result', () {
        final expectedAttribute = BoxStyle().width(150.0);
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => expectedAttribute,
        );

        final result = builder.build(MockBuildContext());

        expect(result, same(expectedAttribute));
      });

      test('works with different SpecAttribute types', () {
        final boxBuilder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final flexBuilder = ContextVariantBuilder<FlexStyle>(
          (context) => FlexStyle(),
        );

        final context = MockBuildContext();
        final boxResult = boxBuilder.build(context);
        final flexResult = flexBuilder.build(context);

        expect(boxResult, isA<BoxStyle>());
        expect(flexResult, isA<FlexStyle>());
      });

      test('function can access context properties', () {
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          final size = context.size ?? const Size(800, 600);
          return BoxStyle().width(size.width);
        });

        final result = builder.build(MockBuildContext());

        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 800.0);
        expect(constraints?.maxWidth, 800.0);
      });

      test('can create different attributes based on context', () {
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          final size = context.size ?? const Size(800, 600);
          return size.width > 1000
              ? BoxStyle().width(200.0)
              : BoxStyle().width(100.0);
        });

        final smallContext = MockBuildContext();
        final result = builder.build(smallContext);

        // MockBuildContext has size (800, 600) which is <= 1000
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
      });
    });

    group('Generic type handling', () {
      test('maintains generic type information', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<BoxStyle>());
      });

      test('different generic types create different builder types', () {
        final boxBuilder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final flexBuilder = ContextVariantBuilder<FlexStyle>(
          (context) => FlexStyle(),
        );

        expect(boxBuilder.runtimeType, isNot(equals(flexBuilder.runtimeType)));
      });

      test('can work with base SpecAttribute type', () {
        final builder = ContextVariantBuilder<Style>(
          (context) => BoxStyle().width(100.0),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<Style>());
        expect(result, isA<BoxStyle>());
      });
    });

    group('MultiVariant integration', () {
      test('can be used with other variants', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final contextVariant = ContextVariant('test', (context) => true);

        // Both are separate variants that can be used independently
        expect(builder, isA<ContextVariantBuilder>());
        expect(contextVariant, isA<ContextVariant>());
        expect(builder, isNot(equals(contextVariant)));
      });

      test('can be used alongside named variants', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        const namedVariant = NamedVariant('primary');

        // Both can be used independently
        expect(builder, isA<ContextVariantBuilder>());
        expect(namedVariant, isA<NamedVariant>());
        expect(builder.key, isNot(equals(namedVariant.key)));
      });

      test('can use ContextVariant.not for negation', () {
        final contextVariant = ContextVariant.widgetState(WidgetState.disabled);
        final notVariant = ContextVariant.not(contextVariant);

        expect(notVariant, isA<ContextVariant>());
        expect(notVariant.key, contains('not'));
      });
    });

    group('Complex scenarios', () {
      test(
        'function can return different attributes based on complex logic',
        () {
          final builder = ContextVariantBuilder<BoxStyle>((context) {
            final size = context.size ?? const Size(800, 600);
            final width = switch (size.width) {
              <= 480 => 50.0,
              <= 768 => 100.0,
              <= 1024 => 150.0,
              _ => 200.0,
            };
            return BoxStyle().width(width);
          });

          final result = builder.build(MockBuildContext());
          // MockBuildContext has width 800, which falls in 768 < width <= 1024
          final context = MockBuildContext();
          final constraints = result.resolve(context).constraints;
          expect(constraints?.minWidth, 150.0);
          expect(constraints?.maxWidth, 150.0);
        },
      );

      test('can create attributes with multiple properties', () {
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          return BoxStyle(
            constraints: BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 100.0,
              minHeight: 200.0,
              maxHeight: 200.0,
            ),
          );
        });

        final result = builder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 200.0);
        expect(constraints?.maxHeight, 200.0);
      });

      test('function can throw exceptions', () {
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          throw Exception('Test exception');
        });

        expect(() => builder.build(MockBuildContext()), throwsException);
      });

      test('can capture variables from outer scope', () {
        const baseWidth = 50.0;
        const multiplier = 3;

        final builder = ContextVariantBuilder<BoxStyle>((context) {
          return BoxStyle().width(baseWidth * multiplier);
        });

        final result = builder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 150.0);
        expect(constraints?.maxWidth, 150.0);
      });
    });

    group('Edge cases', () {
      test('handles function that returns const attributes', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle(),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<BoxStyle>());
      });

      test('function parameters are properly typed', () {
        final builder = ContextVariantBuilder<BoxStyle>((context) {
          // This should compile without issues - context is properly typed
          expect(context, isA<BuildContext>());
          return BoxStyle().width(100.0);
        });

        builder.build(MockBuildContext());
      });

      test('maintains const constructor', () {
        BoxStyle builderFunction(BuildContext context) {
          return BoxStyle().width(100.0);
        }

        expect(
          () => ContextVariantBuilder<BoxStyle>(builderFunction),
          returnsNormally,
        );
      });
    });

    group('Integration with other Mix components', () {
      test('can be used in Style resolution context', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );

        // ContextVariantBuilder should integrate with the broader Mix system
        expect(builder, isA<Variant>());
        expect(builder.key, isA<String>());
        expect(builder.key.isNotEmpty, isTrue);
      });

      test('works with VariantSpecAttribute wrapper', () {
        final builder = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final style = BoxStyle().height(200.0);
        final variantAttr = VariantStyle(builder, style);

        expect(variantAttr.variant, builder);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, builder.key);
      });

      test('key works as mergeKey for VariantSpecAttribute', () {
        final builder1 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxStyle>(
          (context) => BoxStyle().width(200.0),
        );

        final style1 = VariantStyle(builder1, BoxStyle().height(100.0));
        final style2 = VariantStyle(builder2, BoxStyle().height(200.0));

        expect(style1.mergeKey, builder1.key);
        expect(style2.mergeKey, builder2.key);
        expect(style1.mergeKey, isNot(equals(style2.mergeKey)));
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates context-based styling pattern', () {
        // This test documents common usage patterns
        final responsiveBuilder = ContextVariantBuilder<BoxStyle>((context) {
          final size = context.size ?? const Size(800, 600);
          return BoxStyle().width(size.width > 768 ? 200.0 : 100.0);
        });

        final result = responsiveBuilder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 200.0);
        expect(constraints?.maxWidth, 200.0); // MockBuildContext width is 800
      });

      test('demonstrates theme-based styling pattern', () {
        final themeBuilder = ContextVariantBuilder<BoxStyle>((context) {
          // In a real scenario, this would access Theme.of(context)
          // For testing, we'll simulate theme-based logic
          return BoxStyle().width(120.0);
        });

        final result = themeBuilder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 120.0);
        expect(constraints?.maxWidth, 120.0);
      });

      test('demonstrates utility for conditional attribute creation', () {
        final conditionalBuilder = ContextVariantBuilder<BoxStyle>((context) {
          // Always return fixed size for this test
          return BoxStyle(
            constraints: BoxConstraintsMix(
              minWidth: 100.0,
              maxWidth: 100.0,
              minHeight: 100.0,
              maxHeight: 100.0,
            ),
          );
        });

        final result = conditionalBuilder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 100.0);
        expect(constraints?.maxHeight, 100.0);
      });
    });
  });
}
