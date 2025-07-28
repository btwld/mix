import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ContextVariantBuilder', () {
    group('Constructor', () {
      test('creates builder with function', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        expect(builder, isA<ContextVariantBuilder<BoxSpecAttribute>>());
        expect(builder, isA<Variant>());
        expect(builder.fn, isA<Function>());
      });

      test('accepts different SpecAttribute types', () {
        final boxBuilder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        final flexBuilder = ContextVariantBuilder<FlexSpecAttribute>(
          (context) => FlexSpecAttribute(),
        );

        expect(boxBuilder, isA<ContextVariantBuilder<BoxSpecAttribute>>());
        expect(flexBuilder, isA<ContextVariantBuilder<FlexSpecAttribute>>());
      });

      test('stores function correctly', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(200.0);
        }

        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );

        expect(builder.fn, same(builderFunction));
      });

      test('accepts anonymous functions', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().height(50.0),
        );

        expect(builder.fn, isA<Function>());
      });

      test('accepts closures with captured variables', () {
        const capturedWidth = 150.0;
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(capturedWidth),
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
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );

        expect(builder.key, builderFunction.hashCode.toString());
      });

      test('different functions have different keys', () {
        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(200.0),
        );

        expect(builder1.key, isNot(equals(builder2.key)));
      });

      test('same function reference has same key', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );

        expect(builder1.key, equals(builder2.key));
      });

      test('key is consistent across calls', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        final key1 = builder.key;
        final key2 = builder.key;

        expect(key1, equals(key2));
      });
    });

    group('Equality and hashCode', () {
      test('equality based on function reference', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );

        expect(builder1, equals(builder2));
        expect(builder1.hashCode, equals(builder2.hashCode));
      });

      test('different functions are not equal', () {
        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        expect(builder1, isNot(equals(builder2)));
        expect(builder1.hashCode, isNot(equals(builder2.hashCode)));
      });

      test('identical instances are equal', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        expect(builder, equals(builder));
        expect(identical(builder, builder), isTrue);
      });

      test('hashCode is consistent', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        final hashCode1 = builder.hashCode;
        final hashCode2 = builder.hashCode;

        expect(hashCode1, equals(hashCode2));
      });

      test('hashCode matches function hashCode', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );

        expect(builder.hashCode, equals(builderFunction.hashCode));
      });
    });

    group('build method', () {
      test('calls function with provided context', () {
        BuildContext? capturedContext;
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          capturedContext = context;
          return BoxSpecAttribute().width(100.0);
        });

        final mockContext = MockBuildContext();
        builder.build(mockContext);

        expect(capturedContext, same(mockContext));
      });

      test('returns function result', () {
        final expectedAttribute = BoxSpecAttribute().width(150.0);
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => expectedAttribute,
        );

        final result = builder.build(MockBuildContext());

        expect(result, same(expectedAttribute));
      });

      test('works with different SpecAttribute types', () {
        final boxBuilder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final flexBuilder = ContextVariantBuilder<FlexSpecAttribute>(
          (context) => FlexSpecAttribute(),
        );

        final context = MockBuildContext();
        final boxResult = boxBuilder.build(context);
        final flexResult = flexBuilder.build(context);

        expect(boxResult, isA<BoxSpecAttribute>());
        expect(flexResult, isA<FlexSpecAttribute>());
      });

      test('function can access context properties', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          final size = context.size ?? const Size(800, 600);
          return BoxSpecAttribute().width(size.width);
        });

        final result = builder.build(MockBuildContext());

        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 800.0);
        expect(constraints?.maxWidth, 800.0);
      });

      test('can create different attributes based on context', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          final size = context.size ?? const Size(800, 600);
          return size.width > 1000
              ? BoxSpecAttribute().width(200.0)
              : BoxSpecAttribute().width(100.0);
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
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<BoxSpecAttribute>());
      });

      test('different generic types create different builder types', () {
        final boxBuilder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final flexBuilder = ContextVariantBuilder<FlexSpecAttribute>(
          (context) => FlexSpecAttribute(),
        );

        expect(boxBuilder.runtimeType, isNot(equals(flexBuilder.runtimeType)));
      });

      test('can work with base SpecAttribute type', () {
        final builder = ContextVariantBuilder<StyleAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<StyleAttribute>());
        expect(result, isA<BoxSpecAttribute>());
      });
    });

    group('MultiVariant integration', () {
      test('can be combined with AND operator', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final contextVariant = ContextVariant('test', (context) => true);

        final combined = builder & contextVariant;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.and);
        expect(combined.variants, contains(builder));
        expect(combined.variants, contains(contextVariant));
      });

      test('can be combined with OR operator', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        const namedVariant = NamedVariant('primary');

        final combined = builder | namedVariant;

        expect(combined, isA<MultiVariant>());
        expect(combined.operatorType, MultiVariantOperator.or);
        expect(combined.variants, contains(builder));
        expect(combined.variants, contains(namedVariant));
      });

      test('can be negated with NOT operation', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final notVariant = not(builder);

        expect(notVariant, isA<MultiVariant>());
        expect(notVariant.operatorType, MultiVariantOperator.not);
        expect(notVariant.variants.first, builder);
      });
    });

    group('Complex scenarios', () {
      test(
        'function can return different attributes based on complex logic',
        () {
          final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
            final size = context.size ?? const Size(800, 600);
            final width = switch (size.width) {
              <= 480 => 50.0,
              <= 768 => 100.0,
              <= 1024 => 150.0,
              _ => 200.0,
            };
            return BoxSpecAttribute().width(width);
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
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          return BoxSpecAttribute(
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
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          throw Exception('Test exception');
        });

        expect(() => builder.build(MockBuildContext()), throwsException);
      });

      test('can capture variables from outer scope', () {
        const baseWidth = 50.0;
        const multiplier = 3;

        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          return BoxSpecAttribute().width(baseWidth * multiplier);
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
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute(),
        );

        final result = builder.build(MockBuildContext());
        expect(result, isA<BoxSpecAttribute>());
      });

      test('function parameters are properly typed', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          // This should compile without issues - context is properly typed
          expect(context, isA<BuildContext>());
          return BoxSpecAttribute().width(100.0);
        });

        builder.build(MockBuildContext());
      });

      test('maintains const constructor', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        expect(
          () => ContextVariantBuilder<BoxSpecAttribute>(builderFunction),
          returnsNormally,
        );
      });
    });

    group('Performance considerations', () {
      test('creating many builders is efficient', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          ContextVariantBuilder<BoxSpecAttribute>(
            (context) => BoxSpecAttribute().width(i.toDouble()),
          );
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('build method calls are efficient', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final context = MockBuildContext();
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          builder.build(context);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });

      test('key generation is efficient', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          builder.key;
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });

      test('equality comparison is efficient', () {
        BoxSpecAttribute builderFunction(BuildContext context) {
          return BoxSpecAttribute().width(100.0);
        }

        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          builderFunction,
        );
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          builder1 == builder2;
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });
    });

    group('Integration with other Mix components', () {
      test('can be used in Style resolution context', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );

        // ContextVariantBuilder should integrate with the broader Mix system
        expect(builder, isA<Variant>());
        expect(builder.key, isA<String>());
        expect(builder.key.isNotEmpty, isTrue);
      });

      test('works with VariantSpecAttribute wrapper', () {
        final builder = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final style = BoxSpecAttribute().height(200.0);
        final variantAttr = VariantStyleAttribute(builder, style);

        expect(variantAttr.variant, builder);
        expect(variantAttr.value, style);
        expect(variantAttr.mergeKey, builder.key);
      });

      test('key works as mergeKey for VariantSpecAttribute', () {
        final builder1 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(100.0),
        );
        final builder2 = ContextVariantBuilder<BoxSpecAttribute>(
          (context) => BoxSpecAttribute().width(200.0),
        );

        final style1 = VariantStyleAttribute(
          builder1,
          BoxSpecAttribute().height(100.0),
        );
        final style2 = VariantStyleAttribute(
          builder2,
          BoxSpecAttribute().height(200.0),
        );

        expect(style1.mergeKey, builder1.key);
        expect(style2.mergeKey, builder2.key);
        expect(style1.mergeKey, isNot(equals(style2.mergeKey)));
      });
    });

    group('Documentation and usage patterns', () {
      test('demonstrates context-based styling pattern', () {
        // This test documents common usage patterns
        final responsiveBuilder = ContextVariantBuilder<BoxSpecAttribute>((
          context,
        ) {
          final size = context.size ?? const Size(800, 600);
          return BoxSpecAttribute().width(size.width > 768 ? 200.0 : 100.0);
        });

        final result = responsiveBuilder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 200.0);
        expect(constraints?.maxWidth, 200.0); // MockBuildContext width is 800
      });

      test('demonstrates theme-based styling pattern', () {
        final themeBuilder = ContextVariantBuilder<BoxSpecAttribute>((context) {
          // In a real scenario, this would access Theme.of(context)
          // For testing, we'll simulate theme-based logic
          return BoxSpecAttribute().width(120.0);
        });

        final result = themeBuilder.build(MockBuildContext());
        final context = MockBuildContext();
        final constraints = result.resolve(context).constraints;
        expect(constraints?.minWidth, 120.0);
        expect(constraints?.maxWidth, 120.0);
      });

      test('demonstrates utility for conditional attribute creation', () {
        final conditionalBuilder = ContextVariantBuilder<BoxSpecAttribute>((
          context,
        ) {
          // Always return fixed size for this test
          return BoxSpecAttribute(
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
